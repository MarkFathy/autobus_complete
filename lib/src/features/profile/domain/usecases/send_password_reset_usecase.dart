import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/abstract_repository/profile_repository.dart';
import 'package:dartz/dartz.dart';

class SendPasswordResetUseCase implements BaseUseCase<void, NoParams> {
  final ProfileRepository repository;

  SendPasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.sendPasswordResetEmail();
  }
}
