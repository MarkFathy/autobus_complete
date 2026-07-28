import 'dart:io';
import 'package:autobus_complete/gen/assets.gen.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatarPicker extends StatelessWidget {
  final File? selectedImage;
  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final double radius;

  const UserAvatarPicker({
    super.key,
    this.selectedImage,
    this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
    this.radius = 72,
  });

  ImageProvider _getImageProvider() {
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return NetworkImage(imageUrl!);
    }
    return AssetImage(Assets.pngs.userimage.path);
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        selectedImage != null || (imageUrl != null && imageUrl!.isNotEmpty);

    return Center(
      child: Stack(
        children: [
          // Avatar with Sharp Border
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.yellowColor,
                width: 2.5.w,
              ),
            ),
            child: CircleAvatar(
              radius: radius.r,
              backgroundColor: AppColors.textFieldFillColor,
              backgroundImage: _getImageProvider(),
            ),
          ),
          // + / × button
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: hasImage ? onRemoveImage : onPickImage,
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.yellowColor,
                    width: 1.5.w,
                  ),
                ),
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.textFieldFillColor,
                  child: Icon(
                    hasImage ? Icons.close : Icons.add,
                    color: AppColors.whiteColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
