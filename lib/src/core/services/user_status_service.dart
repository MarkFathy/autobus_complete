import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/services/session_manager.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStatusService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final AuthLocalDataSource _authLocalDataSource;

  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSubscription;
  bool _isHandlingLogout = false;

  UserStatusService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    AuthLocalDataSource? authLocalDataSource,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _authLocalDataSource = authLocalDataSource ?? AuthLocalDataSourceImpl();

  void initialize() {
    unawaited(_authStateSubscription?.cancel());
    _authStateSubscription = _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _listenToUserDocument(user.uid);
      } else {
        unawaited(_userDocSubscription?.cancel());
        _userDocSubscription = null;
        _isHandlingLogout = false;
      }
    });
  }

  void _listenToUserDocument(String uid) {
    unawaited(_userDocSubscription?.cancel());
    _userDocSubscription = _firestore.collection('users').doc(uid).snapshots().listen(
      (snapshot) async {
        if (_isHandlingLogout) return;

        var isBannedOrDisabled = false;
        var isDeleted = false;

        if (!snapshot.exists || snapshot.data() == null) {
          isDeleted = true;
        } else {
          final data = snapshot.data()!;
          if (data['isDeleted'] == true) {
            isDeleted = true;
          } else if (data['isBanned'] == true ||
              data['status'] == 'banned' ||
              data['status'] == 'disabled' ||
              data['disabled'] == true ||
              data['isDisabled'] == true) {
            isBannedOrDisabled = true;
          }
        }

        if (isDeleted || isBannedOrDisabled) {
          _isHandlingLogout = true;
          await _userDocSubscription?.cancel();
          _userDocSubscription = null;

          await _authLocalDataSource.clearToken();
          await _authLocalDataSource.saveUserLoggedIn(value: false);
          await SessionManager.clearSession();
          try {
            await _firebaseAuth.signOut();
          } on Object catch (_) {}

          unawaited(Go.offAllNamed(NamedRoutes.login));

          final context = Go.navigatorKey.currentContext;
          if (context != null && context.mounted) {
            final message = isDeleted
                ? S.of(context).accountDeletedMessage
                : S.of(context).firebaseUserDisabled;
            CustomSnackBar.showError(context, message: message);
          }
        }
      },
      onError: (Object error) async {
        if (_isHandlingLogout) return;
        _isHandlingLogout = true;
        await _userDocSubscription?.cancel();
        _userDocSubscription = null;

        await _authLocalDataSource.clearToken();
        await _authLocalDataSource.saveUserLoggedIn(value: false);
        await SessionManager.clearSession();
        try {
          await _firebaseAuth.signOut();
        } on Object catch (_) {}

        unawaited(Go.offAllNamed(NamedRoutes.login));

        final context = Go.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          CustomSnackBar.showError(context, message: S.of(context).firebaseUserDisabled);
        }
      },
    );
  }

  void dispose() {
    unawaited(_authStateSubscription?.cancel());
    unawaited(_userDocSubscription?.cancel());
  }
}
