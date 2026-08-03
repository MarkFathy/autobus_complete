import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

/// A customizable and styled 6-digit (or N-digit) PIN / OTP input widget
/// designed to match the app's dark theme and color palette.
class CustomPinInput extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool autofocus;
  final bool readOnly;
  final MainAxisAlignment mainAxisAlignment;

  const CustomPinInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.validator,
    this.errorText,
    this.autofocus = true,
    this.readOnly = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.whiteColor),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3), width: 1.5.w),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6.r, offset: const Offset(0, 3)),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.yellowColor, width: 2.w),
        boxShadow: [
          BoxShadow(color: AppColors.yellowColor.withValues(alpha: 0.25), blurRadius: 10.r, spreadRadius: 1.r),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.textFieldFillColor,
        border: Border.all(color: AppColors.yellowColor.withValues(alpha: 0.6), width: 1.5.w),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.redColor, width: 2.w),
        boxShadow: [BoxShadow(color: AppColors.redColor.withValues(alpha: 0.2), blurRadius: 8.r)],
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: length,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        readOnly: readOnly,
        mainAxisAlignment: mainAxisAlignment,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        validator: validator,
        errorText: errorText,
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              width: 2.w,
              height: 22.h,
              color: AppColors.yellowColor,
            ),
          ],
        ),
        onChanged: onChanged,
        onCompleted: onCompleted,
      ),
    );
  }
}
