import 'package:autobus_complete/src/core/extensions/context_extension.dart';
import 'package:autobus_complete/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final void Function()? onTap;
  final Widget? leading;
  final Widget? title;
  final Widget? action;
  final bool centerTitle;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => AppBar(
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
                      border: Border.all(color: context.colors.onSurface),

                      color: context.colors.primary,
                    ),

                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: context.colors.onSurface,
                      size: 26.sp,
                    ),
                  ),
                  onPressed: onTap ?? Go.back,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
