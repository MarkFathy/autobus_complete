import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAccountUseCase implements BaseUseCase<void, NoParams> {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async => repository.deleteAccount();
}
