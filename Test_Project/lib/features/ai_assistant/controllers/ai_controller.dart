import 'package:get/get.dart';

import '../../../data/repositories/ai_repository.dart';
import '../../drawing_engine/drawing_json_parser.dart';
import '../../drawing_engine/drawing_object.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class AiController extends GetxController {
  final AiRepository _repository = AiRepository();

  /// =========================
  /// CHAT STATE
  /// =========================

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  final RxBool isLoading = false.obs;

  /// =========================
  /// GENERATED DRAWING OBJECTS
  /// =========================

  final RxList<DrawingObject> generatedObjects = <DrawingObject>[].obs;

  /// =========================
  /// SEND CHAT MESSAGE
  /// =========================

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));

    try {
      isLoading.value = true;

      final response = await _repository.sendMessage(message: text);

      final aiReply = response["reply"] ?? "No response";

      messages.add(ChatMessage(text: aiReply, isUser: false));
    } catch (e) {
      messages.add(
        ChatMessage(text: "AI error: ${e.toString()}", isUser: false),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// =========================
  /// GENERATE ENGINEERING DRAWING
  /// =========================

  Future<void> generateDrawing(String prompt) async {
    try {
      isLoading.value = true;

      final response = await _repository.generateDrawing(
        inputData: {"prompt": prompt},
      );

      /// Convert AI response to drawing objects
      final objects = DrawingJsonParser.parse(response);

      generatedObjects.assignAll(objects);
    } catch (e) {
      print("Drawing generation error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
