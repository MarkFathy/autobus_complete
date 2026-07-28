import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onConfirmLogout;

  const LogoutConfirmationBottomSheet({
    super.key,
    required this.onConfirmLogout,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirmLogout,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => LogoutConfirmationBottomSheet(
        onConfirmLogout: onConfirmLogout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Drag Handle Pill ─────────────────────────────────────
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          20.szH,

          // ── Logout Red Icon Circle ──────────────────────────────
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.redColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout_rounded,
              color: AppColors.redColor,
              size: 32.sp,
            ),
          ),
          16.szH,

          // ── Title & Message ─────────────────────────────────────
          Text(
            S.of(context).logout,
            style: getTextStyle().s18.w700.whiteColor,
          ),
          8.szH,
          Text(
            S.of(context).logoutConfirmation,
            style: getTextStyle().s14.w400.greyColor,
            textAlign: TextAlign.center,
          ),
          24.szH,

          // ── Actions Row (Cancel & Logout) ───────────────────────
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: GestureDetector(
                  onTap: () => Go.back(),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).cancel,
                        style: getTextStyle().s16.w600.whiteColor,
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
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).yesLogout,
                        style: getTextStyle().s16.w700.whiteColor,
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
}
