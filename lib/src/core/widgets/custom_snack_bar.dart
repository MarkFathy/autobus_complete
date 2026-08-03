import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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
    final theme = _getSnackBarTheme(context, type);

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
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurface,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
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

  static _SnackBarThemeData _getSnackBarTheme(BuildContext context, SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarThemeData(
          backgroundColor: context.colors.surfaceContainerHighest,
          icon: Icons.check_circle_outline_rounded,
          iconColor: context.colors.onSurface,
        );
      case SnackBarType.warning:
        return _SnackBarThemeData(
          backgroundColor: context.colors.error,
          icon: Icons.warning_amber_rounded,
          iconColor: context.colors.onSurface,
        );
      case SnackBarType.info:
        return _SnackBarThemeData(
          backgroundColor: context.colors.secondary,
          icon: Icons.info_outline_rounded,
          iconColor: context.colors.onSurface,
        );
      case SnackBarType.error:
        return _SnackBarThemeData(
          backgroundColor: context.colors.error,
          icon: Icons.error_outline_rounded,
          iconColor: context.colors.onSurface,
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
