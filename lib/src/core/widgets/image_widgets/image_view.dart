import 'package:autobus_complete/src/config/res/app_sizes.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.child,
    this.minScale = 0.0,
    this.maxScale = 1.0,
  });

  final Widget child;
  final double minScale;
  final double maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: InteractiveViewer(
                minScale: minScale,
                maxScale: maxScale,
                scaleFactor: 1.0,
                child: child,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppPadding.pH12),
              child: const CloseButton(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
