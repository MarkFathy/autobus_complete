import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStatusBarAndOrientationsTheme {
  static Future<void> setStyle() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        //For android light icons
        statusBarIconBrightness: Brightness.light,
        //For ios light icons
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
}