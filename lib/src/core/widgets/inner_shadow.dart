import 'package:flutter/material.dart';

class InnerShadow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blur;
  final Offset offset;
  final double spread;

  const InnerShadow({
    required this.child,
    super.key,
    this.color = Colors.black26,
    this.blur = 10,
    this.offset = const Offset(0, 4),
    this.spread = 0,
  });

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: _InnerShadowPainter(color: color, blur: blur, offset: offset, spread: spread),
          ),
        ),
      ),
    ],
  );
}

class _InnerShadowPainter extends CustomPainter {
  final Color color;
  final double blur;
  final Offset offset;
  final double spread;

  _InnerShadowPainter({required this.color, required this.blur, required this.offset, required this.spread});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final shadowRect = rect.shift(offset).inflate(spread);

    final paint = Paint()
      ..blendMode = BlendMode.srcATop
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    canvas
      ..saveLayer(rect, Paint())
      ..drawRect(shadowRect, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_) => false;
}
