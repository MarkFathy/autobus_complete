import 'package:autobus_complete/src/config/res/constants_manager.dart';
import 'package:flutter/material.dart';

extension PaddingExtension on Widget {
  Widget padding(EdgeInsetsGeometry padding) => Padding(
      padding: padding,
      child: this,
    );

  Widget paddingSymmetric({
    double? horizontal,
    double? vertical,
  }) => Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? ConstantManager.zeroAsDouble,
        vertical: vertical ?? ConstantManager.zeroAsDouble,
      ),
      child: this,
    );

  Widget paddingAll(double padding) => Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );

  Widget paddingLeft(double padding) => Padding(
      padding: EdgeInsets.only(left: padding),
      child: this,
    );

  Widget paddingRight(double padding) => Padding(
      padding: EdgeInsets.only(right: padding),
      child: this,
    );

  Widget paddingTop(double padding) => Padding(
      padding: EdgeInsets.only(top: padding),
      child: this,
    );

  Widget paddingBottom(double padding) => Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: this,
    );

  Widget paddingStart(double padding) => Padding(
      padding: EdgeInsetsDirectional.only(start: padding),
      child: this,
    );

  Widget paddingEnd(double padding) => Padding(
      padding: EdgeInsetsDirectional.only(end: padding),
      child: this,
    );

  Widget paddingOnly({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) => Padding(
      padding: EdgeInsets.only(
        left: left ?? 0.0,
        right: right ?? 0.0,
        top: top ?? 0.0,
        bottom: bottom ?? 0.0,
      ),
      child: this,
    );

  Widget paddingOnlyDirectional({
    double? start,
    double? end,
    double? top,
    double? bottom,
  }) => Padding(
      padding: EdgeInsetsDirectional.only(
        start: start ?? 0.0,
        end: end ?? 0.0,
        top: top ?? 0.0,
        bottom: bottom ?? 0.0,
      ),
      child: this,
    );
}
