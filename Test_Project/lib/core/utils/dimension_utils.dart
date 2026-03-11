import 'package:flutter/material.dart';

class DimensionUtils {
  /// =========================
  /// SCREEN WIDTH
  /// =========================

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// =========================
  /// SCREEN HEIGHT
  /// =========================

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// =========================
  /// RESPONSIVE WIDTH
  /// =========================

  static double responsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// =========================
  /// RESPONSIVE HEIGHT
  /// =========================

  static double responsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  /// =========================
  /// IS MOBILE
  /// =========================

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// =========================
  /// IS TABLET
  /// =========================

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1100;
  }

  /// =========================
  /// IS DESKTOP
  /// =========================

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  /// =========================
  /// DEFAULT PADDING
  /// =========================

  static const EdgeInsets screenPadding = EdgeInsets.all(16);

  /// =========================
  /// CARD PADDING
  /// =========================

  static const EdgeInsets cardPadding = EdgeInsets.all(12);

  /// =========================
  /// INPUT FIELD PADDING
  /// =========================

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
}
