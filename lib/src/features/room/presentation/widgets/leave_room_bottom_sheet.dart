import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
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
              color: context.colors.secondaryContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colors.secondary,
                width: 1.5.w,
              ),
            ),
            child: Icon(
              Icons.directions_bus_filled_rounded,
              color: context.colors.secondary,
              size: 36.sp,
            ),
          ),
          16.szH,

          // ── Title & Confirmation Message ───────────────────────────
          Text(
            S.of(context).leaveRoom,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
          8.szH,
          Text(
            S.of(context).leaveRoomConfirmation,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          24.szH,

          // ── Action Buttons (Leave & Cancel) ──────────────────────────
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: S.of(context).cancel,
                  backgroundColor: context.colors.outline.withValues(alpha: 0.3),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              12.szW,
              Expanded(
                child: CustomButton(
                  text: S.of(context).yesLeave,
                  backgroundColor: context.colors.secondary,
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
