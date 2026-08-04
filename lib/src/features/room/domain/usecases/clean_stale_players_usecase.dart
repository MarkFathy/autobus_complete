import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CleanStalePlayersParams extends Equatable {
  final String roomCode;
  final int timeoutSeconds;

  const CleanStalePlayersParams({
    required this.roomCode,
    this.timeoutSeconds = 10,
  });

  @override
  List<Object?> get props => [roomCode, timeoutSeconds];
}

class CleanStalePlayersUseCase implements BaseUseCase<void, CleanStalePlayersParams> {
  final RoomRepository repository;

  CleanStalePlayersUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CleanStalePlayersParams params) async =>
      repository.cleanStalePlayers(
        roomCode: params.roomCode,
        timeoutSeconds: params.timeoutSeconds,
      );
}
