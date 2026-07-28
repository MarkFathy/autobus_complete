import 'package:autobus_complete/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  /// Map FirebaseAuthException code to localized error message based on active app language (AR / EN)
  static String getAuthErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return S.current.firebaseUserNotFound;
      case 'wrong-password':
        return S.current.firebaseWrongPassword;
      case 'invalid-credential':
        return S.current.firebaseInvalidCredential;
      case 'email-already-in-use':
        return S.current.firebaseEmailAlreadyInUse;
      case 'invalid-email':
        return S.current.firebaseInvalidEmail;
      case 'weak-password':
        return S.current.firebaseWeakPassword;
      case 'network-request-failed':
        return S.current.firebaseNetworkFailed;
      case 'too-many-requests':
        return S.current.firebaseTooManyRequests;
      case 'user-disabled':
        return S.current.firebaseUserDisabled;
      default:
        return exception.message ?? S.current.firebaseAuthError;
    }
  }

  /// Translate custom exception messages into localized messages based on active app language (AR / EN)
  static String getExceptionMessage(dynamic error) {
    final msg = error is Exception ? error.toString() : error.toString();

    if (msg.contains('Verification email sent') ||
        msg.contains('Verification email sent again') ||
        msg.contains('تفعيل')) {
      return S.current.firebaseEmailVerificationSent;
    }
    if (msg.contains('Email not verified') ||
        msg.contains('غير مفعل')) {
      return S.current.firebaseEmailNotVerified;
    }
    if (msg.contains('already verified and in use') ||
        msg.contains('already registered') ||
        msg.contains('مسجل بالفعل')) {
      return S.current.firebaseEmailAlreadyInUse;
    }
    if (msg.contains('Google sign-in aborted') ||
        msg.contains('إلغاء')) {
      return S.current.firebaseGoogleSignCancel;
    }
    if (msg.contains('User not found')) {
      return S.current.firebaseUserNotFound;
    }

    // Strip "Exception: " prefix if present
    return msg.replaceAll('Exception: ', '').trim();
  }
}
