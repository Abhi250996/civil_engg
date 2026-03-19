import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_civil_controller.dart';

class AiCivilScreen extends StatefulWidget {
  const AiCivilScreen({super.key});

  @override
  State<AiCivilScreen> createState() => _AiCivilScreenState();
}

class _AiCivilScreenState extends State<AiCivilScreen> {
  final controller = Get.put(AiCivilController());

  final input = TextEditingController();
  final scrollController = ScrollController();

  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentBlue = Color(0xFF3B82F6);

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget messageBubble(Map<String, dynamic> msg) {
    bool isUser = msg["role"] == "user";
    bool isImage = msg["type"] == "image";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: isImage
            ? const EdgeInsets.all(6)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isUser ? accentBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(msg["image"].split(',').last),
                  width: 250,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                msg["message"] ?? "",
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// 🔥 GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, accentBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// HEADER
                  Row(
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        "AI ENGINEER ASSISTANT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CHAT CARD
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [
                          /// CHAT LIST
                          Expanded(
                            child: Obx(() {
                              scrollToBottom();

                              return ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: controller.messages.length,
                                itemBuilder: (_, i) =>
                                    messageBubble(controller.messages[i]),
                              );
                            }),
                          ),

                          /// LOADING
                          Obx(
                            () => controller.isLoading.value
                                ? const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  )
                                : const SizedBox(),
                          ),

                          /// INPUT BAR
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: input,
                                    decoration: InputDecoration(
                                      hintText: "Ask anything...",
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Container(
                                  decoration: const BoxDecoration(
                                    color: accentBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (input.text.trim().isEmpty) return;

                                      controller.sendMessage(input.text);
                                      input.clear();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
