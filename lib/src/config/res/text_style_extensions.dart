import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TextStyleEx on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get s8 => copyWith(fontSize: 8.sp);
  TextStyle get s10 => copyWith(fontSize: 10.sp);
  TextStyle get s11 => copyWith(fontSize: 11.sp);
  TextStyle get s12 => copyWith(fontSize: 12.sp);
  TextStyle get s14 => copyWith(fontSize: 14.sp);
  TextStyle get s16 => copyWith(fontSize: 16.sp);
  TextStyle get s18 => copyWith(fontSize: 18.sp);
  TextStyle get s20 => copyWith(fontSize: 20.sp);
  TextStyle get s22 => copyWith(fontSize: 22.sp);
  TextStyle get s24 => copyWith(fontSize: 24.sp);
  TextStyle get s26 => copyWith(fontSize: 26.sp);
  TextStyle get s28 => copyWith(fontSize: 28.sp);
  TextStyle get s32 => copyWith(fontSize: 32.sp);
  TextStyle get s40 => copyWith(fontSize: 40.sp);
  TextStyle get s50 => copyWith(fontSize: 50.sp);

  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get overLine => copyWith(decoration: TextDecoration.overline);
  TextStyle get ellipsis => copyWith(overflow: TextOverflow.ellipsis);

  TextStyle get scaffoldBackgroundColor => copyWith(color: AppColors.scaffoldBackgroundColor);
  TextStyle get whiteColor => copyWith(color: AppColors.whiteColor);
  TextStyle get white => copyWith(color: AppColors.whiteColor);
  TextStyle get yellowColor => copyWith(color: AppColors.yellowColor);
  TextStyle get yellow => copyWith(color: AppColors.yellowColor);
  TextStyle get redColor => copyWith(color: AppColors.redColor);
  TextStyle get red => copyWith(color: AppColors.redColor);
  TextStyle get cyanColor => copyWith(color: AppColors.cyanColor);
  TextStyle get cyan => copyWith(color: AppColors.cyanColor);
  TextStyle get greyColor => copyWith(color: AppColors.greyColor);
  TextStyle get grey => copyWith(color: AppColors.greyColor);
  TextStyle get blackColor => copyWith(color: AppColors.blackColor);
  TextStyle get black => copyWith(color: AppColors.blackColor);
  TextStyle get textFieldFillColor => copyWith(color: AppColors.textFieldFillColor);
}
