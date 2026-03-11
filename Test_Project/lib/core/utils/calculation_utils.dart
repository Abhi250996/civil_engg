import 'dart:math';

class CalculationUtils {
  /// =========================
  /// AREA CALCULATIONS
  /// =========================

  /// Rectangle Area
  static double rectangleArea({required double length, required double width}) {
    return length * width;
  }

  /// Square Area
  static double squareArea({required double side}) {
    return side * side;
  }

  /// Circle Area
  static double circleArea({required double radius}) {
    return pi * radius * radius;
  }

  /// Triangle Area
  static double triangleArea({required double base, required double height}) {
    return 0.5 * base * height;
  }

  /// =========================
  /// VOLUME CALCULATIONS
  /// =========================

  /// Rectangular Volume
  static double rectangularVolume({
    required double length,
    required double width,
    required double height,
  }) {
    return length * width * height;
  }

  /// Cylinder Volume
  static double cylinderVolume({
    required double radius,
    required double height,
  }) {
    return pi * radius * radius * height;
  }

  /// =========================
  /// PERIMETER
  /// =========================

  static double rectanglePerimeter({
    required double length,
    required double width,
  }) {
    return 2 * (length + width);
  }

  /// =========================
  /// COLUMN GRID CALCULATION
  /// =========================

  /// Calculates number of columns along a direction
  static int columnCount({
    required double totalLength,
    required double spacing,
  }) {
    if (spacing <= 0) return 0;

    return (totalLength / spacing).floor() + 1;
  }

  /// Calculates spacing between columns
  static double columnSpacing({
    required double totalLength,
    required int columnCount,
  }) {
    if (columnCount <= 1) return totalLength;

    return totalLength / (columnCount - 1);
  }

  /// =========================
  /// DISTANCE BETWEEN POINTS
  /// =========================

  static double distanceBetweenPoints({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
  }) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  /// =========================
  /// DEGREE TO RADIAN
  /// =========================

  static double degreeToRadian(double degree) {
    return degree * (pi / 180);
  }

  /// =========================
  /// RADIAN TO DEGREE
  /// =========================

  static double radianToDegree(double radian) {
    return radian * (180 / pi);
  }
}
