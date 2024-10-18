import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String message, String contractAddress)
      onSendMessage; // Updated callback

  const ChatInput({super.key, required this.onSendMessage});

  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String tokenInfo) {
    // Accept token info as parameter
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(
          message, tokenInfo); // Send both message and token info
      _controller.clear(); // Clear the input field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(
                  "token_contract_address"), // Send message and token info on enter
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(
                'token_contract_address'), // Send message and token info on button press
          ),
        ],
      ),
    );
  }
}
