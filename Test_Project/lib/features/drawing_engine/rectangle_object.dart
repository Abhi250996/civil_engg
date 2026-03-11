import 'package:flutter/material.dart';
import 'drawing_object.dart';

class RectangleObject extends DrawingObject {
  Rect rect;

  Color color;
  double strokeWidth;
  bool filled;

  RectangleObject({
    required String id,
    required this.rect,
    this.color = Colors.black,
    this.strokeWidth = 2,
    this.filled = false,
    String? label,
  }) : super(id: id, label: label);

  /// Draw rectangle
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;

    canvas.drawRect(rect, paint);

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
          rect.center.dx - textPainter.width / 2,
          rect.center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  /// Move rectangle
  @override
  void translate(Offset delta) {
    rect = rect.shift(delta);
  }

  /// Scale rectangle
  @override
  void scale(double factor) {
    rect = Rect.fromLTWH(
      rect.left * factor,
      rect.top * factor,
      rect.width * factor,
      rect.height * factor,
    );
  }

  /// Detect tap
  @override
  bool hitTest(Offset point) {
    return rect.contains(point);
  }

  /// REQUIRED FOR SELECTION HIGHLIGHT
  @override
  Rect getBounds() {
    return rect;
  }
}
