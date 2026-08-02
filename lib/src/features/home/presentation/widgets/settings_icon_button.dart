import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const SettingsIconButton({
    super.key,
    this.onPressed,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: onPressed,
      icon: Container(
        height: size.r,
        width: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.yellowColor,
            width: 1.5.w,
          ),
          color: AppColors.textFieldFillColor,
        ),
        child: Icon(
          Icons.settings,
          color: AppColors.whiteColor,
          size: (size * 0.57).sp,
        ),
      ),
    );
}
