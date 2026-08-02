import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/scale/Options/scale_animation_option.dart';
import 'package:flutter/animation.dart';

class ScaleAnimator extends Animator<double>
    implements CurveBehaviour, TweenBehaviour<double> {
  final ScaleAnimationOptions options;

  ScaleAnimator(this.options);

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
