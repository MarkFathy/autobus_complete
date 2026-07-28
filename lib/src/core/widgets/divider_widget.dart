import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.color});

  final Color ?color;
  @override
  Widget build(BuildContext context) {
    return  Divider(color:color?? Colors.white.withOpacity(.6));
  }
}
