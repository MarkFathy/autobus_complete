import 'dart:async';

import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/data/models/room_model.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/clean_stale_players_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/create_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/end_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/get_categories_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/join_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/kick_player_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/leave_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/listen_to_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/make_host_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/play_again_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_next_round_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/submit_round_answers_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/toggle_ready_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_category_score_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_player_heartbeat_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_room_settings_usecase.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomCubit extends Cubit<RoomState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateRoomUseCase createRoomUseCase;
  final JoinRoomUseCase joinRoomUseCase;
  final ListenToRoomUseCase listenToRoomUseCase;
  final ToggleReadyUseCase toggleReadyUseCase;
  final UpdateRoomSettingsUseCase updateRoomSettingsUseCase;
  final StartGameUseCase startGameUseCase;
  final PlayAgainUseCase playAgainUseCase;
  final LeaveRoomUseCase leaveRoomUseCase;
  final MakeHostUseCase makeHostUseCase;
  final KickPlayerUseCase kickPlayerUseCase;
  final StartNextRoundUseCase startNextRoundUseCase;
  final SubmitRoundAnswersUseCase submitRoundAnswersUseCase;
  final UpdateCategoryScoreUseCase updateCategoryScoreUseCase;
  final EndGameUseCase endGameUseCase;
  final UpdatePlayerHeartbeatUseCase updatePlayerHeartbeatUseCase;
  final CleanStalePlayersUseCase cleanStalePlayersUseCase;

  StreamSubscription<Either<Failure, RoomEntity>>? _roomSubscription;
  AppLifecycleListener? _lifecycleListener;
  Timer? _heartbeatTimer;
  RoomEntity? currentRoom;
  List<RoomCategoryEntity> availableCategories = [];
  bool? _pendingReadyStatus;

  RoomCubit({
    required this.getCategoriesUseCase,
    required this.createRoomUseCase,
    required this.joinRoomUseCase,
    required this.listenToRoomUseCase,
    required this.toggleReadyUseCase,
    required this.updateRoomSettingsUseCase,
    required this.startGameUseCase,
    required this.playAgainUseCase,
    required this.leaveRoomUseCase,
    required this.makeHostUseCase,
    required this.kickPlayerUseCase,
    required this.startNextRoundUseCase,
    required this.submitRoundAnswersUseCase,
    required this.updateCategoryScoreUseCase,
    required this.endGameUseCase,
    required this.updatePlayerHeartbeatUseCase,
    required this.cleanStalePlayersUseCase,
  }) : super(RoomInitial());

  Future<List<RoomCategoryEntity>> fetchCategories() async {
    final result = await getCategoriesUseCase(NoParams());
    return result.fold((failure) => [], (categories) {
      availableCategories = categories;
      return categories;
    });
  }

  Future<void> createRoom({int rounds = 5, List<RoomCategoryEntity>? categories}) async {
    emit(RoomLoading());
    var selectedCategories = categories ?? [];
    if (selectedCategories.isEmpty) {
      selectedCategories = await fetchCategories();
    }

    final result = await createRoomUseCase(CreateRoomParams(rounds: rounds, categories: selectedCategories));

    await result.fold((failure) async => emit(RoomError(failure.serverException.message)), (roomCode) async {
      await listenToRoom(roomCode);
      emit(RoomCreatedSuccess(roomCode));
    });
  }

  Future<void> joinRoom(String roomCode) async {
    emit(RoomLoading());
    final result = await joinRoomUseCase(roomCode);
    await result.fold((failure) async => emit(RoomError(failure.serverException.message)), (_) async {
      await listenToRoom(roomCode);
      emit(RoomJoinedSuccess(roomCode));
    });
  }

  void _initLifecycleListener() {
    _lifecycleListener?.dispose();
    _lifecycleListener = AppLifecycleListener(
      onDetach: () {
        if (currentRoom != null) {
          unawaited(leaveRoom());
        }
      },
    );
  }

  void _startHeartbeat(String roomCode) {
    _heartbeatTimer?.cancel();
    unawaited(updatePlayerHeartbeatUseCase(roomCode));
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (currentRoom != null) {
        unawaited(updatePlayerHeartbeatUseCase(roomCode));
      }
    });
  }

  void _stopHeartbeatAndListener() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
  }

  void _checkAndCleanStalePlayers(RoomEntity room) {
    final now = DateTime.now().millisecondsSinceEpoch;
    const timeoutMs = 10000;

    final hasStalePlayer = room.players.any((p) => p.lastSeen != null && (now - p.lastSeen!) > timeoutMs);

    if (!hasStalePlayer) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final activePlayers = room.players.where((p) => p.lastSeen != null && (now - p.lastSeen!) <= timeoutMs).toList();

    final isCleaner = activePlayers.isNotEmpty && activePlayers.first.id == currentUserId;
    if (isCleaner) {
      unawaited(cleanStalePlayersUseCase(CleanStalePlayersParams(roomCode: room.roomCode)));
    }
  }

  bool _isVisuallyDifferent(RoomEntity? oldRoom, RoomEntity newRoom) {
    if (oldRoom == null) return true;
    if (oldRoom.status != newRoom.status) return true;
    if (oldRoom.hostId != newRoom.hostId) return true;
    if (oldRoom.rounds != newRoom.rounds) return true;
    if (oldRoom.currentRound != newRoom.currentRound) return true;
    if (oldRoom.currentLetter != newRoom.currentLetter) return true;
    if (oldRoom.categories.length != newRoom.categories.length) return true;
    if (oldRoom.players.length != newRoom.players.length) return true;
    if (oldRoom.roundScores != newRoom.roundScores) return true;
    if (oldRoom.roundAnswers != newRoom.roundAnswers) return true;

    for (var i = 0; i < oldRoom.players.length; i++) {
      final p1 = oldRoom.players[i];
      final p2 = newRoom.players[i];
      if (p1.id != p2.id ||
          p1.isReady != p2.isReady ||
          p1.isHost != p2.isHost ||
          p1.score != p2.score ||
          p1.name != p2.name ||
          p1.photoUrl != p2.photoUrl) {
        return true;
      }
    }
    return false;
  }

  Future<void> listenToRoom(String roomCode) async {
    _initLifecycleListener();
    _startHeartbeat(roomCode);
    unawaited(_roomSubscription?.cancel());
    final completer = Completer<void>();
    var isFirstSnapshot = true;

    _roomSubscription = listenToRoomUseCase(roomCode).listen(
      (result) {
        result.fold(
          (failure) {
            if (isFirstSnapshot && !completer.isCompleted) {
              completer.complete();
            }
            emit(RoomError(failure.serverException.message));
          },
          (roomEntity) {
            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final isCurrentPlayerInRoom = currentUserId != null && roomEntity.players.any((p) => p.id == currentUserId);

            if (!isCurrentPlayerInRoom && currentRoom != null) {
              _stopHeartbeatAndListener();
              unawaited(_roomSubscription?.cancel());
              _roomSubscription = null;
              currentRoom = null;
              if (isFirstSnapshot && !completer.isCompleted) {
                completer.complete();
              }
              emit(RoomKickedByHost());
              return;
            }

            // Apply pending optimistic ready status if server snapshot hasn't caught up yet
            var adjustedRoomEntity = roomEntity;
            if (_pendingReadyStatus != null && currentUserId != null) {
              final serverPlayer = roomEntity.players.firstWhere(
                (p) => p.id == currentUserId,
                orElse: () => RoomPlayerModel(id: currentUserId, name: ''),
              );
              if (serverPlayer.isReady == _pendingReadyStatus) {
                // Server has confirmed our toggle!
                _pendingReadyStatus = null;
              } else {
                // Server snapshot is still old, override isReady with pending status to prevent flicker
                final overriddenPlayers = roomEntity.players.map((p) {
                  if (p.id == currentUserId) {
                    return RoomPlayerModel(
                      id: p.id,
                      name: p.name,
                      photoUrl: p.photoUrl,
                      isHost: p.isHost,
                      isReady: _pendingReadyStatus!,
                      score: p.score,
                      lastSeen: p.lastSeen,
                    );
                  }
                  return p;
                }).toList();
                adjustedRoomEntity = RoomModel(
                  roomCode: roomEntity.roomCode,
                  hostId: roomEntity.hostId,
                  status: roomEntity.status,
                  rounds: roomEntity.rounds,
                  currentRound: roomEntity.currentRound,
                  currentLetter: roomEntity.currentLetter,
                  usedLetters: roomEntity.usedLetters,
                  roundAnswers: roomEntity.roundAnswers,
                  roundScores: roomEntity.roundScores,
                  categories: roomEntity.categories,
                  players: overriddenPlayers,
                );
              }
            }

            final needsEmitting = isFirstSnapshot || _isVisuallyDifferent(currentRoom, adjustedRoomEntity);
            currentRoom = adjustedRoomEntity;
            _checkAndCleanStalePlayers(adjustedRoomEntity);

            if (isFirstSnapshot && !completer.isCompleted) {
              isFirstSnapshot = false;
              completer.complete();
            }

            if (needsEmitting) {
              if (adjustedRoomEntity.status == 'playing') {
                emit(RoomGameStarted(adjustedRoomEntity));
              } else {
                emit(RoomUpdated(adjustedRoomEntity));
              }
            }
          },
        );
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );
  }

  Future<void> toggleReadyStatus() async {
    if (currentRoom == null) return;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final currentPlayer = currentRoom!.players.firstWhere(
      (p) => p.id == currentUserId,
      orElse: () => RoomPlayerModel(id: currentUserId, name: ''),
    );
    if (currentPlayer.isHost) return;

    final newReadyStatus = !currentPlayer.isReady;
    _pendingReadyStatus = newReadyStatus;

    // Optimistic UI Update for zero-lag button response
    final updatedPlayers = currentRoom!.players.map((p) {
      if (p.id == currentUserId) {
        return RoomPlayerModel(
          id: p.id,
          name: p.name,
          photoUrl: p.photoUrl,
          isHost: p.isHost,
          isReady: newReadyStatus,
          score: p.score,
          lastSeen: p.lastSeen,
        );
      }
      return p;
    }).toList();

    currentRoom = RoomModel(
      roomCode: currentRoom!.roomCode,
      hostId: currentRoom!.hostId,
      status: currentRoom!.status,
      rounds: currentRoom!.rounds,
      currentRound: currentRoom!.currentRound,
      currentLetter: currentRoom!.currentLetter,
      usedLetters: currentRoom!.usedLetters,
      roundAnswers: currentRoom!.roundAnswers,
      roundScores: currentRoom!.roundScores,
      categories: currentRoom!.categories,
      players: updatedPlayers,
    );

    emit(RoomUpdated(currentRoom!));

    final result = await toggleReadyUseCase(currentRoom!.roomCode);
    result.fold(
      (failure) {
        _pendingReadyStatus = null;
        if (currentRoom != null) {
          final revertedPlayers = currentRoom!.players.map((p) {
            if (p.id == currentUserId) {
              return RoomPlayerModel(
                id: p.id,
                name: p.name,
                photoUrl: p.photoUrl,
                isHost: p.isHost,
                isReady: !newReadyStatus,
                score: p.score,
                lastSeen: p.lastSeen,
              );
            }
            return p;
          }).toList();
          currentRoom = RoomModel(
            roomCode: currentRoom!.roomCode,
            hostId: currentRoom!.hostId,
            status: currentRoom!.status,
            rounds: currentRoom!.rounds,
            currentRound: currentRoom!.currentRound,
            currentLetter: currentRoom!.currentLetter,
            usedLetters: currentRoom!.usedLetters,
            roundAnswers: currentRoom!.roundAnswers,
            roundScores: currentRoom!.roundScores,
            categories: currentRoom!.categories,
            players: revertedPlayers,
          );
          emit(RoomUpdated(currentRoom!));
        }
        emit(RoomError(failure.serverException.message));
      },
      (_) {},
    );
  }

  Future<void> updateRoomSettings({required int rounds, required List<RoomCategoryEntity> categories}) async {
    if (currentRoom == null) return;
    await updateRoomSettingsUseCase(
      UpdateRoomSettingsParams(roomCode: currentRoom!.roomCode, rounds: rounds, categories: categories),
    );
  }

  Future<void> startGame() async {
    if (currentRoom == null) return;
    final result = await startGameUseCase(currentRoom!.roomCode);
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> playAgain() async {
    if (currentRoom == null) return;
    final result = await playAgainUseCase(currentRoom!.roomCode);
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> leaveRoom() async {
    _stopHeartbeatAndListener();
    final roomCodeToLeave = currentRoom?.roomCode;
    unawaited(_roomSubscription?.cancel());
    _roomSubscription = null;
    currentRoom = null;

    if (roomCodeToLeave != null) {
      await leaveRoomUseCase(roomCodeToLeave);
    }
    emit(RoomLeftSuccess());
  }

  Future<void> makeHost(String newHostId) async {
    if (currentRoom == null) return;
    final result = await makeHostUseCase(MakeHostParams(roomCode: currentRoom!.roomCode, newHostId: newHostId));
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> kickPlayer(String playerId) async {
    if (currentRoom == null) return;
    final result = await kickPlayerUseCase(KickPlayerParams(roomCode: currentRoom!.roomCode, playerId: playerId));
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> startNextRound() async {
    if (currentRoom == null) return;
    final result = await startNextRoundUseCase(currentRoom!.roomCode);
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> submitRoundAnswers(Map<String, String> answers) async {
    if (currentRoom == null) return;
    final result = await submitRoundAnswersUseCase(
      SubmitRoundAnswersParams(roomCode: currentRoom!.roomCode, answers: answers),
    );
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> updateCategoryScore({required String playerId, required String categoryId, required int score}) async {
    if (currentRoom == null) return;
    final result = await updateCategoryScoreUseCase(
      UpdateCategoryScoreParams(
        roomCode: currentRoom!.roomCode,
        playerId: playerId,
        categoryId: categoryId,
        score: score,
      ),
    );
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> endGame() async {
    if (currentRoom == null) return;
    final result = await endGameUseCase(currentRoom!.roomCode);
    result.fold((failure) => emit(RoomError(failure.serverException.message)), (_) {});
  }

  Future<void> copyRoomCodeToClipboard(String roomCode) async {
    await Clipboard.setData(ClipboardData(text: roomCode));
    emit(RoomCodeCopiedSuccess(roomCode));
  }

  @override
  Future<void> close() {
    _stopHeartbeatAndListener();
    unawaited(_roomSubscription?.cancel());
    return super.close();
  }
}
