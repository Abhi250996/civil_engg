import 'package:flutter/material.dart';
import 'drawing_object.dart';

class CircleObject extends DrawingObject {
  Offset center;
  double radius;

  Color color;
  double strokeWidth;
  bool filled;

  CircleObject({
    required String id,
    required this.center,
    required this.radius,
    this.color = Colors.black,
    this.strokeWidth = 2,
    this.filled = false,
    String? label,
  }) : super(id: id, label: label);

  /// Draw circle
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);

    /// Draw label
    if (label != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  /// Move circle
  @override
  void translate(Offset delta) {
    center += delta;
  }

  /// Scale circle
  @override
  void scale(double factor) {
    center = Offset(center.dx * factor, center.dy * factor);
    radius *= factor;
  }

  /// Tap detection
  @override
  bool hitTest(Offset point) {
    final distance = (point - center).distance;

    return distance <= radius;
  }

  /// REQUIRED FOR SELECTION HIGHLIGHT
  @override
  Rect getBounds() {
    return Rect.fromCircle(center: center, radius: radius);
  }
}
