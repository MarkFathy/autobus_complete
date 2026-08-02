import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool isLoading;

  const CustomButton({
    required this.text, required this.onPressed, super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.backgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final finalRadius = borderRadius ?? BorderRadius.circular(AppCircular.r16);
    final buttonColor = backgroundColor ?? AppColors.yellowColor;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSize.sH55,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: buttonColor,
          disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
          shadowColor: buttonColor,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: finalRadius),
        ),
        child: Container(
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : Text(
                  text,
                  style: textStyle ?? getTextStyle().blackColor.s22.w700,
                ),
        ),
      ),
    );
  }
}
