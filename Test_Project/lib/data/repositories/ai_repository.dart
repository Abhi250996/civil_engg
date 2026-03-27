import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:build_pro/core/utils/api_config.dart';

class AiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// =========================
  /// AI CHAT
  /// =========================

  Future<Map<String, dynamic>> sendMessage({required String message}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    /// Save user message
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("ai_chat")
        .add({
          "message": message,
          "isUser": true,
          "createdAt": FieldValue.serverTimestamp(),
        });

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    final data = jsonDecode(response.body);

    final aiReply = data["reply"] ?? "";

    /// Save AI reply
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("ai_chat")
        .add({
          "message": aiReply,
          "isUser": false,
          "createdAt": FieldValue.serverTimestamp(),
        });

    return {"reply": aiReply};
  }

  /// =========================
  /// AI DRAWING GENERATION
  /// =========================
  Future<Map<String, dynamic>> generateDrawing({
    required Map<String, dynamic> inputData,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/generate-drawing"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(inputData),
    );

    print(jsonEncode(inputData));

    final data = jsonDecode(response.body);

    // print("AI SERVER RESPONSE:");
    // print(data);

    return data;
  }

  /// =========================
  /// AI CALCULATION SUGGESTION
  /// =========================

  Future<Map<String, dynamic>> getCalculationSuggestion({
    required Map<String, dynamic> data,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/calculation"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    return jsonDecode(response.body);
  }
}
