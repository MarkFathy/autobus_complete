import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/abstract_repository/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteComplaintUseCase implements BaseUseCase<void, String> {
  final ComplaintsRepository repository;

  DeleteComplaintUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) => repository.deleteComplaint(params);
}
