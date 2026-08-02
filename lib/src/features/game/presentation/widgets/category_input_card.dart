import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
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
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.25),
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
                style: getTextStyle().s14.w700.yellowColor,
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
            style: getTextStyle().s14.w600.whiteColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.scaffoldBackgroundColor,
              hintText: categoryName,
              hintStyle: getTextStyle().s12.w400.greyColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.greyColor.withValues(alpha: 0.2),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.yellowColor,
                  width: 1.5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
