import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const ScoreBadge({
    super.key,
    required this.label,
    this.color = AppColors.cyanColor,
    Color? backgroundColor,
  }) : backgroundColor = backgroundColor ?? const Color(0x2600BCD4); // cyan with alpha 0.15

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: getTextStyle().s12.bold.copyWith(color: color),
      ),
    );
  }
}
