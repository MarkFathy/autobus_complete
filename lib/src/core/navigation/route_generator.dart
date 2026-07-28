import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:autobus_complete/src/features/auth/presentation/screens/login_screen.dart';
import 'package:autobus_complete/src/features/auth/presentation/screens/register_screen.dart';
import 'package:autobus_complete/src/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'named_routes.dart';
import 'page_router/imports_page_router_builder.dart';

import 'navigator.dart';

class RouterGenerator {
  RouterGenerator._();

  static final PageRouterBuilder _pageRouter = PageRouterBuilder();

  static Route<dynamic> getRoute(RouteSettings settings) {
    Object? realArguments = settings.arguments;
    TransitionType? transition;
    AnimationOption? options;

    if (settings.arguments is NamedRouteArgs) {
      final args = settings.arguments as NamedRouteArgs;
      realArguments = args.arguments;
      transition = args.transition;
      options = args.options;
    }

    final actualSettings = RouteSettings(name: settings.name, arguments: realArguments);

    debugPrint('RouterGenerator: getRoute called for name: ${settings.name}, arguments: $realArguments');

    final namedRoute = NamedRoutes.values.firstWhere(
      (e) => e.routeName == actualSettings.name,
    );
    return switch (namedRoute) {
      NamedRoutes.splash => _pageRouter.build(
        const SplashScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
   
      ),
      NamedRoutes.register => _pageRouter.build(
        const RegisterScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      NamedRoutes.login => _pageRouter.build(
        const LoginScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
    _ => undefineRoute(),
    };
  }

  static Route<dynamic> undefineRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('No route exists here ! '))),
    );
  }
}
