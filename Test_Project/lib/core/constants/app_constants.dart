class AppConstants {
  /// =========================
  /// APP INFO
  /// =========================

  static const String appName = "Civil Engineering AI";

  static const String companyName = "Civil AI Solutions";

  static const String version = "1.0.0";

  /// =========================
  /// DRAWING SETTINGS
  /// =========================

  static const double defaultPlotPadding = 16;

  static const double defaultWallThickness = 0.23; // meters

  static const double defaultColumnSize = 0.30; // meters

  static const double defaultBeamHeight = 0.45; // meters

  /// =========================
  /// HOUSE DESIGN DEFAULTS
  /// =========================

  static const double defaultRoomHeight = 3.0; // meters

  static const double minRoomWidth = 2.5;

  static const double minRoomLength = 2.5;

  /// =========================
  /// CHIMNEY DESIGN DEFAULTS
  /// =========================

  static const double minChimneyHeight = 30;

  static const double maxChimneyHeight = 300;

  /// =========================
  /// PROJECT SETTINGS
  /// =========================

  static const int maxProjects = 100;

  static const int maxReports = 500;

  /// =========================
  /// FIELD TOOL SETTINGS
  /// =========================

  static const double gpsAccuracy = 5.0;

  /// =========================
  /// AI SETTINGS
  /// =========================

  static const int maxChatHistory = 100;

  static const int aiTimeoutSeconds = 30;

  /// =========================
  /// DRAWING EXPORT SETTINGS
  /// =========================

  static const String defaultExportFormat = "PNG";

  static const double exportResolution = 300;
}
