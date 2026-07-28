import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageBottomSheet extends StatelessWidget {
  final ValueChanged<String>? onLanguageSelected;

  const LanguageBottomSheet({
    super.key,
    this.onLanguageSelected,
  });

  static Future<void> show(
    BuildContext context, {
    ValueChanged<String>? onLanguageSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => LanguageBottomSheet(
        onLanguageSelected: onLanguageSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;

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
            S.of(context).chooseLanguage,
            style: getTextStyle().s18.w700.whiteColor,
          ),
          20.szH,

          // ── English Option ────────────────────────────────────────
          _LanguageOptionTile(
            title: S.of(context).english,
            isSelected: currentLang == 'en',
            onTap: () {
              Go.back();
              onLanguageSelected?.call('en');
            },
          ),
          12.szH,

          // ── Arabic Option ─────────────────────────────────────────
          _LanguageOptionTile(
            title: S.of(context).arabic,
            isSelected: currentLang == 'ar',
            onTap: () {
              Go.back();
              onLanguageSelected?.call('ar');
            },
          ),
          24.szH,
        ],
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.textFieldFillColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.yellowColor
                : AppColors.greyColor.withValues(alpha: 0.2),
            width: isSelected ? 1.8.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: (isSelected
                        ? getTextStyle().yellowColor.w700
                        : getTextStyle().whiteColor.w600)
                    .s16,
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: AppColors.yellowColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.whiteColor,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
