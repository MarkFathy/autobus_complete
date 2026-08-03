import 'dart:convert';
import 'dart:io';
import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileAvatar extends StatelessWidget {
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

  ImageProvider _getImageProvider() {
    if (imageFile != null) {
      return FileImage(imageFile!);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('data:image')) {
        try {
          final base64Str = imageUrl!.split(',').last;
          return MemoryImage(base64Decode(base64Str));
        } on Object catch (_) {}
      }
      return NetworkImage(imageUrl!);
    }
    return AssetImage(Assets.pngs.userimage.path);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
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
        child: CircleAvatar(
          radius: radius.r,
          backgroundColor: context.colors.surfaceContainerHighest,
          backgroundImage: _getImageProvider(),
        ),
      ),
    );
}
