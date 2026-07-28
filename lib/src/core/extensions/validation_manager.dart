import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';

extension FormFieldExtension on Widget {
  FormField<T> toFormField<T>({
    Key? key,
    String? locale,
    bool center = false,
    T? initialValue,
    String? Function(T?)? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) {
    return FormField<T>(
      key: key,
      initialValue: initialValue,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<T> validateState) {
        return Container(
          decoration: validateState.hasError
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppCircular.r16),
                  border: Border.all(color: AppColors.yellowColor),
                )
              : null,
          child: this,
        );
      },
    );
  }
}
