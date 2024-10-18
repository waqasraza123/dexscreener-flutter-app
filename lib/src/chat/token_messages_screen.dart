import 'package:flutter/material.dart';
import './chat_input.dart';
import '../../services/chat_socket_service.dart';

class TokenMessagesScreen extends StatefulWidget {
  final dynamic token;

  const TokenMessagesScreen({super.key, required this.token});

  @override
  TokenMessagesScreenState createState() => TokenMessagesScreenState();
}

class TokenMessagesScreenState extends State<TokenMessagesScreen> {
  late ChatSocketService _chatSocketService;
  List<Map<String, dynamic>> _messages = []; // Store incoming messages

  @override
  void initState() {
    super.initState();
    _chatSocketService = ChatSocketService();
    _chatSocketService.initializeSocket();

    // Listen for new incoming messages and update the UI
    _chatSocketService.onNewMessage((messageData) {
      setState(() {
        _messages.add(messageData); // Add the new message to the list
      });
    });
  }

  @override
  void dispose() {
    _chatSocketService.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Messages - ${widget.token['token']['tokenSymbol']?.toUpperCase()}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length, // Use the actual messages count
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(message['user']
                        [0]), // Display the first letter of the user's name
                  ),
                  title: Text(message['user']),
                  subtitle: Text(message['content']),
                );
              },
            ),
          ),
          // Chat input field at the bottom
          ChatInput(onSendMessage: (message) {
            // Send the message using the ChatSocketService
            _chatSocketService.sendMessage('UserName', message);
            // Optionally, update your UI to show the new message in the list
            setState(() {
              _messages.add({
                'user': 'UserName',
                'content': message,
                'timestamp': DateTime.now().toIso8601String(),
              });
            });
          }),
        ],
      ),
    );
  }
}
