import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onConfirmLogout;

  const LogoutConfirmationBottomSheet({
    required this.onConfirmLogout, super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmLogout,
  }) => showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => LogoutConfirmationBottomSheet(
        onConfirmLogout: onConfirmLogout,
      ),
    );

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle Pill ─────────────────────────────────────
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          20.szH,

          // ── Logout Red Icon Circle ──────────────────────────────
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: context.colors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout_rounded,
              color: context.colors.secondary,
              size: 32.sp,
            ),
          ),
          16.szH,

          // ── Title & Message ─────────────────────────────────────
          Text(
            S.of(context).logout,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          8.szH,
          Text(
            S.of(context).logoutConfirmation,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          24.szH,

          // ── Actions Row (Cancel & Logout) ───────────────────────
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: GestureDetector(
                  onTap: Go.back,
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colors.outline.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).cancel,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              12.szW,
              // Yes Logout Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Go.back();
                    onConfirmLogout();
                  },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: context.colors.secondary,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).yesLogout,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colors.onSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.szH,
        ],
      ),
    );
}
