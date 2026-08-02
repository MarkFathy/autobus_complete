import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/shake/Options/shake_animation_options.dart';
import 'package:flutter/material.dart';

class ShakeTransitionAnimation implements TransitionCreator {
  final ShakeAnimationOptions options;

  const ShakeTransitionAnimation({required this.options});

  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutBack,
      builder: (_, value, child) => Transform.translate(
          offset: getOffset(
            value,
            shakeFactor: -10,
          ),
          child: child,
        ),
      child: child,
    );
}

enum ShakeDirection { horizontal, vertical }

Offset getOffset(
  double value, {
  ShakeDirection direction = ShakeDirection.horizontal,
  double shakeFactor = 1,
}) {
  switch (direction) {
    case ShakeDirection.horizontal:
      return Offset(value * shakeFactor, 0);
    case ShakeDirection.vertical:
      return Offset(0, value * shakeFactor);
  }
}
