import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateRoomSettingsParams extends Equatable {
  final String roomCode;
  final int rounds;
  final List<RoomCategoryEntity> categories;

  const UpdateRoomSettingsParams({
    required this.roomCode,
    required this.rounds,
    required this.categories,
  });

  @override
  List<Object?> get props => [roomCode, rounds, categories];
}

class UpdateRoomSettingsUseCase implements BaseUseCase<void, UpdateRoomSettingsParams> {
  final RoomRepository repository;

  UpdateRoomSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateRoomSettingsParams params) async {
    return await repository.updateRoomSettings(
      roomCode: params.roomCode,
      rounds: params.rounds,
      categories: params.categories,
    );
  }
}
