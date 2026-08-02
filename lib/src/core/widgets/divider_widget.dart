import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.color});

  final Color ?color;
  @override
  Widget build(BuildContext context) => Divider(color:color?? Colors.white.withValues(alpha: .6));
}
