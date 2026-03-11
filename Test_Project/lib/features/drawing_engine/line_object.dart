import 'package:flutter/material.dart';
import 'drawing_object.dart';

class LineObject extends DrawingObject {
  Offset start;
  Offset end;

  Color color;
  double strokeWidth;

  LineObject({
    required String id,
    required this.start,
    required this.end,
    this.color = Colors.black,
    this.strokeWidth = 2,
    String? label,
  }) : super(id: id, label: label);

  /// Draw line on canvas
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  /// Move line
  @override
  void translate(Offset delta) {
    start += delta;
    end += delta;
  }

  /// Scale line
  @override
  void scale(double factor) {
    start = Offset(start.dx * factor, start.dy * factor);
    end = Offset(end.dx * factor, end.dy * factor);
  }

  /// Detect tap on line
  @override
  bool hitTest(Offset point) {
    const double tolerance = 6;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final length = (dx * dx + dy * dy);

    if (length == 0) return false;

    final t =
        ((point.dx - start.dx) * dx + (point.dy - start.dy) * dy) / length;

    if (t < 0 || t > 1) return false;

    final projection = Offset(start.dx + t * dx, start.dy + t * dy);

    final distance = (projection - point).distance;

    return distance <= tolerance;
  }

  /// REQUIRED FOR SELECTION HIGHLIGHT
  @override
  Rect getBounds() {
    return Rect.fromPoints(start, end).inflate(strokeWidth + 4);
  }
}
