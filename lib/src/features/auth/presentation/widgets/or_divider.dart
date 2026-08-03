import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Divider(thickness: 1, color: context.colors.outline.withValues(alpha: 0.4))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          S.of(context).or,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.outline.withValues(alpha: 0.4),
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Expanded(child: Divider(thickness: 1, color: context.colors.outline.withValues(alpha: 0.4))),
    ],
  );
}
