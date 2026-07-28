import 'package:autobus_complete/src/core/navigation/constants/imports_constants.dart';
import 'package:autobus_complete/src/core/navigation/helper/Interfaces/helper_imports.dart';
import 'package:flutter/cupertino.dart';

class SlideAnimationOptions extends AnimationOption {
  final SlideDirection? direction;
  final Tween<Offset>? customTween;

  /// You must provide either a [direction] or a [customTween]
  /// The direction of the slide animation [leftToRight] by default.
  const SlideAnimationOptions({
    this.direction,
    this.customTween,
    super.curve,
    super.reverseCurve,
    super.duration,
    super.reverseDuration,
    super.secondaryTransition,
  });

  /// You must provide either a [direction] or a [customTween]
  // :assert((direction == null && customTween != null) || (direction != null && customTween == null),
  //           'You must provide either a [direction] or a [customTween]');
}
