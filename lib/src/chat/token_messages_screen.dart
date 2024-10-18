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
  final List<Map<String, dynamic>> _messages = [];
  late String tokenContractAddress;

  @override
  void initState() {
    super.initState();
    _chatSocketService = ChatSocketService();

    tokenContractAddress = widget.token['contract_address'];

    // Initialize socket connection and join the chat
    _chatSocketService.initializeSocket(tokenContractAddress);

    // Listen for new incoming messages and update the UI if mounted
    _chatSocketService.onNewMessage((messageData) {
      if (mounted) {
        setState(() {
          _messages.add(messageData); // Add the new message to the list
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up socket listeners
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
                    child: Text(message['user'][0]), // First letter of username
                  ),
                  title: Text(message['user']),
                  subtitle: Text(message['content']),
                );
              },
            ),
          ),

          // Chat input field at the bottom
          ChatInput(onSendMessage: (message, token) {
            // Send the message using the ChatSocketService, including token data
            _chatSocketService.sendMessage(
              'UserName',
              message,
              widget.token['contract_address'], // Send contract address
            );

            // Remove the local `setState` call to avoid duplicate messages
          }),
        ],
      ),
    );
  }
}
