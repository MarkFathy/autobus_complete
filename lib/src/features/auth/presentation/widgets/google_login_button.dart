
import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  const GoogleLoginButton({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.yellowColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Text(
              S.of(context).loginWithGoogle,
              style: getTextStyle().s22.blackColor.w700,
            ),
            10.szW,
            Assets.svgs.google.svg(
              width: 40.w,
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}