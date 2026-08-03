import 'package:equatable/equatable.dart';

class ComplaintEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userPhoto;
  final String type; // 'complaint' or 'suggestion'
  final String title;
  final String message;
  final String status; // 'pending' or 'replied'
  final String? adminReply;
  final DateTime? replyAt;
  final DateTime createdAt;

  const ComplaintEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    required this.title,
    required this.message,
    required this.status,
    required this.createdAt,
    this.userPhoto,
    this.adminReply,
    this.replyAt,
  });

  bool get isReplied => status == 'replied' || (adminReply != null && adminReply!.trim().isNotEmpty);

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userEmail,
    userPhoto,
    type,
    title,
    message,
    status,
    adminReply,
    replyAt,
    createdAt,
  ];
}
