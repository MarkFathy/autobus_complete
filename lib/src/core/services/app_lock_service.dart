import 'dart:async';

import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLockService {
  final FirebaseRemoteConfig _remoteConfig;

  static const String keyIsAppLockedSnake = 'is_app_locked';
  static const String keyIsAppLockedCamel = 'isAppLocked';
  static const String keyAppLockTitleSnake = 'app_lock_title';
  static const String keyAppLockTitleCamel = 'appLockTitle';
  static const String keyAppLockMessageSnake = 'app_lock_message';
  static const String keyAppLockMessageCamel = 'appLockMessage';

  StreamSubscription<RemoteConfigUpdate>? _configSubscription;
  final StreamController<bool> _lockStatusController = StreamController<bool>.broadcast();

  bool _isLocked = false;

  AppLockService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  bool get isLocked => _isLocked;
  Stream<bool> get lockStatusStream => _lockStatusController.stream;

  String get lockTitle {
    final titleSnake = _remoteConfig.getString(keyAppLockTitleSnake);
    if (titleSnake.trim().isNotEmpty) return titleSnake;
    return _remoteConfig.getString(keyAppLockTitleCamel);
  }

  String get lockMessage {
    final messageSnake = _remoteConfig.getString(keyAppLockMessageSnake);
    if (messageSnake.trim().isNotEmpty) return messageSnake;
    return _remoteConfig.getString(keyAppLockMessageCamel);
  }

  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(minutes: 5),
        ),
      );

      await _remoteConfig.setDefaults({
        keyIsAppLockedSnake: false,
        keyIsAppLockedCamel: false,
        keyAppLockTitleSnake: '',
        keyAppLockTitleCamel: '',
        keyAppLockMessageSnake: '',
        keyAppLockMessageCamel: '',
      });

      await fetchAndActivate();
      _listenToRemoteConfigChanges();
    } on Object catch (e) {
      debugPrint('AppLockService initialize error: $e');
    }
  }

  Future<bool> fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      _evaluateLockStatus();
      return updated;
    } on Object catch (e) {
      debugPrint('AppLockService fetchAndActivate error: $e');
      _evaluateLockStatus();
      return false;
    }
  }

  void _listenToRemoteConfigChanges() {
    unawaited(_configSubscription?.cancel());
    _configSubscription = _remoteConfig.onConfigUpdated.listen(
      (update) async {
        try {
          await _remoteConfig.fetchAndActivate();
          _evaluateLockStatus();
        } on Object catch (e) {
          debugPrint('AppLockService onConfigUpdated error: $e');
        }
      },
      onError: (Object error) {
        debugPrint('AppLockService stream error: $error');
      },
    );
  }

  void _evaluateLockStatus() {
    final lockedSnake = _remoteConfig.getBool(keyIsAppLockedSnake);
    final lockedCamel = _remoteConfig.getBool(keyIsAppLockedCamel);
    final newLockedState = lockedSnake || lockedCamel;

    final previousState = _isLocked;
    _isLocked = newLockedState;

    if (previousState != newLockedState) {
      _lockStatusController.add(newLockedState);
    }

    final context = Go.navigatorKey.currentContext;
    if (context == null) return;

    final currentRouteName = ModalRoute.of(context)?.settings.name;

    if (_isLocked) {
      if (currentRouteName != NamedRoutes.appLock.routeName) {
        unawaited(Go.offAllNamed(NamedRoutes.appLock));
      }
    } else {
      if (currentRouteName == NamedRoutes.appLock.routeName) {
        unawaited(Go.offAllNamed(NamedRoutes.splash));
      }
    }
  }

  void dispose() {
    unawaited(_configSubscription?.cancel());
    unawaited(_lockStatusController.close());
  }
}
