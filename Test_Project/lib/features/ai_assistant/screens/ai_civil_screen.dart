import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_civil_controller.dart';

class AiCivilScreen extends StatelessWidget {
  const AiCivilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiCivilController());

    final TextEditingController input = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Civil Engineering AI")),

      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,

                itemBuilder: (context, index) {
                  final msg = controller.messages[index];

                  bool isUser = msg["role"] == "user";

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey.shade300,

                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        msg["message"] ?? "",
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          /// LOADING
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox();

            return const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            );
          }),

          /// INPUT AREA
          Container(
            padding: const EdgeInsets.all(10),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: "Ask civil engineering question...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  icon: const Icon(Icons.send),

                  onPressed: () {
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
