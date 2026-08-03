import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordButton extends StatelessWidget {
  final VoidCallback onTap;
  const ForgetPasswordButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topEnd,
    child: GestureDetector(
      onTap: onTap,
      child: Text(
        S.of(context).forgotPassword,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
