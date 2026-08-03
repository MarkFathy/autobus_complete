import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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
            color: context.colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.3),
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
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.szH,
                    Text(
                      email,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
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
