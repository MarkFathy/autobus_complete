import 'dart:convert';
import 'dart:io';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/services/notification_service.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/services/session_manager.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:autobus_complete/src/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    File? imageFile,
  });
  Future<UserModel> loginWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final AuthLocalDataSource authLocalDataSource;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  bool _googleSignInInitialized = false;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.authLocalDataSource,
    required this.firestore,
    required this.storage,
  });

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_googleSignInInitialized) {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '55011551290-pamklni64cjdokreu8kqmodbduo46hl0.apps.googleusercontent.com',
      );
      _googleSignInInitialized = true;
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      final user = userCredential.user!;
      if (!user.emailVerified) {
        await firebaseAuth.signOut();
        throw Exception(S.current.firebaseEmailNotVerified);
      }

      await user.reload();
      final refreshedUser = firebaseAuth.currentUser ?? user;

      final token = await refreshedUser.getIdToken();
      if (token != null) {
        await authLocalDataSource.saveToken(token);
      }
      await authLocalDataSource.saveUserLoggedIn(true);

      final docSnapshot =
          await firestore.collection('users').doc(refreshedUser.uid).get();
      final existingData = docSnapshot.data();

      final String resolvedName =
          (existingData?['name'] as String?)?.isNotEmpty == true
              ? existingData!['name'] as String
              : (refreshedUser.displayName ?? '');

      final String? resolvedPhotoUrl =
          existingData?['photoUrl'] as String? ?? refreshedUser.photoURL;

      await firestore.collection('users').doc(refreshedUser.uid).set({
        'email': refreshedUser.email,
        if (resolvedName.isNotEmpty) 'name': resolvedName,
        if (resolvedPhotoUrl != null) 'photoUrl': resolvedPhotoUrl,
        'emailVerified': refreshedUser.emailVerified,
        'provider': 'email',
      }, SetOptions(merge: true));

      final userModel = UserModel(
        id: refreshedUser.uid,
        email: refreshedUser.email ?? email,
        name: resolvedName,
        photoUrl: resolvedPhotoUrl,
      );

      try {
        await sl<NotificationService>().updateFcmTokenInFirestore();
      } catch (_) {}

      return userModel;
    } else {
      throw Exception(S.current.firebaseUserNotFound);
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    File? imageFile,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final user = userCredential.user!;

        // Upload profile image if provided (with safe fallback)
        String? photoUrl;
        if (imageFile != null) {
          try {
            final ref = storage.ref().child('user_photos/${user.uid}.jpg');
            await ref.putFile(imageFile);
            photoUrl = await ref.getDownloadURL();
          } catch (_) {
            try {
              final bytes = await imageFile.readAsBytes();
              final base64String = base64Encode(bytes);
              final generatedDataUrl = 'data:image/jpeg;base64,$base64String';
              if (generatedDataUrl.length < 800000) {
                photoUrl = generatedDataUrl;
              }
            } catch (_) {}
          }
        }

        // Save user data to Firestore IMMEDIATELY!
        await firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'photoUrl': photoUrl,
          'emailVerified': false,
          'provider': 'email',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Update Firebase Auth Display Name and Photo URL
        try {
          await user.updateDisplayName(name);
          if (photoUrl != null && !photoUrl.startsWith('data:image')) {
            await user.updatePhotoURL(photoUrl);
          }
        } catch (_) {}

        await user.sendEmailVerification();
        await firebaseAuth.signOut();
        throw Exception(S.current.firebaseEmailVerificationSent);
      } else {
        throw Exception(S.current.firebaseFailedToCreateUser);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          // Attempt to sign in to check if they are verified
          final cred = await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (!cred.user!.emailVerified) {
            await cred.user!.sendEmailVerification();
            await firebaseAuth.signOut();
            throw Exception(S.current.firebaseEmailVerificationSent);
          } else {
            await firebaseAuth.signOut();
            throw Exception(S.current.firebaseEmailAlreadyInUse);
          }
        } on FirebaseAuthException {
          // Sign-in failed (e.g. wrong password) — surface localized message
          throw Exception(S.current.firebaseEmailAlreadyRegistered);
        }
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      try {
        await googleSignIn.signOut();
      } catch (_) {}

      await _ensureGoogleSignInInitialized();

      final GoogleSignInAccount? googleUser =
          await googleSignIn.authenticate();

      if (googleUser == null) {
        throw Exception(S.current.firebaseGoogleSignCancel);
      }

      final googleAuth = await googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        throw Exception(S.current.firebaseFailedToSignInGoogle);
      }

      final token = await user.getIdToken();

      if (token != null) {
        await authLocalDataSource.saveToken(token);
      }
      await authLocalDataSource.saveUserLoggedIn(true);

      final docSnapshot = await firestore.collection('users').doc(user.uid).get();
      final existingData = docSnapshot.data();

      final String resolvedName = (existingData?['name'] as String?)?.isNotEmpty == true
          ? existingData!['name'] as String
          : (user.displayName ?? '');

      final String? resolvedPhotoUrl = existingData?['photoUrl'] as String? ?? user.photoURL;

      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        if (resolvedName.isNotEmpty) 'name': resolvedName,
        if (resolvedPhotoUrl != null) 'photoUrl': resolvedPhotoUrl,
        'emailVerified': user.emailVerified,
        'provider': 'google',
      }, SetOptions(merge: true));

      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: resolvedName,
        photoUrl: resolvedPhotoUrl,
      );

      try {
        await sl<NotificationService>().updateFcmTokenInFirestore();
      } catch (_) {}

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    await authLocalDataSource.clearToken();
    await authLocalDataSource.saveUserLoggedIn(false);
    await SessionManager.clearSession();
    await firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}