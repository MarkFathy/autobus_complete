import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';

abstract class RoomRepository {
  Future<Either<Failure, List<RoomCategoryEntity>>> getCategories();
  Future<Either<Failure, String>> createRoom({
    required int rounds,
    required List<RoomCategoryEntity> categories,
  });
  Future<Either<Failure, void>> joinRoom({required String roomCode});
  Stream<Either<Failure, RoomEntity>> listenToRoom({required String roomCode});
  Future<Either<Failure, void>> toggleReadyStatus({required String roomCode});
  Future<Either<Failure, void>> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  });
  Future<Either<Failure, void>> startGame({required String roomCode});
  Future<Either<Failure, void>> playAgain({required String roomCode});
  Future<Either<Failure, void>> leaveRoom({required String roomCode});
  Future<Either<Failure, void>> makeHost({
    required String roomCode,
    required String newHostId,
  });
  Future<Either<Failure, void>> kickPlayer({
    required String roomCode,
    required String playerId,
  });
  Future<Either<Failure, void>> startNextRound({required String roomCode});
  Future<Either<Failure, void>> submitRoundAnswers({
    required String roomCode,
    required Map<String, String> answers,
  });
  Future<Either<Failure, void>> updateCategoryScore({
    required String roomCode,
    required String playerId,
    required String categoryId,
    required int score,
  });
  Future<Either<Failure, void>> endGame({required String roomCode});
  Future<Either<Failure, void>> updatePlayerHeartbeat({required String roomCode});
  Future<Either<Failure, void>> cleanStalePlayers({
    required String roomCode,
    required int timeoutSeconds,
  });
}
