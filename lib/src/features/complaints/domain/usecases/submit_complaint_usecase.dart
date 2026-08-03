import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/core/usecases/usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/abstract_repository/complaints_repository.dart';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';

class SubmitComplaintUseCase implements BaseUseCase<void, ComplaintEntity> {
  final ComplaintsRepository repository;

  SubmitComplaintUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ComplaintEntity params) => repository.submitComplaint(params);
}
