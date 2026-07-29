import 'dart:convert';
import 'dart:io';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/services/session_manager.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:autobus_complete/src/features/profile/data/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile();
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  });
  Future<void> sendPasswordResetEmail();
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final AuthLocalDataSource authLocalDataSource;

  ProfileRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.storage,
    required this.authLocalDataSource,
  });

  @override
  Future<ProfileModel> getUserProfile() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    final docSnapshot = await firestore.collection('users').doc(user.uid).get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      return ProfileModel(
        id: user.uid,
        name: data['name'] ?? user.displayName ?? '',
        email: data['email'] ?? user.email ?? '',
        photoUrl: data['photoUrl'] ?? user.photoURL,
      );
    }

    return ProfileModel.fromFirebaseUser(user);
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    File? imageFile,
    bool removeImage = false,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }

    String? photoUrl = user.photoURL;

    if (removeImage) {
      photoUrl = null;
      try {
        final ref = storage.ref().child('user_photos/${user.uid}.jpg');
        await ref.delete();
      } catch (_) {}
    } else if (imageFile != null) {
      try {
        final ref = storage.ref().child('user_photos/${user.uid}.jpg');
        await ref.putFile(imageFile);
        photoUrl = await ref.getDownloadURL();
      } catch (e) {
        try {
          final bytes = await imageFile.readAsBytes();
          final base64String = base64Encode(bytes);
          final generatedDataUrl = 'data:image/jpeg;base64,$base64String';
          if (generatedDataUrl.length < 800000) {
            photoUrl = generatedDataUrl;
          } else {
            photoUrl = user.photoURL;
          }
        } catch (_) {
          photoUrl = user.photoURL;
        }
      }
    }

    try {
      await user.updateDisplayName(name);
      if (photoUrl != null && !photoUrl.startsWith('data:image')) {
        await user.updatePhotoURL(photoUrl);
      }
    } catch (_) {}

    if (email != user.email && email.trim().isNotEmpty) {
      try {
        await user.verifyBeforeUpdateEmail(email);
      } catch (_) {}
    }

    final updatedData = {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };

    await firestore
        .collection('users')
        .doc(user.uid)
        .set(updatedData, SetOptions(merge: true));

    return ProfileModel(
      id: user.uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> sendPasswordResetEmail() async {
    final user = firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }
    await firebaseAuth.sendPasswordResetEmail(email: user.email!);
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        await firestore.collection('users').doc(user.uid).delete();
      } catch (_) {}
      await user.delete();
    }
    await authLocalDataSource.clearToken();
    await authLocalDataSource.saveUserLoggedIn(false);
    await SessionManager.clearSession();
  }
}
