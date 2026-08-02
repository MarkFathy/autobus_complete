import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/rotation/Animator/rotation_animator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/rotation/Option/rotation_animation_option.dart';
import 'package:flutter/material.dart';

class RotationTransitionAnimation implements TransitionCreator {
  final RotationAnimationOptions options;

  const RotationTransitionAnimation({required this.options});

  @override
  Widget animate(Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => RotationTransition(
    turns: RotationAnimator(options).animator(animation),
    alignment: options.alignment,
    filterQuality: options.filterQuality,
    child: child,
  ).buildSecondaryTransition(animation: animation, applySecondaryTransition: options.secondaryTransition);
}
