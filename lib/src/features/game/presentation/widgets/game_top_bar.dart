import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameTopBar extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final String letter;
  final bool isShuffling;
  final VoidCallback? onLeaveRoom;

  const GameTopBar({
    required this.currentRound,
    required this.totalRounds,
    required this.letter,
    super.key,
    this.isShuffling = false,
    this.onLeaveRoom,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(color: context.colors.primary.withValues(alpha: 0.3), width: 1.w),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── Left Side: 3-Dots Menu & Round Pill Badge ──────────────────
        Row(
          children: [
            if (onLeaveRoom != null) ...[
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: context.colors.onSurface, size: 24.sp),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                color: context.colors.surfaceContainerHighest,
                onSelected: (value) {
                  if (value == 'leave') {
                    onLeaveRoom?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'leave',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app_rounded, color: context.colors.error, size: 20.sp),
                        8.szW,
                        Text(
                          S.of(context).leaveRoom,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              4.szW,
            ],
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: context.colors.primary.withValues(alpha: 0.4), width: 1.w),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_rounded, color: context.colors.primary, size: 18.sp),
                  6.szW,
                  Text(
                    '${S.of(context).round} $currentRound/$totalRounds',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Right Side: Letter Label & Glowing Light Red Circle Badge ──────
        Row(
          children: [
            Text(
              '${S.of(context).currentLetter}: ',
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            6.szW,
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.secondary.withValues(alpha: 0.25),
                border: Border.all(
                  color: isShuffling ? context.colors.secondary.withValues(alpha: 0.5) : context.colors.secondary,
                  width: 2.w,
                ),
                boxShadow: isShuffling
                    ? []
                    : [
                        BoxShadow(
                          color: context.colors.secondary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 80),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Text(
                    letter,
                    key: ValueKey<String>(letter),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
