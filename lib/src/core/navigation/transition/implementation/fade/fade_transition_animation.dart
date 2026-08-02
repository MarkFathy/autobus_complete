import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Animator/fade_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Option/fade_animation_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeTransitionAnimation implements TransitionCreator {
  final FadeAnimationOptions options;

  const FadeTransitionAnimation({required this.options});

  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => FadeTransition(
      opacity: FadeAnimator(options).animator(animation),
      child: child,
    );
}
