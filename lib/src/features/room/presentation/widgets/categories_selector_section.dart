import 'dart:async';

import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSelectorSection extends StatelessWidget {
  final Set<String> selectedCategories;
  final ValueChanged<Set<String>> onCategoriesChanged;

  /// Dynamic categories fetched from Firestore via RoomCubit.
  /// Falls back to localized defaults if empty.
  final List<RoomCategoryEntity> availableCategories;

  const CategoriesSelectorSection({
    required this.selectedCategories,
    required this.onCategoriesChanged,
    super.key,
    this.availableCategories = const [],
  });

  @override
  Widget build(BuildContext context) {
    final categories = RoomCategoryEntity.getOrderedCategories(availableCategories);

    final total = categories.length;
    final isAllSelected = selectedCategories.length == total;
    final isValid = selectedCategories.length >= 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  S.of(context).categories,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                8.szW,
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isValid
                        ? context.colors.primaryContainer.withValues(alpha: 0.8)
                        : context.colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: isValid ? context.colors.primary : context.colors.secondary, width: 1.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isValid) ...[Icon(Icons.check_rounded, size: 12.sp, color: context.colors.primary), 4.szW],
                      Text(
                        '${selectedCategories.length}/$total',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: isValid ? context.colors.primary : context.colors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Select All / Deselect All Action ──────────────────────
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                if (isAllSelected) {
                  onCategoriesChanged({});
                } else {
                  onCategoriesChanged(categories.map((c) => c.id).toSet());
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Text(
                  isAllSelected ? S.of(context).deselectAll : S.of(context).selectAll,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        6.szH,
        Text(
          S.of(context).selectAtLeast4Categories,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
        ),
        14.szH,

        // ── Category Chips Wrap ─────────────────────────────────────────
        Wrap(
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

        // ── Validation Banner (Shown only when < 4 categories selected) ──
        if (!isValid) ...[
          14.szH,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: context.colors.secondaryContainer,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: context.colors.secondary.withValues(alpha: 0.4), width: 1.w),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: context.colors.secondary, size: 18.sp),
                8.szW,
                Expanded(
                  child: Text(
                    S.of(context).selectAtLeast4Categories,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
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
