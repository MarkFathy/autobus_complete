import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Animator/size_animator.dart';
import 'Option/size_animation_option.dart';

class SizeTransitionAnimation implements TransitionCreator {
  final SizeAnimationOptions options;

  const SizeTransitionAnimation({required this.options});

  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      alignment: options.alignment,
      child:
          SizeTransition(
            sizeFactor: SizeAnimator(options).animator(animation),
            axis: options.axis,
            axisAlignment: options.axisAlignment,
            child: child,
          ).buildSecondaryTransition(
            animation: animation,
            applySecondaryTransition: options.secondaryTransition,
          ),
    );
  }
}
