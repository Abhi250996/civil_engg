import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  /// Your local AI server
  static const String baseUrl = "http://localhost:3000";

  /// =========================
  /// AI CHAT
  /// =========================

  static Future<String> sendChatMessage({required String message}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/chat"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"message": message}),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    final data = jsonDecode(response.body);

    return data["reply"] ?? "";
  }

  /// =========================
  /// AI DRAWING GENERATION
  /// =========================

  static Future<Map<String, dynamic>> generateDrawing({
    required String prompt,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/generate-drawing"),

      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    return jsonDecode(response.body);
  }
}
