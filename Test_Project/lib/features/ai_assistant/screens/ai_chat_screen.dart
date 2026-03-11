import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ai_controller.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AiController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant")),

      body: Column(
        children: [
          /// =========================
          /// CHAT MESSAGES
          /// =========================
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Text(
                    "Ask engineering questions to AI",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: controller.messages.length,

                itemBuilder: (context, index) {
                  final message = controller.messages[index];

                  return ChatBubble(
                    message: message.text,
                    isUser: message.isUser,
                  );
                },
              );
            }),
          ),

          /// =========================
          /// INPUT AREA
          /// =========================
          ChatInput(onSend: controller.sendMessage),
        ],
      ),
    );
  }
}
