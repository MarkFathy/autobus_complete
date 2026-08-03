import 'package:autobus_complete/src/core/error/exceptions.dart';
import 'package:autobus_complete/src/core/error/failure.dart';
import 'package:autobus_complete/src/features/complaints/data/datasources/complaints_remote_data_source.dart';
import 'package:autobus_complete/src/features/complaints/data/models/complaint_model.dart';
import 'package:autobus_complete/src/features/complaints/domain/abstract_repository/complaints_repository.dart';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:dartz/dartz.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final ComplaintsRemoteDataSource remoteDataSource;

  ComplaintsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitComplaint(ComplaintEntity complaint) async {
    try {
      final model = ComplaintModel(
        id: complaint.id,
        userId: complaint.userId,
        userName: complaint.userName,
        userEmail: complaint.userEmail,
        userPhoto: complaint.userPhoto,
        type: complaint.type,
        title: complaint.title,
        message: complaint.message,
        status: complaint.status,
        adminReply: complaint.adminReply,
        replyAt: complaint.replyAt,
        createdAt: complaint.createdAt,
      );
      await remoteDataSource.submitComplaint(model);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComplaint(String complaintId) async {
    try {
      await remoteDataSource.deleteComplaint(complaintId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Stream<List<ComplaintEntity>> getComplaintsStream(String userId) => remoteDataSource.getComplaintsStream(userId);
}
