import 'package:autobus_complete/src/config/res/color_manager.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator(color: AppColors.yellowColor));
}
