import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ComplaintsRepository {
  Future<Either<Failure, void>> submitComplaint(ComplaintEntity complaint);
  Future<Either<Failure, void>> deleteComplaint(String complaintId);
  Stream<List<ComplaintEntity>> getComplaintsStream(String userId);
}
