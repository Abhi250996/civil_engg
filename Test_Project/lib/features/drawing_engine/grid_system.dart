import 'package:flutter/material.dart';

class GridSystem {
  static const double gridSize = 20;

  static Offset snapToGrid(Offset point) {
    final double x = (point.dx / gridSize).round() * gridSize;
    final double y = (point.dy / gridSize).round() * gridSize;

    return Offset(x, y);
  }
}
