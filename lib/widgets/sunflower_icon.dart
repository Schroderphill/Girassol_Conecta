import 'package:flutter/material.dart';
import 'dart:math';

class SunflowerIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const SunflowerIcon({
    super.key,
    this.size = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: SunflowerPainter(color: color ?? Theme.of(context).primaryColor),
    );
  }
}

class SunflowerPainter extends CustomPainter {
  final Color color;

  SunflowerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer petals
    final outerPetalPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * (2 * pi / 12));
      final petalPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(0, -radius * 0.6),
          width: radius * 0.16,
          height: radius * 0.5,
        ));
      canvas.drawPath(petalPath, outerPetalPaint);
      canvas.restore();
    }

    // Inner petals
    final innerPetalPaint = Paint()
      ..color = Colors.amber[400]!
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * (2 * pi / 8) + (2 * pi / 16));
      final petalPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(0, -radius * 0.5),
          width: radius * 0.12,
          height: radius * 0.36,
        ));
      canvas.drawPath(petalPath, innerPetalPaint);
      canvas.restore();
    }

    // Center
    final centerPaint = Paint()
      ..color = Colors.amber[800]!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, centerPaint);

    // Center texture
    final texturePaint = Paint()
      ..color = Colors.amber[900]!
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final angle = i * 0.8;
      final distance = (4 + (i % 3) * 2) * (radius / 50);
      final dotCenter = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );
      canvas.drawCircle(dotCenter, 1.5, texturePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}