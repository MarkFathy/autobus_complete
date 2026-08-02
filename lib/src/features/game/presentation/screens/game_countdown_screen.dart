import 'dart:async';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/named_routes.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:autobus_complete/src/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameCountdownScreen extends StatefulWidget {
  const GameCountdownScreen({super.key});

  @override
  State<GameCountdownScreen> createState() => _GameCountdownScreenState();
}

class _GameCountdownScreenState extends State<GameCountdownScreen>
    with SingleTickerProviderStateMixin {
  int _secondsLeft = 3;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _startCountdown();
  }

  void _startCountdown() {
    unawaited(_animationController.forward(from: 0.0));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
        unawaited(_animationController.forward(from: 0.0));
      } else {
        _timer?.cancel();
        unawaited(Go.offNamed(NamedRoutes.gameBoard));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: false,
      child: AppScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Get Ready Text
              Text(
                S.of(context).getReady,
                style: getTextStyle().s24.w700.whiteColor,
              ),
              12.szH,

              // Yellow Text: Game starts in
              Text(
                S.of(context).gameStartsIn,
                style: getTextStyle().s20.w700.yellowColor,
              ),
              36.szH,

              // Animated Countdown Number
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 140.r,
                  height: 140.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.yellowColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppColors.yellowColor,
                      width: 3.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.yellowColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$_secondsLeft',
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.yellowColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
