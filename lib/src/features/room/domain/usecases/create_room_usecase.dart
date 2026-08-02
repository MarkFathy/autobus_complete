import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateRoomParams extends Equatable {
  final int rounds;
  final List<RoomCategoryEntity> categories;

  const CreateRoomParams({
    required this.rounds,
    required this.categories,
  });

  @override
  List<Object?> get props => [rounds, categories];
}

class CreateRoomUseCase implements BaseUseCase<String, CreateRoomParams> {
  final RoomRepository repository;

  CreateRoomUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateRoomParams params) async => repository.createRoom(
      rounds: params.rounds,
      categories: params.categories,
    );
}
