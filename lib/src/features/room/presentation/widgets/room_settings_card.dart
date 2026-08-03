import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/extensions/sized_box_helper.dart';
import 'package:autobus_complete/src/features/room/domain/entities/room_entity.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/categories_selector_section.dart';
import 'package:autobus_complete/src/features/room/presentation/widgets/rounds_selector_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomSettingsCard extends StatefulWidget {
  final int initialRounds;
  final Set<String>? initialCategories;
  final List<RoomCategoryEntity> availableCategories;
  final ValueChanged<int>? onRoundsChanged;
  final ValueChanged<Set<String>>? onCategoriesChanged;

  const RoomSettingsCard({
    super.key,
    this.initialRounds = 2,
    this.initialCategories,
    this.availableCategories = const [],
    this.onRoundsChanged,
    this.onCategoriesChanged,
  });

  @override
  State<RoomSettingsCard> createState() => _RoomSettingsCardState();
}

class _RoomSettingsCardState extends State<RoomSettingsCard> {
  late int _selectedRounds;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedRounds = widget.initialRounds;
    _selectedCategories = widget.initialCategories ??
        {'boy', 'girl', 'object', 'plant', 'food', 'animal', 'country'};
  }

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Title ─────────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                color: context.colors.primary,
                size: 22.sp,
              ),
              8.szW,
              Text(
                S.of(context).roomSettings,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          16.szH,
          Divider(
            color: context.colors.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          16.szH,

          // ── Row 1: Rounds Selector ───────────────────────────────────
          RoundsSelectorRow(
            selectedRounds: _selectedRounds,
            onRoundsChanged: (rounds) {
              setState(() => _selectedRounds = rounds);
              widget.onRoundsChanged?.call(rounds);
            },
          ),
          16.szH,
          Divider(
            color: context.colors.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          16.szH,

          // ── Row 2: Categories Selector ───────────────────────────────
          CategoriesSelectorSection(
            selectedCategories: _selectedCategories,
            availableCategories: widget.availableCategories,
            onCategoriesChanged: (updatedCategories) {
              setState(() => _selectedCategories = updatedCategories);
              widget.onCategoriesChanged?.call(updatedCategories);
            },
          ),
        ],
      ),
    );
}
