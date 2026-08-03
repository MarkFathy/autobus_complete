import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryInputCard extends StatelessWidget {
  final String emoji;
  final String categoryName;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const CategoryInputCard({
    required this.emoji, required this.categoryName, required this.controller, super.key,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.25),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Label Header (Emoji + Title)
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 18.sp)),
              8.szW,
              Text(
                categoryName,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          10.szH,

          // Input Text Field
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            textInputAction: textInputAction ?? TextInputAction.next,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurface,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.colors.surface,
              hintText: categoryName,
              hintStyle: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: context.colors.outline.withValues(alpha: 0.2),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: context.colors.primary,
                  width: 1.5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
