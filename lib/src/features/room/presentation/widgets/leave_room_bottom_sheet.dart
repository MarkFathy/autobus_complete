import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRoomBottomSheet extends StatelessWidget {
  final VoidCallback onLeaveConfirmed;

  const LeaveRoomBottomSheet({
    required this.onLeaveConfirmed, super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onLeaveConfirmed,
  }) => showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LeaveRoomBottomSheet(
        onLeaveConfirmed: onLeaveConfirmed,
      ),
    );

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Warning Icon Badge ─────────────────────────────────────
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.redColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.redColor,
                width: 1.5.w,
              ),
            ),
            child: Icon(
              Icons.directions_bus_filled_rounded,
              color: AppColors.redColor,
              size: 36.sp,
            ),
          ),
          16.szH,

          // ── Title & Confirmation Message ───────────────────────────
          Text(
            S.of(context).leaveRoom,
            style: getTextStyle().s20.bold.whiteColor,
            textAlign: TextAlign.center,
          ),
          8.szH,
          Text(
            S.of(context).leaveRoomConfirmation,
            style: getTextStyle().s14.w500.greyColor,
            textAlign: TextAlign.center,
          ),
          24.szH,

          // ── Action Buttons (Leave & Cancel) ──────────────────────────
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: S.of(context).cancel,
                  backgroundColor: AppColors.greyColor.withValues(alpha: 0.3),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              12.szW,
              Expanded(
                child: CustomButton(
                  text: S.of(context).yesLeave,
                  backgroundColor: AppColors.redColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onLeaveConfirmed();
                  },
                ),
              ),
            ],
          ),
          10.szH,
        ],
      ),
    );
}
