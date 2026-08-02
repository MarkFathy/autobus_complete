import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/fade/Option/fade_animation_option.dart';
import 'package:flutter/material.dart';

class FadeAnimator extends Animator<double>
    implements TweenBehaviour<double>, CurveBehaviour {
  final FadeAnimationOptions options;

  FadeAnimator(this.options);

  @override
  CurvedAnimation setCurveAnimation(Animation<double> animation) => CurvedAnimation(
      parent: animation,
      curve: options.curve ?? RouterConstants.transitionCurve,
      reverseCurve:
          options.reverseCurve ?? RouterConstants.reverseTransitionCurve,
    );

  @override
  Tween<double> setTween() => Tween<double>(begin: options.begin, end: options.end);

  @override
  Animation<double> animator(Animation<double> animation) => setTween().animate(setCurveAnimation(animation));
}
