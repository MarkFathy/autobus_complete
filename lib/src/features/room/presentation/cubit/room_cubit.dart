import 'dart:async';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/data/datasources/room_remote_data_source.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/create_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/get_categories_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/join_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/kick_player_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/leave_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/listen_to_room_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/make_host_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/play_again_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/start_game_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/toggle_ready_usecase.dart';
import 'package:autobus_complete/src/features/room/domain/usecases/update_room_settings_usecase.dart';
import 'package:autobus_complete/src/features/room/presentation/cubit/room_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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

  StreamSubscription? _roomSubscription;
  RoomEntity? currentRoom;
  List<RoomCategoryEntity> availableCategories = [];

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
  }) : super(RoomInitial());

  Future<List<RoomCategoryEntity>> fetchCategories() async {
    final result = await getCategoriesUseCase(NoParams());
    return result.fold(
      (failure) => [],
      (categories) {
        availableCategories = categories;
        return categories;
      },
    );
  }

  Future<void> createRoom({
    int rounds = 5,
    List<RoomCategoryEntity>? categories,
  }) async {
    emit(RoomLoading());
    List<RoomCategoryEntity> selectedCategories = categories ?? [];
    if (selectedCategories.isEmpty) {
      selectedCategories = await fetchCategories();
    }

    final result = await createRoomUseCase(
      CreateRoomParams(rounds: rounds, categories: selectedCategories),
    );

    await result.fold(
      (failure) async => emit(RoomError(failure.serverException.message)),
      (roomCode) async {
        await listenToRoom(roomCode);
        emit(RoomCreatedSuccess(roomCode));
      },
    );
  }

  Future<void> joinRoom(String roomCode) async {
    emit(RoomLoading());
    final result = await joinRoomUseCase(roomCode);
    await result.fold(
      (failure) async => emit(RoomError(failure.serverException.message)),
      (_) async {
        await listenToRoom(roomCode);
        emit(RoomJoinedSuccess(roomCode));
      },
    );
  }

  Future<void> listenToRoom(String roomCode) async {
    _roomSubscription?.cancel();
    final completer = Completer<void>();
    bool isFirstSnapshot = true;

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
            final isCurrentPlayerInRoom = currentUserId != null &&
                roomEntity.players.any((p) => p.id == currentUserId);

            if (!isCurrentPlayerInRoom && currentRoom != null) {
              _roomSubscription?.cancel();
              _roomSubscription = null;
              currentRoom = null;
              if (isFirstSnapshot && !completer.isCompleted) {
                completer.complete();
              }
              emit(RoomKickedByHost());
              return;
            }

            currentRoom = roomEntity;
            if (isFirstSnapshot && !completer.isCompleted) {
              isFirstSnapshot = false;
              completer.complete();
            }
            if (roomEntity.status == 'playing') {
              emit(RoomGameStarted(roomEntity));
            } else {
              emit(RoomUpdated(roomEntity));
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
    await toggleReadyUseCase(currentRoom!.roomCode);
  }

  Future<void> updateRoomSettings({
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    if (currentRoom == null) return;
    await updateRoomSettingsUseCase(
      UpdateRoomSettingsParams(
        roomCode: currentRoom!.roomCode,
        rounds: rounds,
        categories: categories,
      ),
    );
  }

  Future<void> startGame() async {
    if (currentRoom == null) return;
    final result = await startGameUseCase(currentRoom!.roomCode);
    result.fold(
      (failure) => emit(RoomError(failure.serverException.message)),
      (_) {},
    );
  }

  Future<void> playAgain() async {
    if (currentRoom == null) return;
    final result = await playAgainUseCase(currentRoom!.roomCode);
    result.fold(
      (failure) => emit(RoomError(failure.serverException.message)),
      (_) {},
    );
  }

  Future<void> leaveRoom() async {
    final roomCodeToLeave = currentRoom?.roomCode;
    _roomSubscription?.cancel();
    _roomSubscription = null;
    currentRoom = null;

    if (roomCodeToLeave != null) {
      await leaveRoomUseCase(roomCodeToLeave);
    }
    emit(RoomLeftSuccess());
  }

  Future<void> makeHost(String newHostId) async {
    if (currentRoom == null) return;
    final result = await makeHostUseCase(
      MakeHostParams(
        roomCode: currentRoom!.roomCode,
        newHostId: newHostId,
      ),
    );
    result.fold(
      (failure) => emit(RoomError(failure.serverException.message)),
      (_) {},
    );
  }

  Future<void> kickPlayer(String playerId) async {
    if (currentRoom == null) return;
    final result = await kickPlayerUseCase(
      KickPlayerParams(
        roomCode: currentRoom!.roomCode,
        playerId: playerId,
      ),
    );
    result.fold(
      (failure) => emit(RoomError(failure.serverException.message)),
      (_) {},
    );
  }

  Future<void> startNextRound() async {
    if (currentRoom == null) return;
    try {
      await sl<RoomRemoteDataSource>().startNextRound(
        roomCode: currentRoom!.roomCode,
      );
    } catch (_) {}
  }

  Future<void> submitRoundAnswers(Map<String, String> answers) async {
    if (currentRoom == null) return;
    try {
      await sl<RoomRemoteDataSource>().submitRoundAnswers(
        roomCode: currentRoom!.roomCode,
        answers: answers,
      );
    } catch (_) {}
  }

  Future<void> updateCategoryScore({
    required String playerId,
    required String categoryId,
    required int score,
  }) async {
    if (currentRoom == null) return;
    try {
      await sl<RoomRemoteDataSource>().updateCategoryScore(
        roomCode: currentRoom!.roomCode,
        playerId: playerId,
        categoryId: categoryId,
        score: score,
      );
    } catch (_) {}
  }

  Future<void> endGame() async {
    if (currentRoom == null) return;
    try {
      await sl<RoomRemoteDataSource>().endGame(
        roomCode: currentRoom!.roomCode,
      );
    } catch (_) {}
  }

  Future<void> copyRoomCodeToClipboard(String roomCode) async {
    await Clipboard.setData(ClipboardData(text: roomCode));
    emit(RoomCodeCopiedSuccess(roomCode));
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    return super.close();
  }
}
