import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:autobus_complete/src/config/res/font_manager.dart';
import 'package:autobus_complete/src/config/res/text_style_extensions.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';

class AppTheme {
  BuildContext context = Go.navigatorKey.currentContext!;

  static ThemeData get light => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    primaryColor: AppColors.scaffoldBackgroundColor,
    canvasColor: AppColors.scaffoldBackgroundColor,

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.yellowColor,
      selectionColor: AppColors.yellowColor.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.yellowColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: getTextStyle().whiteColor.w700.s20,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.yellowColor,
      primaryContainer: AppColors.yellowColor.withValues(alpha: 0.15),
      secondary: AppColors.redColor,
      secondaryContainer: AppColors.redColor.withValues(alpha: 0.15),
      surface: AppColors.scaffoldBackgroundColor,
      surfaceContainerHighest: AppColors.textFieldFillColor,
      error: AppColors.redColor,
      outline: AppColors.greyColor,
      onPrimary: AppColors.whiteColor,
      onSecondary: AppColors.whiteColor,
      onSurfaceVariant: AppColors.greyColor,
    ),
    splashColor: Colors.transparent,
    useMaterial3: true,
    highlightColor: AppColors.yellowColor.withValues(alpha: 0.6),
    bottomSheetTheme: BottomSheetThemeData(
      modalBackgroundColor: AppColors.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppCircular.r32),
          topRight: Radius.circular(AppCircular.r32),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      selectedItemColor: AppColors.yellowColor,
      unselectedItemColor: AppColors.greyColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.pW4),
        foregroundColor: AppColors.yellowColor,
        minimumSize: Size(AppSize.sW30, AppSize.sH30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCircular.r8)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppCircular.r20)),
    ),
    iconTheme: const IconThemeData(color: AppColors.yellowColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.scaffoldBackgroundColor,
      prefixIconColor: AppColors.greyColor,
      hintStyle: getTextStyle().greyColor.w400.s14,
      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.pW16, vertical: AppPadding.pH16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppCircular.r12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: const BorderSide(color: AppColors.yellowColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppCircular.r12),
        borderSide: const BorderSide(color: AppColors.redColor, width: 2),
      ),
    ),
  );
}
