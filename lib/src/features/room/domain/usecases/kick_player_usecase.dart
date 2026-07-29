import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class KickPlayerParams extends Equatable {
  final String roomCode;
  final String playerId;

  const KickPlayerParams({
    required this.roomCode,
    required this.playerId,
  });

  @override
  List<Object?> get props => [roomCode, playerId];
}

class KickPlayerUseCase implements BaseUseCase<void, KickPlayerParams> {
  final RoomRepository repository;

  KickPlayerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(KickPlayerParams params) async {
    return await repository.kickPlayer(
      roomCode: params.roomCode,
      playerId: params.playerId,
    );
  }
}
