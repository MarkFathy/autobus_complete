import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;

  const HomeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          border: Border.all(
            color: AppColors.yellowColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 55.sp,
              color: iconColor ?? AppColors.yellowColor,
            ),
            10.szH,
            Text(
              title,
              style: getTextStyle().s20.w700.whiteColor,
              textAlign: TextAlign.center,
            ),
            5.szH,
            Text(
              subtitle,
              style: getTextStyle().s14.w400.greyColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
