
import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';

class ForgetPasswordButton extends StatelessWidget {
  final VoidCallback onTap;
  const ForgetPasswordButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          S.of(context).forgotPassword,
          style: getTextStyle().greyColor.s18.w600,
        ),
      ),
    );
  }
}
