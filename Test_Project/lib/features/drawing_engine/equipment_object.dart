import 'package:flutter/material.dart';
import 'drawing_object.dart';

enum EquipmentType { tank, pump, valve, compressor, exchanger, generic }

class EquipmentObject extends DrawingObject {
  Offset position;
  double size;

  EquipmentType type;

  Color color;

  EquipmentObject({
    required String id,
    required this.position,
    required this.type,
    this.size = 40,
    this.color = Colors.black,
    String? label,
  }) : super(id: id, label: label);

  @override
  void draw(Canvas canvas, Size sizeCanvas) {
    if (!visible) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    switch (type) {
      case EquipmentType.tank:
        canvas.drawCircle(position, size / 2, paint);
        break;

      case EquipmentType.pump:
        canvas.drawRect(
          Rect.fromCenter(center: position, width: size, height: size),
          paint,
        );
        break;

      case EquipmentType.valve:
        canvas.drawLine(
          Offset(position.dx - size / 2, position.dy - size / 2),
          Offset(position.dx + size / 2, position.dy + size / 2),
          paint,
        );
        canvas.drawLine(
          Offset(position.dx - size / 2, position.dy + size / 2),
          Offset(position.dx + size / 2, position.dy - size / 2),
          paint,
        );
        break;

      case EquipmentType.compressor:
        canvas.drawCircle(position, size / 2, paint);
        canvas.drawLine(
          position,
          Offset(position.dx + size / 2, position.dy),
          paint,
        );
        break;

      case EquipmentType.exchanger:
        canvas.drawRect(
          Rect.fromCenter(center: position, width: size, height: size / 2),
          paint,
        );
        break;

      case EquipmentType.generic:
        canvas.drawCircle(position, size / 3, paint);
        break;
    }

    /// draw equipment label
    if (label != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(position.dx - textPainter.width / 2, position.dy + size / 2 + 4),
      );
    }
  }

  @override
  void translate(Offset delta) {
    position += delta;
  }

  @override
  void scale(double factor) {
    position = Offset(position.dx * factor, position.dy * factor);
    size *= factor;
  }

  @override
  bool hitTest(Offset point) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    return rect.contains(point);
  }

  /// REQUIRED FOR SELECTION HIGHLIGHT
  @override
  Rect getBounds() {
    return Rect.fromCenter(center: position, width: size, height: size);
  }
}
