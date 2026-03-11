import 'package:flutter/material.dart';

/// Base class for all drawing objects
/// Every engineering object must extend this

abstract class DrawingObject {
  /// Unique id for object
  final String id;

  /// Optional label
  final String? label;

  /// Visibility flag
  bool visible;

  DrawingObject({required this.id, this.label, this.visible = true});

  /// =========================
  /// DRAW OBJECT
  /// =========================

  void draw(Canvas canvas, Size size);

  /// =========================
  /// MOVE OBJECT
  /// =========================

  void translate(Offset delta);

  /// =========================
  /// SCALE OBJECT
  /// =========================

  void scale(double factor);

  /// =========================
  /// TAP DETECTION
  /// =========================

  bool hitTest(Offset point);

  /// =========================
  /// BOUNDING BOX
  /// Used for selection highlight
  /// =========================

  Rect getBounds();

  /// =========================
  /// DRAW SELECTION BOUNDS
  /// =========================

  void drawBounds(Canvas canvas, Paint paint) {
    final rect = getBounds();

    canvas.drawRect(rect.inflate(4), paint);
  }
}
