import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final double size;
  final Color selectedColor;
  final Color unselectedBorderColor;

  const CustomRadioButton({
    required this.isSelected, required this.onTap, super.key,
    this.size = 24,
    this.selectedColor = AppColors.yellowColor,
    this.unselectedBorderColor = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? selectedColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? selectedColor : unselectedBorderColor,
            width: 3,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? size.h * 0.4 : 0,
            height: isSelected ? size.h * 0.4 : 0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
}
