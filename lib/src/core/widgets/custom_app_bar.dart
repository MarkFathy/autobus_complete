import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../navigation/navigator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.isAvailable = true,
    this.leading,
    this.onTap,
    this.title,
    this.action,
    this.centerTitle = true,
    this.showBackButton = true,
  });

  final bool isAvailable;
  final Function()? onTap;
  final Widget? leading;
  final Widget? title;
  final Widget? action;
  final bool centerTitle;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: title,
      centerTitle: centerTitle,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.whiteColor, width: 1),

                      color: AppColors.yellowColor,
                    ),

                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: AppColors.whiteColor,
                      size: 26.sp,
                    ),
                  ),
                  onPressed: onTap ?? () => Go.back(),
                )
              : null),
      actions: action != null ? [action!] : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
