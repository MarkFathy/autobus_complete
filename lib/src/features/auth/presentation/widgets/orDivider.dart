import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: AppColors.greyColor.withValues(alpha: 0.4))),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            S.of(context).or,
            style: getTextStyle().s22.w700.copyWith(
              color: AppColors.greyColor.withValues(alpha: 0.4),
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: AppColors.greyColor.withValues(alpha: 0.4))),
      ],
    );
  }
}
