import 'dart:convert';
import 'dart:io';

import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileAvatar extends StatelessWidget {
  static final Map<String, Uint8List> _base64Cache = {};

  final File? imageFile;
  final String? imageUrl;
  final double radius;
  final double borderWidth;
  final Color? borderColor;
  final VoidCallback? onTap;

  const UserProfileAvatar({
    super.key,
    this.imageFile,
    this.imageUrl,
    this.radius = 18,
    this.borderWidth = 2,
    this.borderColor,
    this.onTap,
  });

  Uint8List? _getDecodedBase64(String dataUrl) {
    if (_base64Cache.containsKey(dataUrl)) {
      return _base64Cache[dataUrl];
    }
    try {
      final base64Str = dataUrl.split(',').last;
      final bytes = base64Decode(base64Str);
      _base64Cache[dataUrl] = bytes;
      return bytes;
    } on Object catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diameter = (radius * 2).r;

    Widget imageWidget;
    if (imageFile != null) {
      imageWidget = Image.file(
        imageFile!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('data:image')) {
        final bytes = _getDecodedBase64(imageUrl!);
        if (bytes != null) {
          imageWidget = Image.memory(
            bytes,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        } else {
          imageWidget = Image.asset(
            Assets.pngs.userimage.path,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        }
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: imageUrl!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          useOldImageOnUrlChange: true,
          placeholder: (context, url) => Image.asset(
            Assets.pngs.userimage.path,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
          errorWidget: (context, url, error) => Image.asset(
            Assets.pngs.userimage.path,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        );
      }
    } else {
      imageWidget = Image.asset(
        Assets.pngs.userimage.path,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? context.colors.primary,
            width: borderWidth.w,
          ),
        ),
        child: ClipOval(
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: imageWidget,
          ),
        ),
      ),
    );
  }
}
