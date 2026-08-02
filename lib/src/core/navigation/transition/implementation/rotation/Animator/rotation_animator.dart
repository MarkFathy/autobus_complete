import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/rotation/Option/rotation_animation_option.dart';
import 'package:flutter/animation.dart';

class RotationAnimator extends Animator<double>
    implements TweenBehaviour<double>, CurveBehaviour {
  final RotationAnimationOptions options;

  RotationAnimator(this.options);

  @override
  CurvedAnimation setCurveAnimation(Animation<double> animation) => CurvedAnimation(
      parent: animation,
      curve: options.curve ?? RouterConstants.transitionCurve,
      reverseCurve:
          options.reverseCurve ?? RouterConstants.reverseTransitionCurve,
    );

  @override
  Tween<double> setTween() {
    final tween = Tween<double>(begin: options.begin, end: options.end);
    return tween;
  }

  @override
  Animation<double> animator(Animation<double> animation) => setTween().animate(setCurveAnimation(animation));
}
