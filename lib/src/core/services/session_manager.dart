import 'package:autobus_complete/src/core/helpers/cache_service.dart';

class SessionManager {
  SessionManager._();

  static const String _kAccessToken = 'access_token';
  static const String _kUserId = 'user_id';
  static const String _kUserEmail = 'user_email';

  static Future<void> saveSession({
    required String token,
    String? userId,
    String? email,
  }) async {
    await SecureStorage.write(_kAccessToken, token);
    if (userId != null) {
      await SecureStorage.write(_kUserId, userId);
    }
    if (email != null) {
      await SecureStorage.write(_kUserEmail, email);
    }
  }

  static Future<String?> getToken() async {
    return await SecureStorage.read(_kAccessToken);
  }

  static Future<String?> getUserId() async {
    return await SecureStorage.read(_kUserId);
  }

  static Future<String?> getEmail() async {
    return await SecureStorage.read(_kUserEmail);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  static Future<void> clearSession() async {
    await SecureStorage.delete(_kAccessToken);
    await SecureStorage.delete(_kUserId);
    await SecureStorage.delete(_kUserEmail);
  }
}
