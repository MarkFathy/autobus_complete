import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUseCase implements BaseUseCase<void, String> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) async => repository.sendPasswordResetEmail(email);
}
