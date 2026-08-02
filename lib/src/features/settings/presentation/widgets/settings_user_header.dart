import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/widgets/user_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsUserHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback? onTap;

  const SettingsUserHeader({
    required this.name, required this.email, super.key,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.textFieldFillColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.yellowColor.withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              UserProfileAvatar(
                radius: 30,
                imageUrl: imageUrl,
              ),
              14.szW,

              // Name and Email (Safely wrapped against long text)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: getTextStyle().s16.w700.whiteColor.ellipsis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.szH,
                    Text(
                      email,
                      style: getTextStyle().s14.w400.greyColor.ellipsis,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

          
            ],
          ),
        ),
      ),
    );
}
