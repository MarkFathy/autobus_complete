import 'package:flutter/material.dart';

class CustomWidgetValidator<T> extends StatelessWidget {
  final T? initialValue;
  final FormFieldValidator<T> validator;
  final Widget? child;
  final Widget Function(FormFieldState<T> value) builder;
  final InputDecoration? decoration;
  const CustomWidgetValidator(
      {required this.validator, required this.builder, super.key,
      this.initialValue,
      this.child,
      this.decoration});

  @override
  Widget build(BuildContext context) => FormField(
      initialValue: initialValue,
      validator: validator,
      builder: builder,
    );
}
