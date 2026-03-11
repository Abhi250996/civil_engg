import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String serverUrl = "http://localhost:3000";

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
      Uri.parse("$serverUrl/chat"),
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
      Uri.parse("$serverUrl/generate-drawing"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(inputData),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    return jsonDecode(response.body);
  }

  /// =========================
  /// AI CALCULATION SUGGESTION
  /// =========================

  Future<Map<String, dynamic>> getCalculationSuggestion({
    required Map<String, dynamic> data,
  }) async {
    final response = await http.post(
      Uri.parse("$serverUrl/calculation"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception("AI Server Error: ${response.body}");
    }

    return jsonDecode(response.body);
  }
}
