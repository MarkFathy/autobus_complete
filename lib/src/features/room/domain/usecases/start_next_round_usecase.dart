import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';

class StartNextRoundUseCase implements BaseUseCase<void, String> {
  final RoomRepository repository;

  StartNextRoundUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String roomCode) async => repository.startNextRound(roomCode: roomCode);
}
