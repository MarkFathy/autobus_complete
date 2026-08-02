import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/slide/Option/slide_animation_option.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/slide/animator/slide_animator.dart';
import 'package:flutter/material.dart';

class SlideTransitionAnimation implements TransitionCreator {
  final SlideAnimationOptions options;
  const SlideTransitionAnimation({required this.options});
  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => SlideTransition(
      position: SliderAnimator(options).animator(animation),
      child: child,
    ).buildSecondaryTransition(
      animation: animation,
      applySecondaryTransition: options.secondaryTransition,
    );
}
