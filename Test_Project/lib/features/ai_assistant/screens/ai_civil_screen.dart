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
  final AiCivilController controller = Get.put(AiCivilController());

  final TextEditingController input = TextEditingController();

  final ScrollController scrollController = ScrollController();

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

  Widget buildMessage(Map<String, dynamic> msg) {
    bool isUser = msg["role"] == "user";
    bool isImage = msg["type"] == "image";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),

        padding: isImage
            ? const EdgeInsets.all(6)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),

        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 14),
          ),
        ),

        child: isImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(msg["image"].split(',').last),
                  width: 260,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                msg["message"] ?? "",
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Civil Engineering AI")),

      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: Obx(() {
              scrollToBottom();

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,

                itemBuilder: (context, index) {
                  final msg = controller.messages[index];

                  return buildMessage(msg);
                },
              );
            }),
          ),

          /// LOADING
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox();
            }

            return const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            );
          }),

          /// INPUT AREA
          Container(
            padding: const EdgeInsets.all(10),

            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
            ),

            child: Row(
              children: [
                /// TEXT INPUT
                Expanded(
                  child: TextField(
                    controller: input,

                    decoration: const InputDecoration(
                      hintText:
                          "Ask civil engineering question or 'draw beam diagram'",
                      border: OutlineInputBorder(),
                    ),

                    onSubmitted: (value) {
                      if (value.trim().isEmpty) return;

                      controller.sendMessage(value);

                      input.clear();
                    },
                  ),
                ),

                const SizedBox(width: 10),

                /// SEND BUTTON
                IconButton(
                  icon: const Icon(Icons.send),

                  onPressed: () {
                    if (input.text.trim().isEmpty) return;

                    controller.sendMessage(input.text);

                    input.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
