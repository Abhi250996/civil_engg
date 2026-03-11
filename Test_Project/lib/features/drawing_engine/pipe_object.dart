import 'package:flutter/material.dart';
import 'drawing_object.dart';

class PipeObject extends DrawingObject {
  Offset start;
  Offset end;

  double diameter;

  Color color;
  double strokeWidth;

  String? pipeLabel;

  PipeObject({
    required String id,
    required this.start,
    required this.end,
    this.diameter = 100,
    this.color = Colors.blue,
    this.strokeWidth = 4,
    this.pipeLabel,
  }) : super(id: id, label: pipeLabel);

  /// Draw pipe
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    /// Draw flow arrow
    final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2;

    canvas.drawCircle(midPoint, 3, arrowPaint);

    /// Draw pipe label
    if (pipeLabel != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: pipeLabel,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(canvas, Offset(midPoint.dx + 5, midPoint.dy - 10));
    }
  }

  /// Move pipe
  @override
  void translate(Offset delta) {
    start += delta;
    end += delta;
  }

  /// Scale pipe
  @override
  void scale(double factor) {
    start = Offset(start.dx * factor, start.dy * factor);
    end = Offset(end.dx * factor, end.dy * factor);

    strokeWidth *= factor;
  }

  /// Detect tap
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
    return Rect.fromPoints(start, end).inflate(strokeWidth + 4);
  }
}
