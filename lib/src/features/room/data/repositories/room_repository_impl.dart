import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/room/data/datasources/room_remote_data_source.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RoomCategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, String>> createRoom({
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    try {
      final roomCode = await remoteDataSource.createRoom(
        rounds: rounds,
        categories: categories,
      );
      return Right(roomCode);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> joinRoom({required String roomCode}) async {
    try {
      await remoteDataSource.joinRoom(roomCode: roomCode);
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Stream<Either<Failure, RoomEntity>> listenToRoom({required String roomCode}) {
    return remoteDataSource
        .listenToRoom(roomCode: roomCode)
        .map<Either<Failure, RoomEntity>>((roomModel) {
          if (roomModel == null) {
            return Left(Failure(ServerException(0, false, "Room was closed", null)));
          }
          return Right(roomModel);
        })
        .handleError((error) {
          final msg = error.toString().replaceAll('Exception: ', '');
          return Left<Failure, RoomEntity>(
            Failure(ServerException(0, false, msg, null)),
          );
        });
  }

  @override
  Future<Either<Failure, void>> toggleReadyStatus({required String roomCode}) async {
    try {
      await remoteDataSource.toggleReadyStatus(roomCode: roomCode);
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> updateRoomSettings({
    required String roomCode,
    required int rounds,
    required List<RoomCategoryEntity> categories,
  }) async {
    try {
      await remoteDataSource.updateRoomSettings(
        roomCode: roomCode,
        rounds: rounds,
        categories: categories,
      );
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> startGame({required String roomCode}) async {
    try {
      await remoteDataSource.startGame(roomCode: roomCode);
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> playAgain({required String roomCode}) async {
    try {
      await remoteDataSource.playAgain(roomCode: roomCode);
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> leaveRoom({required String roomCode}) async {
    try {
      await remoteDataSource.leaveRoom(roomCode: roomCode);
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> makeHost({
    required String roomCode,
    required String newHostId,
  }) async {
    try {
      await remoteDataSource.makeHost(
        roomCode: roomCode,
        newHostId: newHostId,
      );
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }

  @override
  Future<Either<Failure, void>> kickPlayer({
    required String roomCode,
    required String playerId,
  }) async {
    try {
      await remoteDataSource.kickPlayer(
        roomCode: roomCode,
        playerId: playerId,
      );
      return const Right(null);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      return Left(Failure(ServerException(0, false, msg, null)));
    }
  }
}
