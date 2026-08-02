import 'package:autobus_complete/src/features/profile/domain/entities/profile_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
  });

  factory ProfileModel.fromFirebaseUser(User user) => ProfileModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL,
    );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: (json['id'] as String?) ?? (json['uid'] as String?) ?? '',
        name: (json['name'] as String?) ?? '',
        email: (json['email'] as String?) ?? '',
        photoUrl: json['photoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
  }) => ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
}
