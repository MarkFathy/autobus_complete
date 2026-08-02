import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSelectorSection extends StatelessWidget {
  final Set<String> selectedCategories;
  final ValueChanged<Set<String>> onCategoriesChanged;

  /// Dynamic categories fetched from Firestore via RoomCubit.
  /// Falls back to localized defaults if empty.
  final List<RoomCategoryEntity> availableCategories;

  const CategoriesSelectorSection({
    required this.selectedCategories, required this.onCategoriesChanged, super.key,
    this.availableCategories = const [],
  });

  @override
  Widget build(BuildContext context) {
    final categories = RoomCategoryEntity.getOrderedCategories(availableCategories);

    final total = categories.length;
    final isValid = selectedCategories.length >= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).categories,
              style: getTextStyle().s16.w600.whiteColor,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isValid
                    ? AppColors.yellowColor.withValues(alpha: 0.15)
                    : AppColors.redColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isValid ? AppColors.yellowColor : AppColors.redColor,
                  width: 1.w,
                ),
              ),
              child: Text(
                '${selectedCategories.length}/$total',
                style: isValid
                    ? getTextStyle().s12.w700.yellowColor
                    : getTextStyle().s12.w700.redColor,
              ),
            ),
          ],
        ),
        6.szH,
        Text(
          S.of(context).selectAtLeast4Categories,
          style: getTextStyle().s12.w400.greyColor,
        ),
        14.szH,

        // ── Category Chips ────────────────────────────────────────────
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.w,
          runSpacing: 12.h,
          children: categories.map((cat) {
            final isSelected = selectedCategories.contains(cat.id);
            return CategoryChip(
              emoji: cat.icon,
              name: cat.getLocalizedName(context),
              isSelected: isSelected,
              onTap: () {
                final updated = Set<String>.from(selectedCategories);
                isSelected ? updated.remove(cat.id) : updated.add(cat.id);
                onCategoriesChanged(updated);
              },
            );
          }).toList(),
        ),

        // ── Validation Banner ─────────────────────────────────────────
        if (!isValid) ...[
          14.szH,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.redColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.redColor.withValues(alpha: 0.4),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.redColor, size: 18.sp),
                8.szW,
                Expanded(
                  child: Text(
                    S.of(context).selectAtLeast4Categories,
                    style: getTextStyle().s12.w600.redColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
