import 'package:autobus_complete/src/features/complaints/domain/abstract_repository/complaints_repository.dart';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';

class GetComplaintsStreamUseCase {
  final ComplaintsRepository repository;

  GetComplaintsStreamUseCase(this.repository);

  Stream<List<ComplaintEntity>> call(String userId) => repository.getComplaintsStream(userId);
}
