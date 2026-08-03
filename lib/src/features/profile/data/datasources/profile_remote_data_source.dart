import 'dart:convert';
import 'dart:io';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/services/session_manager.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:autobus_complete/src/features/profile/data/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final AuthLocalDataSource authLocalDataSource;

  ProfileRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.authLocalDataSource,
  });

  @override
  Future<ProfileModel> getUserProfile() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(S.current.firebaseUserNotFound);
    }
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        await SessionManager.clearSession();
        await authLocalDataSource.clearToken();
        await authLocalDataSource.saveUserLoggedIn(value: false);
        await firebaseAuth.signOut();
        throw Exception(S.current.firebaseUserDisabled);
      } else if (e.code == 'user-not-found') {
        await SessionManager.clearSession();
        await authLocalDataSource.clearToken();
        await authLocalDataSource.saveUserLoggedIn(value: false);
        await firebaseAuth.signOut();
        throw Exception(S.current.accountDeletedMessage);
      }
    } on Object catch (_) {}

    final refreshedUser = firebaseAuth.currentUser ?? user;

    final docSnapshot = await firestore.collection('users').doc(refreshedUser.uid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      if (data['isDeleted'] == true) {
        await SessionManager.clearSession();
        await authLocalDataSource.clearToken();
        await authLocalDataSource.saveUserLoggedIn(value: false);
        await firebaseAuth.signOut();
        throw Exception(S.current.accountDeletedMessage);
      } else if (data['isBanned'] == true ||
          data['status'] == 'banned' ||
          data['status'] == 'disabled' ||
          data['disabled'] == true) {
        await SessionManager.clearSession();
        await authLocalDataSource.clearToken();
        await authLocalDataSource.saveUserLoggedIn(value: false);
        await firebaseAuth.signOut();
        throw Exception(S.current.firebaseUserDisabled);
      }
    } else if (!docSnapshot.exists) {
      await SessionManager.clearSession();
      await authLocalDataSource.clearToken();
      await authLocalDataSource.saveUserLoggedIn(value: false);
      await firebaseAuth.signOut();
      throw Exception(S.current.accountDeletedMessage);
    }

    var resolvedName = refreshedUser.displayName ?? '';
    var resolvedEmail = refreshedUser.email ?? '';
    var resolvedPhotoUrl = refreshedUser.photoURL;

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      if ((data['name'] as String?)?.isNotEmpty ?? false) {
        resolvedName = data['name'] as String;
      }
      if ((data['email'] as String?)?.isNotEmpty ?? false) {
        resolvedEmail = data['email'] as String;
      }
      if (data.containsKey('photoUrl')) {
        resolvedPhotoUrl = data['photoUrl'] as String?;
      }
    }

    if (!docSnapshot.exists ||
        ((docSnapshot.data()?['name'] as String?)?.isEmpty ?? true) ||
        (docSnapshot.data() != null && !docSnapshot.data()!.containsKey('photoUrl'))) {
      await firestore.collection('users').doc(refreshedUser.uid).set({
        'email': resolvedEmail,
        if (resolvedName.isNotEmpty) 'name': resolvedName,
        'photoUrl': resolvedPhotoUrl,
        'emailVerified': refreshedUser.emailVerified,
      }, SetOptions(merge: true));
    }

    return ProfileModel(id: refreshedUser.uid, name: resolvedName, email: resolvedEmail, photoUrl: resolvedPhotoUrl);
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

    final docSnapshot = await firestore.collection('users').doc(user.uid).get();
    final existingData = docSnapshot.data();

    var photoUrl = (existingData != null && existingData.containsKey('photoUrl'))
        ? existingData['photoUrl'] as String?
        : user.photoURL;

    if (removeImage) {
      photoUrl = null;
    } else if (imageFile != null) {
      try {
        final bytes = await imageFile.readAsBytes();
        final base64String = base64Encode(bytes);
        final generatedDataUrl = 'data:image/jpeg;base64,$base64String';
        if (generatedDataUrl.length < 1500000) {
          photoUrl = generatedDataUrl;
        }
      } on Object catch (_) {}
    }

    try {
      await user.updateDisplayName(name);
      if (photoUrl != null && !photoUrl.startsWith('data:image')) {
        await user.updatePhotoURL(photoUrl);
      }
    } on Object catch (_) {}

    if (email != user.email && email.trim().isNotEmpty) {
      try {
        await user.verifyBeforeUpdateEmail(email);
      } on Object catch (_) {}
    }

    final updatedData = <String, dynamic>{'name': name, 'email': email, 'photoUrl': photoUrl};

    await firestore.collection('users').doc(user.uid).set(updatedData, SetOptions(merge: true));

    return ProfileModel(id: user.uid, name: name, email: email, photoUrl: photoUrl);
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
      } on Object catch (_) {}
      await user.delete();
    }
    await authLocalDataSource.clearToken();
    await authLocalDataSource.saveUserLoggedIn(value: false);
    await SessionManager.clearSession();
  }
}
