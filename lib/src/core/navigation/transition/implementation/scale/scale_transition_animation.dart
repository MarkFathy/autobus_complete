import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Animator/scale_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Options/scale_animation_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScaleTransitionAnimation implements TransitionCreator {
  final ScaleAnimationOptions options;
  const ScaleTransitionAnimation({
    this.options = const ScaleAnimationOptions(),
  });

  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => ScaleTransition(
      scale: ScaleAnimator(options).animator(animation),
      child: child,
    ).buildSecondaryTransition(
      animation: animation,
      applySecondaryTransition: options.secondaryTransition,
    );
}
