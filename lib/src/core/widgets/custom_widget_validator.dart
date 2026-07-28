import 'package:flutter/material.dart';

class CustomWidgetValidator<T> extends StatelessWidget {
  final T? initialValue;
  final FormFieldValidator<T> validator;
  final Widget? child;
  final Widget Function(FormFieldState<T> value) builder;
  final InputDecoration? decoration;
  const CustomWidgetValidator(
      {super.key,
      this.initialValue,
      required this.validator,
      this.child,
      this.decoration,
      required this.builder});

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      validator: validator,
      builder: (FormFieldState<T> field) {
        return builder(field);
      },
    );
  }
}
