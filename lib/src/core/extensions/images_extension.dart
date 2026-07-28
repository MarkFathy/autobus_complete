import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension Images on String {
  Widget toSVG({double? width, double? height, BoxFit? boxFit, Color? color}) =>
      SvgPicture.asset(
        this,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.contain,
        color: color,
      );

  Widget toAsset({
    double? width,
    double? height,
    BoxFit? boxFit,
    Color? color,
    double? scale,
  }) => Image.asset(
    this,
    height: height,
    width: width,
    fit: boxFit ?? BoxFit.contain,
    color: color,
    scale: scale,
  );
}
