import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NonHostWaitingBanner extends StatelessWidget {
  final String text;

  const NonHostWaitingBanner({
    required this.text, super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.primary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
}
