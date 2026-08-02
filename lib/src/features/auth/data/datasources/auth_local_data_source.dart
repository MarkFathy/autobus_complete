import 'package:autobus_complete/src/core/helpers/cache_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<void> saveUserLoggedIn({required bool value});
  Future<bool> isUserLoggedIn();
}


class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  static const _tokenKey = 'auth_token';
  static const _loggedInKey = 'is_logged_in';

  @override
  Future<void> saveToken(String token) async {
    await SecureStorage.write(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async => SecureStorage.read(_tokenKey);

  @override
  Future<void> clearToken() async {
    await SecureStorage.delete(_tokenKey);
  }

  @override
  Future<void> saveUserLoggedIn({required bool value}) async {
    await CacheStorage.write(_loggedInKey, value);
  }

  @override
  Future<bool> isUserLoggedIn() async => (CacheStorage.read(_loggedInKey) as bool?) ?? false;
}