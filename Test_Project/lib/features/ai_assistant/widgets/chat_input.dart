import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  /// =========================
  /// SEND MESSAGE
  /// =========================

  void sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    widget.onSend(text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.1)),
        ],
      ),

      child: Row(
        children: [
          /// MESSAGE INPUT
          Expanded(
            child: TextField(
              controller: _controller,

              decoration: const InputDecoration(
                hintText: "Ask engineering question...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),

              onSubmitted: (_) => sendMessage(),
            ),
          ),

          const SizedBox(width: 8),

          /// SEND BUTTON
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
