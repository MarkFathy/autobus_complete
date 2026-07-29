import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/repository/profile_repository.dart';
import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileUseCase implements BaseUseCase<ProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
