import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  const GoogleLoginButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 55.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.primary, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).loginWithGoogle,
            style: context.textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          10.szW,
          Assets.svgs.google.svg(width: 40.w, height: 40.h),
        ],
      ),
    ),
  );
}
