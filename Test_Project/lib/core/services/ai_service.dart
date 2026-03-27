import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  /// Your local AI server
  static const String baseUrl = "https://civilengg-production.up.railway.app";

  /// =========================
  /// AI CHAT
  /// =========================

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
