import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/room/domain/abstract_repository/room_repository.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:dartz/dartz.dart';

class GetCategoriesUseCase implements BaseUseCase<List<RoomCategoryEntity>, NoParams> {
  final RoomRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RoomCategoryEntity>>> call(NoParams params) async => repository.getCategories();
}
