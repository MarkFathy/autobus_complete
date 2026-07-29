import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';

class JoinRoomUseCase implements BaseUseCase<void, String> {
  final RoomRepository repository;

  JoinRoomUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String roomCode) async {
    return await repository.joinRoom(roomCode: roomCode);
  }
}
