import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool safeTop;
  final bool safeBottom;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.safeTop = false,
    this.safeBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.scaffoldBackgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
        child: SafeArea(top: safeTop, bottom: safeBottom, child: body),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(
              top: safeTop,
              bottom: safeBottom,
              child: bottomNavigationBar!,
            )
          : null,
    );
  }
}
