import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double? height;
  final Color? baseColor;
  final Color? highlightColor;
  final double? margin;
  final BorderRadius? borderRadius;

  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    this.height,
    this.baseColor,
    this.highlightColor,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.shade100,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: margin ?? AppMargin.mH10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(AppCircular.r16),
          color: Colors.grey.shade100,
        ),
      ),
    );
}
