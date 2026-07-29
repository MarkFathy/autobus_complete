import 'package:autobus_complete/app.dart';
import 'package:autobus_complete/src/core/helpers/cache_service.dart';
import 'package:autobus_complete/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheStorage.init();
  await setupServiceLocator();

  AppStatusBarAndOrientationsTheme.setStyle();

  runApp(const MyApp());
}
