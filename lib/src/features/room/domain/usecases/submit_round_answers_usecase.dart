import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SubmitRoundAnswersParams extends Equatable {
  final String roomCode;
  final Map<String, String> answers;

  const SubmitRoundAnswersParams({
    required this.roomCode,
    required this.answers,
  });

  @override
  List<Object?> get props => [roomCode, answers];
}

class SubmitRoundAnswersUseCase
    implements BaseUseCase<void, SubmitRoundAnswersParams> {
  final RoomRepository repository;

  SubmitRoundAnswersUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitRoundAnswersParams params) async => repository.submitRoundAnswers(
      roomCode: params.roomCode,
      answers: params.answers,
    );
}
