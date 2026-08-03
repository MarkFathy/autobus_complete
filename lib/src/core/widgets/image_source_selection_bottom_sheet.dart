import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSelectionBottomSheet extends StatelessWidget {
  final ValueChanged<ImageSource> onSourceSelected;

  const ImageSourceSelectionBottomSheet({
    required this.onSourceSelected, super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ImageSource> onSourceSelected,
  }) => showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => ImageSourceSelectionBottomSheet(
        onSourceSelected: onSourceSelected,
      ),
    );

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle Pill ─────────────────────────────────────
          Container(
            width: 45.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          20.szH,

          // ── Title ────────────────────────────────────────────────
          Text(
            S.of(context).chooseImageSource,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
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
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colors.primary.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: context.colors.primary,
                            size: 28.sp,
                          ),
                        ),
                        10.szH,
                        Text(
                          S.of(context).camera,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.onSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
                      color: context.colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colors.primary.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.photo_library_rounded,
                            color: context.colors.primary,
                            size: 28.sp,
                          ),
                        ),
                        10.szH,
                        Text(
                          S.of(context).gallery,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.onSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
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
