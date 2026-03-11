class ApiConstants {
  /// =========================
  /// BASE URL
  /// =========================

  static const String baseUrl = "https://api.civilai.com";

  /// =========================
  /// AUTH ENDPOINTS
  /// =========================

  static const String login = "/auth/login";

  static const String signup = "/auth/signup";

  static const String logout = "/auth/logout";

  static const String resetPassword = "/auth/reset-password";

  /// =========================
  /// PROJECT ENDPOINTS
  /// =========================

  static const String projects = "/projects";

  static const String createProject = "/projects/create";

  static const String updateProject = "/projects/update";

  static const String deleteProject = "/projects/delete";

  /// =========================
  /// CALCULATION ENDPOINTS
  /// =========================

  static const String structuralCalculation = "/calculations/structural";

  static const String houseDesign = "/calculations/house-design";

  static const String chimneyDesign = "/calculations/chimney-design";

  /// =========================
  /// AI ASSISTANT ENDPOINT
  /// =========================

  static const String aiChat = "/ai/chat";

  static const String aiDrawing = "/ai/generate-drawing";

  /// =========================
  /// REPORT ENDPOINTS
  /// =========================

  static const String reports = "/reports";

  static const String createReport = "/reports/create";

  static const String deleteReport = "/reports/delete";

  /// =========================
  /// FILE UPLOAD
  /// =========================

  static const String uploadFile = "/files/upload";

  /// =========================
  /// API SETTINGS
  /// =========================

  static const int connectTimeout = 30000;

  static const int receiveTimeout = 30000;

  /// =========================
  /// HEADERS
  /// =========================

  static const String contentType = "application/json";

  static const String authorization = "Authorization";
}
