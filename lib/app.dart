import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/themes/app_theme.dart';
import 'package:autobus_complete/src/core/app_cubit/app_cubit.dart';
import 'package:autobus_complete/src/core/app_cubit/app_state.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/navigation/route_generator.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AppCubit>()..loadSettings(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, appState) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                // Dynamic Localization managed by AppCubit
                locale: appState.locale,
                localizationsDelegates: const [
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
        },
      ),
    );
  }
}