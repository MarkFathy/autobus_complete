import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSelectionBottomSheet extends StatelessWidget {
  final ValueChanged<ImageSource> onSourceSelected;

  const ImageSourceSelectionBottomSheet({
    super.key,
    required this.onSourceSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ImageSource> onSourceSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => ImageSourceSelectionBottomSheet(
        onSourceSelected: onSourceSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Drag Handle Pill ─────────────────────────────────────
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          20.szH,

          // ── Title ────────────────────────────────────────────────
          Text(
            S.of(context).chooseImageSource,
            style: getTextStyle().s18.w700.whiteColor,
          ),
          24.szH,

          // ── Options Row (Camera & Gallery) ───────────────────────
          Row(
            children: [
              // ── Camera Option ─────────────────────────────────────
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Go.back();
                    onSourceSelected(ImageSource.camera);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.yellowColor.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: AppColors.yellowColor,
                            size: 28.sp,
                          ),
                        ),
                        10.szH,
                        Text(
                          S.of(context).camera,
                          style: getTextStyle().s16.w600.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              16.szW,

              // ── Gallery Option ────────────────────────────────────
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Go.back();
                    onSourceSelected(ImageSource.gallery);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.yellowColor.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo_library_rounded,
                            color: AppColors.yellowColor,
                            size: 28.sp,
                          ),
                        ),
                        10.szH,
                        Text(
                          S.of(context).gallery,
                          style: getTextStyle().s16.w600.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          20.szH,
        ],
      ),
    );
  }
}
