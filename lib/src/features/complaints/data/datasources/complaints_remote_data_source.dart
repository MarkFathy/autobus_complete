import 'package:autobus_complete/src/features/complaints/data/models/complaint_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ComplaintsRemoteDataSource {
  Future<void> submitComplaint(ComplaintModel complaint);
  Future<void> deleteComplaint(String complaintId);
  Stream<List<ComplaintModel>> getComplaintsStream(String userId);
}

class ComplaintsRemoteDataSourceImpl implements ComplaintsRemoteDataSource {
  final FirebaseFirestore firestore;

  ComplaintsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> submitComplaint(ComplaintModel complaint) async {
    final docRef = firestore.collection('complaints').doc();
    final data = complaint.toJson();
    data['id'] = docRef.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
  }

  @override
  Future<void> deleteComplaint(String complaintId) async {
    await firestore.collection('complaints').doc(complaintId).delete();
  }

  @override
  Stream<List<ComplaintModel>> getComplaintsStream(String userId) =>
      firestore.collection('complaints').where('userId', isEqualTo: userId).snapshots().map((snapshot) {
        final list = snapshot.docs.map(ComplaintModel.fromSnapshot).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
}
