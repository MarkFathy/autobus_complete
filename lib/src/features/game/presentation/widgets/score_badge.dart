import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;

  const ScoreBadge({
    required this.label, super.key,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? context.colors.secondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (backgroundColor ?? badgeColor).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: badgeColor),
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
