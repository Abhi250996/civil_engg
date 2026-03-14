import 'package:get/get.dart';

class AiCivilController extends GetxController {
  final RxList<Map<String, String>> messages = <Map<String, String>>[].obs;

  final RxBool isLoading = false.obs;

  /// Send message to AI
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add({"role": "user", "message": text});

    isLoading.value = true;

    try {
      /// Simulated AI response
      await Future.delayed(const Duration(seconds: 2));

      String response = generateCivilResponse(text);

      messages.add({"role": "ai", "message": response});
    } catch (e) {
      messages.add({"role": "ai", "message": "Error generating response"});
    }

    isLoading.value = false;
  }

  /// Example AI logic (replace with OpenAI later)
  String generateCivilResponse(String text) {
    text = text.toLowerCase();

    if (text.contains("concrete")) {
      return "Concrete mix ratio commonly used is 1:2:4 for general RCC.";
    }

    if (text.contains("steel")) {
      return "Steel weight formula: D² / 162 × Length.";
    }

    if (text.contains("footing")) {
      return "Footing size depends on soil bearing capacity and structural load.";
    }

    if (text.contains("brick")) {
      return "Standard bricks required per cubic meter of masonry ≈ 500 bricks.";
    }

    return "Civil engineering AI assistant ready. Ask about construction, materials, or structural design.";
  }
}
