import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateCategoryScoreParams extends Equatable {
  final String roomCode;
  final String playerId;
  final String categoryId;
  final int score;

  const UpdateCategoryScoreParams({
    required this.roomCode,
    required this.playerId,
    required this.categoryId,
    required this.score,
  });

  @override
  List<Object?> get props => [roomCode, playerId, categoryId, score];
}

class UpdateCategoryScoreUseCase
    implements BaseUseCase<void, UpdateCategoryScoreParams> {
  final RoomRepository repository;

  UpdateCategoryScoreUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCategoryScoreParams params) async => repository.updateCategoryScore(
      roomCode: params.roomCode,
      playerId: params.playerId,
      categoryId: params.categoryId,
      score: params.score,
    );
}
