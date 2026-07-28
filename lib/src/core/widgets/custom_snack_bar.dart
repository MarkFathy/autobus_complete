import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.error,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = _getSnackBarTheme(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        backgroundColor: theme.backgroundColor,
        content: Row(
          children: [
            Icon(
              theme.icon,
              color: theme.iconColor,
              size: 24.sp,
            ),
            12.szW,
            Expanded(
              child: Text(
                message,
                style: getTextStyle().whiteColor.s14.w500,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  static _SnackBarThemeData _getSnackBarTheme(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const _SnackBarThemeData(
          backgroundColor: AppColors.textFieldFillColor,
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.white,
        );
      case SnackBarType.warning:
        return const _SnackBarThemeData(
          backgroundColor:AppColors.redColor,
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.white,
        );
      case SnackBarType.info:
        return const _SnackBarThemeData(
          backgroundColor: Color(0xFF0288D1),
          icon: Icons.info_outline_rounded,
          iconColor: Colors.white,
        );
      case SnackBarType.error:
        return const _SnackBarThemeData(
          backgroundColor: AppColors.redColor,
          icon: Icons.error_outline_rounded,
          iconColor: Colors.white,
        );
    }
  }
}

class _SnackBarThemeData {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  const _SnackBarThemeData({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
}
