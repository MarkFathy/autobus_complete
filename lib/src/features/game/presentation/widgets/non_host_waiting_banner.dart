import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NonHostWaitingBanner extends StatelessWidget {
  final String text;

  const NonHostWaitingBanner({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.yellowColor.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: getTextStyle().s14.w600.yellowColor,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
