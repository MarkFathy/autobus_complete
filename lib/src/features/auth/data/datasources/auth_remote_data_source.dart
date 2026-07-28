import 'dart:io';
import 'package:autobus_complete/generated/l10n.dart';
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
      if (!userCredential.user!.emailVerified) {
        await firebaseAuth.signOut();
        throw Exception(S.current.firebaseEmailNotVerified);
      }
      final token = await userCredential.user!.getIdToken();
      if (token != null) {
        await authLocalDataSource.saveToken(token);
      }
      await authLocalDataSource.saveUserLoggedIn(true);

      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'photoUrl': userCredential.user!.photoURL,
        'emailVerified': userCredential.user!.emailVerified,
        'provider': 'email',
      }, SetOptions(merge: true));

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

        // Upload profile image if provided
        String? photoUrl;
        if (imageFile != null) {
          final ref = storage.ref().child('user_photos/${user.uid}.jpg');
          await ref.putFile(imageFile);
          photoUrl = await ref.getDownloadURL();
        }

        await user.updateDisplayName(name);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
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

      final userModel = UserModel.fromFirebaseUser(user);
      await firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
        'emailVerified': user.emailVerified,
        'provider': 'google',
      }, SetOptions(merge: true));

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
    await firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}