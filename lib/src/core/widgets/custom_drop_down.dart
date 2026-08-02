import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/models/drop_down_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    required this.list, required this.onChanged, super.key,
    this.hint,
    this.label,
    this.padding,
    this.isRequired = false,
    this.value,
    this.prefixIcon,
    this.icon,
    this.fillColor,
    this.borderColor,
  });

  final List<DropDownModel> list;
  final String? hint;
  final ValueChanged<DropDownModel?> onChanged;
  final String? label;
  final EdgeInsets? padding;
  final bool isRequired;
  final DropDownModel? value;
  final Widget? prefixIcon;
  final Widget? icon;
  final Color? fillColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final selectValue = ValueNotifier<DropDownModel?>(value);
    return ValueListenableBuilder<DropDownModel?>(
      valueListenable: selectValue,
      builder: (context, value, child) => Padding(
          padding: padding ?? EdgeInsets.symmetric(vertical: AppPadding.pH10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                Row(
                  children: [
                    Text(label!, style: getTextStyle().whiteColor.s12.w400),
                    if (isRequired)
                      Text('*', style: getTextStyle().whiteColor.s12.w400),
                  ],
                ),
                SizedBox(height: AppSize.sH8),
              ],
              Container(
                width: double.infinity,
                height: 65.h,
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.pH16,
                  // vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: fillColor ?? AppColors.whiteColor,
                  border: Border.all(
                    color: borderColor ?? AppColors.whiteColor,
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(AppCircular.r16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    prefixIcon ?? const SizedBox(),
                    Expanded(
                      child: DropdownButton<DropDownModel>(
                        hint: hint != null
                            ? Text(
                                hint!,
                                style:
                                    getTextStyle().s14.w400.whiteColor,
                              )
                            : null,
                        style: getTextStyle().s14.w400.whiteColor,
                        value: value,
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon:
                            icon ??
                            const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.whiteColor,
                            ),
                        dropdownColor: AppColors.whiteColor,
                        items: list
                            .map(
                              (value) => DropdownMenuItem<DropDownModel>(
                                value: value,
                                child: Text(
                                  value.name,
                                  style: const TextStyle()
                                      .s14
                                      .w400
                                      .whiteColor,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectValue.value = value;
                          onChanged.call(selectValue.value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
