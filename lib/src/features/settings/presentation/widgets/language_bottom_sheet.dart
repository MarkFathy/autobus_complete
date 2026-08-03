import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
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
  }) => showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (_) => LanguageBottomSheet(
        onLanguageSelected: onLanguageSelected,
      ),
    );

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;

    return Padding(
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
            S.of(context).chooseLanguage,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
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
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.outline.withValues(alpha: 0.2),
            width: isSelected ? 1.8.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: isSelected
                    ? context.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      )
                    : context.textTheme.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: context.colors.onPrimary,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
}
