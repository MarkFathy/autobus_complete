import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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
    required this.text,
    required this.onPressed,
    super.key,
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
    final buttonColor = backgroundColor ?? context.colors.primary;

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
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(context.colors.onPrimary),
                  ),
                )
              : Text(
                  text,
                  style:
                      textStyle ??
                      context.textTheme.titleLarge?.copyWith(
                        color: context.colors.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 19.sp,
                      ),
                ),
        ),
      ),
    );
  }
}
