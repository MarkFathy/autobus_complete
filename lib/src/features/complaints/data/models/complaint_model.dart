import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.type,
    required super.title,
    required super.message,
    required super.status,
    required super.createdAt,
    super.userPhoto,
    super.adminReply,
    super.replyAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) {
        return dateVal.toDate();
      } else if (dateVal is String) {
        return DateTime.tryParse(dateVal) ?? DateTime.now();
      } else if (dateVal is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateVal);
      }
      return DateTime.now();
    }

    final reply =
        (json['adminReply'] as String?) ??
        (json['reply'] as String?) ??
        (json['admin_reply'] as String?) ??
        (json['response'] as String?);

    final statusVal =
        (json['status'] as String?) ?? ((reply != null && reply.trim().isNotEmpty) ? 'replied' : 'pending');

    return ComplaintModel(
      id: id,
      userId: (json['userId'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? 'User',
      userEmail: (json['userEmail'] as String?) ?? '',
      userPhoto: json['userPhoto'] as String?,
      type: (json['type'] as String?) ?? 'complaint',
      title: (json['title'] as String?) ?? '',
      message: (json['message'] as String?) ?? '',
      status: statusVal,
      adminReply: reply,
      replyAt: json['replyAt'] != null ? parseDate(json['replyAt']) : null,
      createdAt: json['createdAt'] != null ? parseDate(json['createdAt']) : DateTime.now(),
    );
  }

  factory ComplaintModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ComplaintModel.fromJson(doc.data() ?? {}, doc.id);

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'userEmail': userEmail,
    'userPhoto': userPhoto,
    'type': type,
    'title': title,
    'message': message,
    'status': status,
    'adminReply': adminReply,
    'replyAt': replyAt != null ? Timestamp.fromDate(replyAt!) : null,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
