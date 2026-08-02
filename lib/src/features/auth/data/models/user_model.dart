import 'package:autobus_complete/src/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User user) => UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL,
    );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as String?) ?? '',
        email: (json['email'] as String?) ?? '',
        name: (json['name'] as String?) ?? '',
        photoUrl: json['photoUrl'] as String?,
      );
}
