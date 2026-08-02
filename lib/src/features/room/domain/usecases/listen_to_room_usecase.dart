import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';

class ListenToRoomUseCase {
  final RoomRepository repository;

  ListenToRoomUseCase(this.repository);

  Stream<Either<Failure, RoomEntity>> call(String roomCode) => repository.listenToRoom(roomCode: roomCode);
}
