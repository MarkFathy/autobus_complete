import 'dart:async';

import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Animator/fade_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Option/fade_animation_option.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Animator/scale_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Options/scale_animation_option.dart';
import 'package:autobus_complete/src/core/services/app_lock_service.dart';
import 'package:autobus_complete/src/core/services/notification_service.dart';
import 'package:autobus_complete/src/core/services/service_locater/service_locator.dart';
import 'package:autobus_complete/src/core/services/session_manager.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:autobus_complete/src/core/widgets/custom_snack_bar.dart';
import 'package:autobus_complete/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    sl<NotificationService>().isSplashActive = true;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _scaleAnimation = ScaleAnimator(const ScaleAnimationOptions(begin: 0.5)).animator(_controller);
    _fadeAnimation = FadeAnimator(const FadeAnimationOptions()).animator(_controller);

    unawaited(_controller.forward());

    _timer = Timer(const Duration(seconds: 3), () async {
      sl<NotificationService>().isSplashActive = false;

      if (sl<AppLockService>().isLocked) {
        await Go.offNamed(NamedRoutes.appLock);
        return;
      }

      final authLocalDataSource = sl<AuthLocalDataSource>();
      final isLoggedIn = await authLocalDataSource.isUserLoggedIn();
      final token = await authLocalDataSource.getToken();

      if (isLoggedIn && token != null && token.trim().isNotEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        var isAccountValid = true;
        String? errorMessage;

        if (user != null) {
          try {
            await user.reload();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-disabled') {
              isAccountValid = false;
              errorMessage = S.current.firebaseUserDisabled;
            } else if (e.code == 'user-not-found') {
              isAccountValid = false;
              errorMessage = S.current.accountDeletedMessage;
            }
          } on Object catch (_) {}

          if (isAccountValid) {
            try {
              final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
              if (userDoc.exists && userDoc.data() != null) {
                final data = userDoc.data()!;
                if (data['isDeleted'] == true) {
                  isAccountValid = false;
                  errorMessage = S.current.accountDeletedMessage;
                } else if (data['isBanned'] == true ||
                    data['status'] == 'banned' ||
                    data['status'] == 'disabled' ||
                    data['disabled'] == true) {
                  isAccountValid = false;
                  errorMessage = S.current.firebaseUserDisabled;
                }
              } else if (!userDoc.exists) {
                isAccountValid = false;
                errorMessage = S.current.accountDeletedMessage;
              }
            } on Object catch (_) {}
          }
        } else {
          isAccountValid = false;
          errorMessage = S.current.accountDeletedMessage;
        }

        if (isAccountValid) {
          await Go.offNamed(NamedRoutes.home);
          sl<NotificationService>().consumePendingNotificationRoute();
        } else {
          await authLocalDataSource.clearToken();
          await authLocalDataSource.saveUserLoggedIn(value: false);
          await SessionManager.clearSession();
          try {
            await FirebaseAuth.instance.signOut();
          } on Object catch (_) {}

          await Go.offNamed(NamedRoutes.login);
          if (mounted) {
            CustomSnackBar.showError(
              context,
              message: errorMessage ?? S.of(context).firebaseUserDisabled,
            );
          }
        }
      } else {
        await Go.offNamed(NamedRoutes.login);
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
  Widget build(BuildContext context) => AppScaffold(
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
