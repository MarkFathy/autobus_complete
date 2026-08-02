import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoadingOverlay({
    required this.isLoading, required this.child, super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        child,
        if (isLoading)
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withValues(alpha: 0.65),
          ),
        if (isLoading)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.lotties.loading.lottie(
                  width: 200.w,
                  height: 200.h,
                ),
              ],
            ),
          ),
      ],
    );
}
