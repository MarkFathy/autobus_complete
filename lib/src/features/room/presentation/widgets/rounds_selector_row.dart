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
    super.key,
    required this.selectedRounds,
    required this.onRoundsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              items: List.generate(10, (i) => i + 1).map((rounds) {
                return DropdownMenuItem<int>(
                  value: rounds,
                  child: Text('$rounds ${S.of(context).rounds}'),
                );
              }).toList(),
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
}
