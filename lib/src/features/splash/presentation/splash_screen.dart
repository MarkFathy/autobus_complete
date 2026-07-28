import 'dart:async';

import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Animator/fade_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Option/fade_animation_option.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Animator/scale_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Options/scale_animation_option.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = ScaleAnimator(
      const ScaleAnimationOptions(begin: 0.5, end: 1.0),
    ).animator(_controller);
    _fadeAnimation = FadeAnimator(
      const FadeAnimationOptions(begin: 0.0, end: 1.0),
    ).animator(_controller);

    _controller.forward();

    _timer = Timer(const Duration(seconds: 3), () async {
      final authLocalDataSource = sl<AuthLocalDataSource>();
      final isLoggedIn = await authLocalDataSource.isUserLoggedIn();
      final token = await authLocalDataSource.getToken();

      if (isLoggedIn && token != null && token.trim().isNotEmpty) {
        Go.offNamed(NamedRoutes.home);
      } else {
        Go.offNamed(NamedRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Assets.pngs.logo.image(height: 300.h, width: 300.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
