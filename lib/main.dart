import 'package:autobus_complete/app.dart';
import 'package:autobus_complete/firebase_options.dart';
import 'package:autobus_complete/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:autobus_complete/src/core/helpers/cache_service.dart';
import 'package:autobus_complete/src/core/services/app_lock_service.dart';
import 'package:autobus_complete/src/core/services/notification_service.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/services/user_status_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final originalFlutterOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exception is MissingPluginException &&
        details.exception.toString().contains('firebase_firestore/transaction')) {
      return;
    }
    originalFlutterOnError?.call(details);
  };

  final originalPlatformOnError = PlatformDispatcher.instance.onError;
  PlatformDispatcher.instance.onError = (error, stack) {
    if (error is MissingPluginException && error.toString().contains('firebase_firestore/transaction')) {
      return true;
    }
    return originalPlatformOnError?.call(error, stack) ?? false;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheStorage.init();
  await setupServiceLocator();
  await sl<AppLockService>().initialize();
  await sl<NotificationService>().initialize();
  sl<UserStatusService>().initialize();

  await AppStatusBarAndOrientationsTheme.setStyle();

  runApp(const MyApp());
}
