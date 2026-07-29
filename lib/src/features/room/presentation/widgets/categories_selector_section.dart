import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem {
  final String id;
  final String emoji;
  final String name;

  const CategoryItem({
    required this.id,
    required this.emoji,
    required this.name,
  });
}

class CategoriesSelectorSection extends StatelessWidget {
  final Set<String> selectedCategories;
  final ValueChanged<Set<String>> onCategoriesChanged;

  const CategoriesSelectorSection({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  List<CategoryItem> _getCategories(BuildContext context) {
    return [
      CategoryItem(id: 'boy', emoji: '👦', name: S.of(context).boyCategory),
      CategoryItem(id: 'girl', emoji: '👧', name: S.of(context).girlCategory),
      CategoryItem(id: 'object', emoji: '📦', name: S.of(context).objectCategory),
      CategoryItem(id: 'plant', emoji: '🌿', name: S.of(context).plantCategory),
      CategoryItem(id: 'food', emoji: '🍔', name: S.of(context).foodCategory),
      CategoryItem(id: 'animal', emoji: '🦁', name: S.of(context).animalCategory),
      CategoryItem(id: 'country', emoji: '🚩', name: S.of(context).countryCategory),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getCategories(context);
    final isAtLeastFour = selectedCategories.length >= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Categories Header ──────────────────────────────────────────
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
                color: isAtLeastFour
                    ? AppColors.yellowColor.withValues(alpha: 0.15)
                    : AppColors.redColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isAtLeastFour
                      ? AppColors.yellowColor
                      : AppColors.redColor,
                  width: 1.w,
                ),
              ),
              child: Text(
                '${selectedCategories.length}/7',
                style: isAtLeastFour
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

        // ── Interactive Categories Selection Wrap ────────────────────
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.w,
          runSpacing: 12.h,
          children: categories.map((cat) {
            final isSelected = selectedCategories.contains(cat.id);
            return CategoryChip(
              emoji: cat.emoji,
              name: cat.name,
              isSelected: isSelected,
              onTap: () {
                final updatedSet = Set<String>.from(selectedCategories);
                if (isSelected) {
                  updatedSet.remove(cat.id);
                } else {
                  updatedSet.add(cat.id);
                }
                onCategoriesChanged(updatedSet);
              },
            );
          }).toList(),
        ),

        // Validation Warning Banner
        if (!isAtLeastFour) ...[
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
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.redColor,
                  size: 18.sp,
                ),
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
