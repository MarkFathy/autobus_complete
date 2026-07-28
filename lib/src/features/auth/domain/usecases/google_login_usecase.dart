import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:autobus_complete/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GoogleLoginUseCase implements BaseUseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}
