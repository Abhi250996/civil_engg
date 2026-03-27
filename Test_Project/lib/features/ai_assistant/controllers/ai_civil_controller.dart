import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiCivilController extends GetxController {
  /// CHAT MESSAGE STORAGE
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  /// LOADING STATE
  final RxBool isLoading = false.obs;

  /// API ENDPOINTS
  /// Android emulator -> http://10.0.2.2:3000
  /// Web/Desktop -> https://civilengg-production.up.railway.app
  final String baseUrl = "https://civilengg-production.up.railway.app";

  late final String chatApi;
  late final String imageApi;

  @override
  void onInit() {
    super.onInit();

    chatApi = "$baseUrl/ai-chat";
    imageApi = "$baseUrl/generate-drawing";

    /// Initial AI welcome message
    messages.add({
      "role": "ai",
      "type": "text",
      "message":
          "👷 Civil Engineering AI Assistant Ready.\n\nAsk about:\n• Concrete\n• Steel\n• Footing\n• Draw engineering diagrams",
      "time": DateTime.now().toString(),
    });
  }

  /// MAIN MESSAGE FUNCTION
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    /// ADD USER MESSAGE
    messages.add({
      "role": "user",
      "type": "text",
      "message": text,
      "time": DateTime.now().toString(),
    });

    isLoading.value = true;

    try {
      /// DETECT IMAGE REQUEST
      bool wantsImage =
          text.toLowerCase().contains("draw") ||
          text.toLowerCase().contains("diagram") ||
          text.toLowerCase().contains("plan") ||
          text.toLowerCase().contains("layout");

      if (wantsImage) {
        await generateImage(text);
      } else {
        await generateChat(text);
      }
    } catch (e) {
      messages.add({
        "role": "ai",
        "type": "text",
        "message": "⚠ AI server connection error.",
        "time": DateTime.now().toString(),
      });
    }

    isLoading.value = false;
  }

  /// CHAT RESPONSE
  Future<void> generateChat(String text) async {
    final response = await http.post(
      Uri.parse(chatApi),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      messages.add({
        "role": "ai",
        "type": "text",
        "message": data["reply"] ?? "No response",
        "time": DateTime.now().toString(),
      });
    } else {
      messages.add({
        "role": "ai",
        "type": "text",
        "message": "AI failed to respond.",
        "time": DateTime.now().toString(),
      });
    }
  }

  /// IMAGE GENERATION
  Future<void> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse(imageApi),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      messages.add({
        "role": "ai",
        "type": "image",
        "image": data["image"],
        "time": DateTime.now().toString(),
      });
    } else {
      messages.add({
        "role": "ai",
        "type": "text",
        "message": "Image generation failed.",
        "time": DateTime.now().toString(),
      });
    }
  }
}
