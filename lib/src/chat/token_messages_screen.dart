import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/user_provider.dart';
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

  // Function to format timestamp into a human-readable format
  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('MMM d, h:mm a')
        .format(dateTime); // Example: Oct 19, 3:30 PM
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    String formattedTimestamp = _formatTimestamp(
        message['timestamp']); // Assuming timestamp is in message data

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? Colors.green[400] : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(15) : Radius.zero,
                topRight: isMe ? Radius.zero : const Radius.circular(15),
                bottomLeft: const Radius.circular(15),
                bottomRight: const Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message['user'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message['content'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Timestamp outside and below the message bubble
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            formattedTimestamp,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 8,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userEmail = userProvider.user?.email ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Messages - ${widget.token['token']['tokenSymbol']?.toUpperCase()}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isMe =
                    message['user'] == userEmail; // Check if it's my message
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),

          // Chat input field at the bottom
          ChatInput(onSendMessage: (message, token) {
            // Send the message using the ChatSocketService, including token data
            _chatSocketService.sendMessage(
              userEmail,
              message,
              widget.token['contract_address'], // Send contract address
            );
          }),
        ],
      ),
    );
  }
}
