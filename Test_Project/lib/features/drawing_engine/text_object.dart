import 'package:flutter/material.dart';
import 'drawing_object.dart';

class TextObject extends DrawingObject {
  Offset position;
  String text;

  double fontSize;
  Color color;

  TextObject({
    required String id,
    required this.position,
    required this.text,
    this.fontSize = 14,
    this.color = Colors.black,
  }) : super(id: id, label: text);

  /// Draw text
  @override
  void draw(Canvas canvas, Size size) {
    if (!visible) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(canvas, position);
  }

  /// Move text
  @override
  void translate(Offset delta) {
    position += delta;
  }

  /// Scale text
  @override
  void scale(double factor) {
    position = Offset(position.dx * factor, position.dy * factor);
    fontSize *= factor;
  }

  /// Detect tap
  @override
  bool hitTest(Offset point) {
    return getBounds().contains(point);
  }

  /// REQUIRED FOR SELECTION
  @override
  Rect getBounds() {
    return Rect.fromLTWH(
      position.dx,
      position.dy,
      text.length * fontSize * 0.6,
      fontSize,
    );
  }
}
