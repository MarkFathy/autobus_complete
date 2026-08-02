import 'package:autobus_complete/src/core/navigation/transition/factory/transition_creator.dart';
import 'package:autobus_complete/src/core/navigation/transition/implementation/cupertino/Options/cupertino_animation_option.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTransitionAnimation implements TransitionCreator {
  final CupertinoAnimationOptions options;

  const CupertinoTransitionAnimation({required this.options});

  @override
  Widget animate(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => options.isFullscreenDialog
        ? CupertinoFullscreenDialogTransition(
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: options.isLinearTransition,
            child: child,
          )
        : CupertinoPageTransition(
            primaryRouteAnimation: animation,
            secondaryRouteAnimation: secondaryAnimation,
            linearTransition: options.isLinearTransition,
            child: child,
          );
}
