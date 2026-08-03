import 'dart:math';

import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? height, width, borderWidth;
  final BorderRadius? borderRadius;
  final ColorFilter? colorFilter;
  final Alignment? alignment;
  final Widget? child;
  final Widget? placeHolder;
  final Color? borderColor;
  final Color? bgColor;
  final BoxShape? boxShape;
  final bool haveRadius;
  final EdgeInsetsGeometry? padding;

  const CachedImage({
    required this.url, super.key,
    this.fit,
    this.width,
    this.height,
    this.placeHolder,
    this.borderRadius,
    this.colorFilter,
    this.alignment,
    this.child,
    this.boxShape,
    this.borderColor,
    this.borderWidth,
    this.bgColor,
    this.padding,
    this.haveRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        memCacheHeight: height != null
            ? min((height! * devicePixelRatio).toInt(), 2048)
            : null,
        memCacheWidth: width != null
            ? min((width! * devicePixelRatio).toInt(), 2048)
            : null,
        maxHeightDiskCache: height != null
            ? min((height! * devicePixelRatio).toInt(), 2048)
            : null,
        maxWidthDiskCache: width != null
            ? min((width! * devicePixelRatio).toInt(), 2048)
            : null,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.fill,
              colorFilter: colorFilter,
            ),
            borderRadius: haveRadius
                ? borderRadius ?? BorderRadius.circular(AppCircular.r2)
                : null,
            shape: boxShape ?? BoxShape.rectangle,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 1,
            ),
          ),
          alignment: alignment ?? Alignment.center,
          child: child,
        ),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: haveRadius
                ? borderRadius ?? BorderRadius.circular(AppCircular.r2)
                : null,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            ),
            shape: boxShape ?? BoxShape.rectangle,
            color: bgColor ?? AppColors.whiteColor.withValues(alpha: .5),
          ),
          child: const CircularProgressIndicator(
            color: AppColors.whiteColor,
            strokeWidth: 2,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor ?? AppColors.whiteColor.withValues(alpha: .5),
            borderRadius: haveRadius
                ? borderRadius ?? BorderRadius.circular(AppCircular.r2)
                : null,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            ),
            shape: boxShape ?? BoxShape.rectangle,
          ),
          child: Stack(
            children: [
              placeHolder ?? child ?? Container(),
              child ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
