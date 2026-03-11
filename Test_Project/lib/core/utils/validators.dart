class Validators {
  /// =========================
  /// EMAIL VALIDATION
  /// =========================

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }

    return null;
  }

  /// =========================
  /// PASSWORD VALIDATION
  /// =========================

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  /// =========================
  /// REQUIRED FIELD
  /// =========================

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    return null;
  }

  /// =========================
  /// NUMBER VALIDATION
  /// =========================

  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }

    final number = double.tryParse(value);

    if (number == null) {
      return "$fieldName must be a number";
    }

    return null;
  }

  /// =========================
  /// POSITIVE NUMBER VALIDATION
  /// =========================

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }

    final number = double.tryParse(value);

    if (number == null) {
      return "$fieldName must be a number";
    }

    if (number <= 0) {
      return "$fieldName must be greater than 0";
    }

    return null;
  }
}
