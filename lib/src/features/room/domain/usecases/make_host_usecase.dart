import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class MakeHostParams extends Equatable {
  final String roomCode;
  final String newHostId;

  const MakeHostParams({
    required this.roomCode,
    required this.newHostId,
  });

  @override
  List<Object?> get props => [roomCode, newHostId];
}

class MakeHostUseCase implements BaseUseCase<void, MakeHostParams> {
  final RoomRepository repository;

  MakeHostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MakeHostParams params) async => repository.makeHost(
      roomCode: params.roomCode,
      newHostId: params.newHostId,
    );
}
