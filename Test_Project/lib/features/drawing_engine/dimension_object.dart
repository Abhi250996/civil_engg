import 'package:flutter/material.dart';
import 'drawing_object.dart';

class DimensionObject extends DrawingObject {
  Offset start;
  Offset end;

  String value;

  Color color;
  double strokeWidth;

  DimensionObject({
    required String id,
    required this.start,
    required this.end,
    required this.value,
    this.color = Colors.black,
    this.strokeWidth = 1.5,
  }) : super(id: id, label: value);

  /// Draw dimension line
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    /// main dimension line
    canvas.drawLine(start, end, paint);

    /// arrow heads
    const arrowSize = 6.0;

    canvas.drawLine(start, start + const Offset(arrowSize, arrowSize), paint);
    canvas.drawLine(start, start + const Offset(arrowSize, -arrowSize), paint);

    canvas.drawLine(end, end + const Offset(-arrowSize, arrowSize), paint);
    canvas.drawLine(end, end + const Offset(-arrowSize, -arrowSize), paint);

    /// draw dimension text
    final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        midPoint.dx - textPainter.width / 2,
        midPoint.dy - textPainter.height - 4,
      ),
    );
  }

  /// move dimension
  @override
  void translate(Offset delta) {
    start += delta;
    end += delta;
  }

  /// scale dimension
  @override
  void scale(double factor) {
    start = Offset(start.dx * factor, start.dy * factor);
    end = Offset(end.dx * factor, end.dy * factor);
  }

  /// tap detection
  @override
  bool hitTest(Offset point) {
    const tolerance = 6;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final length = dx * dx + dy * dy;

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
    return Rect.fromPoints(start, end).inflate(10);
  }
}
