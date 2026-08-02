import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameTopBar extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final String letter;
  final bool isShuffling;

  const GameTopBar({
    required this.currentRound, required this.totalRounds, required this.letter, super.key,
    this.isShuffling = false,
  });

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left Side: Round Pill Badge ─────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.yellowColor.withValues(alpha: 0.4),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  color: AppColors.yellowColor,
                  size: 18.sp,
                ),
                6.szW,
                Text(
                  '${S.of(context).round} $currentRound/$totalRounds',
                  style: getTextStyle().s14.bold.whiteColor,
                ),
              ],
            ),
          ),

          // ── Right Side: Letter Label & Glowing Light Red Circle Badge ──────
          Row(
            children: [
              Text(
                '${S.of(context).currentLetter}: ',
                style: getTextStyle().s14.bold.yellowColor,
              ),
              6.szW,
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.redColor.withValues(alpha: 0.25),
                  border: Border.all(
                    color: isShuffling
                        ? AppColors.redColor.withValues(alpha: 0.5)
                        : AppColors.redColor,
                    width: 2.w,
                  ),
                  boxShadow: isShuffling
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.redColor.withValues(alpha: 0.35),
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
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.whiteColor,
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
