import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/navigation/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:autobus_complete/src/config/themes/app_theme.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
      return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            // Localization
            locale: const Locale('ar'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            // Root Navigator
            navigatorKey: Go.navigatorKey, 
            initialRoute: NamedRoutes.splash.routeName,
            onGenerateRoute: RouterGenerator.getRoute, 
            onUnknownRoute: (_) => RouterGenerator.undefineRoute(),
        
        );
      },
    );
  }
}