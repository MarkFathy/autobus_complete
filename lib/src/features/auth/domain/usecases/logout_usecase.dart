import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase implements BaseUseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async => repository.logout();
}
