import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/room/data/datasources/room_remote_data_source.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  Failure _failure(String tag, Object e) {
    debugPrint('[$tag]: $e');
    return const Failure(ServerException(0, 'Something went wrong', null));
  }

  @override
  Future<Either<Failure, List<RoomCategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.getCategories', e));
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
    } on Object catch (e) {
      return Left(_failure('RoomRepository.createRoom', e));
    }
  }

  @override
  Future<Either<Failure, void>> joinRoom({required String roomCode}) async {
    try {
      await remoteDataSource.joinRoom(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.joinRoom', e));
    }
  }

  @override
  Stream<Either<Failure, RoomEntity>> listenToRoom({required String roomCode}) => remoteDataSource
        .listenToRoom(roomCode: roomCode)
        .map<Either<Failure, RoomEntity>>((roomModel) {
          if (roomModel == null) {
            return const Left(Failure(ServerException(0, 'Room was closed', null)));
          }
          return Right(roomModel);
        })
        .handleError((Object error) {
          debugPrint('[RoomRepository.listenToRoom]: $error');
          return const Left<Failure, RoomEntity>(
            Failure(ServerException(0, 'Something went wrong', null)),
          );
        });

  @override
  Future<Either<Failure, void>> toggleReadyStatus({required String roomCode}) async {
    try {
      await remoteDataSource.toggleReadyStatus(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.toggleReadyStatus', e));
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
    } on Object catch (e) {
      return Left(_failure('RoomRepository.updateRoomSettings', e));
    }
  }

  @override
  Future<Either<Failure, void>> startGame({required String roomCode}) async {
    try {
      await remoteDataSource.startGame(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.startGame', e));
    }
  }

  @override
  Future<Either<Failure, void>> playAgain({required String roomCode}) async {
    try {
      await remoteDataSource.playAgain(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.playAgain', e));
    }
  }

  @override
  Future<Either<Failure, void>> leaveRoom({required String roomCode}) async {
    try {
      await remoteDataSource.leaveRoom(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.leaveRoom', e));
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
    } on Object catch (e) {
      return Left(_failure('RoomRepository.makeHost', e));
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
    } on Object catch (e) {
      return Left(_failure('RoomRepository.kickPlayer', e));
    }
  }

  @override
  Future<Either<Failure, void>> startNextRound({
    required String roomCode,
  }) async {
    try {
      await remoteDataSource.startNextRound(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.startNextRound', e));
    }
  }

  @override
  Future<Either<Failure, void>> submitRoundAnswers({
    required String roomCode,
    required Map<String, String> answers,
  }) async {
    try {
      await remoteDataSource.submitRoundAnswers(
        roomCode: roomCode,
        answers: answers,
      );
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.submitRoundAnswers', e));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategoryScore({
    required String roomCode,
    required String playerId,
    required String categoryId,
    required int score,
  }) async {
    try {
      await remoteDataSource.updateCategoryScore(
        roomCode: roomCode,
        playerId: playerId,
        categoryId: categoryId,
        score: score,
      );
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.updateCategoryScore', e));
    }
  }

  @override
  Future<Either<Failure, void>> endGame({required String roomCode}) async {
    try {
      await remoteDataSource.endGame(roomCode: roomCode);
      return const Right(null);
    } on Object catch (e) {
      return Left(_failure('RoomRepository.endGame', e));
    }
  }
}
