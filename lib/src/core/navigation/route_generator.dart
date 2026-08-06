import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/navigation/page_router/imports_page_router_builder.dart';
import 'package:autobus_complete/src/features/app_lock/presentation/screens/app_lock_screen.dart';
import 'package:autobus_complete/src/features/auth/presentation/screens/login_screen.dart';
import 'package:autobus_complete/src/features/auth/presentation/screens/register_screen.dart';
import 'package:autobus_complete/src/features/complaints/presentation/screens/complaints_screen.dart';
import 'package:autobus_complete/src/features/game/presentation/screens/game_board_screen.dart';
import 'package:autobus_complete/src/features/game/presentation/screens/game_countdown_screen.dart';
import 'package:autobus_complete/src/features/game/presentation/screens/leaderboard_screen.dart';
import 'package:autobus_complete/src/features/game/presentation/screens/scoring_screen.dart';
import 'package:autobus_complete/src/features/home/presentation/screens/home_screen.dart';
import 'package:autobus_complete/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:autobus_complete/src/features/room/presentation/screens/room_lobby_screen.dart';
import 'package:autobus_complete/src/features/settings/presentation/screens/about_game_screen.dart';
import 'package:autobus_complete/src/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:autobus_complete/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:autobus_complete/src/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  RouterGenerator._();

  static final PageRouterBuilder _pageRouter = PageRouterBuilder();

  static Route<dynamic> getRoute(RouteSettings settings) {
    var realArguments = settings.arguments;
    TransitionType? transition;
    AnimationOption? options;

    if (settings.arguments is NamedRouteArgs) {
      final args = settings.arguments! as NamedRouteArgs;
      realArguments = args.arguments;
      transition = args.transition;
      options = args.options;
    }

    final actualSettings = RouteSettings(name: settings.name, arguments: realArguments);

    debugPrint('RouterGenerator: getRoute called for name: ${settings.name}, arguments: $realArguments');

    final namedRoute = NamedRoutes.values.cast<NamedRoutes?>().firstWhere(
      (e) => e?.routeName == actualSettings.name,
      orElse: () => null,
    );

    if (namedRoute == null) return undefineRoute();

    //Splash Screen
    return switch (namedRoute) {
      NamedRoutes.splash => _pageRouter.build(
        const SplashScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      //Login Screen
      NamedRoutes.login => _pageRouter.build(
        const LoginScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Register Screen
      NamedRoutes.register => _pageRouter.build(
        const RegisterScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Home Screen
      NamedRoutes.home => _pageRouter.build(
        const HomeScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Settings Screen
      NamedRoutes.settings => _pageRouter.build(
        const SettingsScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Profile Screen
      NamedRoutes.profile => _pageRouter.build(
        const ProfileScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
      //Room Screen
      NamedRoutes.roomLobby => _pageRouter.build(
        const RoomLobbyScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Countdown Screen
      NamedRoutes.countdown => _pageRouter.build(
        const GameCountdownScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //GameBoard Screen
      NamedRoutes.gameBoard => _pageRouter.build(
        const GameBoardScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Scoring Screen
      NamedRoutes.scoring => _pageRouter.build(
        const ScoringScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Leaderboard Screen
      NamedRoutes.leaderboard => _pageRouter.build(
        const LeaderboardScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Privacy Policy Screen
      NamedRoutes.privacyPolicy => _pageRouter.build(
        const PrivacyPolicyScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //About Game Screen
      NamedRoutes.aboutGame => _pageRouter.build(
        const AboutGameScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //Complaints Screen
      NamedRoutes.complaints => _pageRouter.build(
        const ComplaintsScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),

      //App Lock Screen
      NamedRoutes.appLock => _pageRouter.build(
        const AppLockScreen(),
        settings: actualSettings,
        transition: transition,
        options: options,
      ),
    };
  }

  static Route<dynamic> undefineRoute() => MaterialPageRoute(
    builder: (_) => const Scaffold(body: Center(child: Text('No route exists here ! '))),
  );
}
