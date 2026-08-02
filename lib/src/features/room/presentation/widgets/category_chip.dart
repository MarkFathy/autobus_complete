import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChip extends StatelessWidget {
  final String emoji;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.emoji, required this.name, required this.isSelected, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.yellowColor.withValues(alpha: 0.15)
              : AppColors.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.yellowColor
                : AppColors.greyColor.withValues(alpha: 0.2),
            width: isSelected ? 1.8.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.yellowColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16.sp)),
            6.szW,
            Text(
              name,
              style: isSelected
                  ? getTextStyle().s14.w700.yellowColor
                  : getTextStyle().s14.w500.greyColor,
            ),
            if (isSelected) ...[
              6.szW,
              Icon(
                Icons.check_circle_rounded,
                size: 16.sp,
                color: AppColors.yellowColor,
              ),
            ],
          ],
        ),
      ),
    );
}
