import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/profile/domain/abstract_repository/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserProfileUseCase implements BaseUseCase<UserEntity, NoParams> {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
