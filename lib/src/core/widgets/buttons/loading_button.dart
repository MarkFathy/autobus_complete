import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/buttons/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/res/app_sizes.dart';

class LoadingButton extends StatelessWidget {
  final String title;
  final Future<void> Function()? onTap;
  final Color? textColor;
  final Color? color;
  final BorderSide borderSide;
  final double? borderRadius;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Widget? suffixIcon;

  const LoadingButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.borderSide = BorderSide.none,
    this.fontFamily,
    this.fontSize,
    this.width,
    this.height,
    this.fontWeight,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: AppMargin.mH16),
      child: CustomAnimatedButton(
        onTap: onTap ?? () async {},
        width: width ?? MediaQuery.sizeOf(context).width,
        minWidth: AppSize.sW50,
        height: height ?? AppSize.sH64,
        color: onTap != null
            ? color ?? AppColors.whiteColor
            : AppColors.whiteColor,
        borderRadius: borderRadius ?? 16.r,
        disabledColor: color ?? AppColors.whiteColor,
        borderSide: borderSide,
        elevation: 0,
        loader: SizedBox(
          width: AppSize.sH25,
          height: AppSize.sH25,
          child: CircularProgressIndicator(color: AppColors.whiteColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            suffixIcon ?? const SizedBox(),
            4.szW,
            Text(
              title,
              style: getTextStyle().yellowColor.w600.s14.copyWith(
                color: onTap != null
                    ? textColor ?? AppColors.whiteColor
                    : AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
