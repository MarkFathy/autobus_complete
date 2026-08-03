import 'dart:async';

import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryChip extends StatelessWidget {
  final String emoji;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.emoji,
    required this.name,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      unawaited(HapticFeedback.selectionClick());
      onTap();
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: isSelected ? context.colors.primaryContainer : context.colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? context.colors.primary : context.colors.outline.withValues(alpha: 0.2),
          width: 1.5.w, // ponytail: Constant border width prevents size jump
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: context.colors.primary.withValues(alpha: 0.1), blurRadius: 8, spreadRadius: 1)]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16.sp)),
          6.szW,
          Text(
            name,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isSelected ? context.colors.primary : context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w600, // ponytail: Constant font weight prevents text width jump
              fontSize: 14.sp,
            ),
          ),
          6.szW,
          AnimatedOpacity(
            // ponytail: Pre-reserved space prevents overflow
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.0,
            child: Icon(Icons.check_circle_rounded, size: 16.sp, color: context.colors.primary),
          ),
        ],
      ),
    ),
  );
}
