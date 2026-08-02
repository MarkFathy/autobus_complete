import 'package:autobus_complete/generated/l10n.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundsSelectorRow extends StatelessWidget {
  final int selectedRounds;
  final ValueChanged<int> onRoundsChanged;

  const RoundsSelectorRow({
    required this.selectedRounds, required this.onRoundsChanged, super.key,
  });

  /// Returns the correct Arabic plural form for rounds count:
  /// 1 → جولة | 2 → جولتين | 3+ → جولات
  /// Falls back to the l10n "rounds" key for non-Arabic locales.
  String _getRoundsLabel(BuildContext context, int count) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (!isArabic) return S.of(context).rounds;
    if (count == 1) return 'جولة';
    if (count == 2) return 'جولتين';
    return 'جولات';
  }

  @override
  Widget build(BuildContext context) => Row(
      children: [
        Text(
          S.of(context).numberOfRounds,
          style: getTextStyle().s16.w600.whiteColor,
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.yellowColor.withValues(alpha: 0.4),
              width: 1.w,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedRounds,
              dropdownColor: AppColors.textFieldFillColor,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.yellowColor,
                size: 22.sp,
              ),
              style: getTextStyle().s14.w700.yellowColor,
              items: List.generate(10, (i) => i + 1).map((rounds) => DropdownMenuItem<int>(
                  value: rounds,
                  child: Text('$rounds ${_getRoundsLabel(context, rounds)}'),
                )).toList(),
              onChanged: (val) {
                if (val != null) {
                  onRoundsChanged(val);
                }
              },
            ),
          ),
        ),
      ],
    );
}
