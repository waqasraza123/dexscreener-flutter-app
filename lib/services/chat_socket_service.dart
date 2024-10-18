import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class ChatSocketService {
  late IO.Socket _socket;
  final Logger _logger = Logger();

  void initializeSocket() {
    // Connect to the Node.js server
    final apiUrl = dotenv.env['SOCKET_BASE_URL'];
    _socket = IO.io(apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listen for connection
    _socket.onConnect((_) {
      _logger.i('Connected to server');
    });

    // Listen for new incoming messages
    _socket.on('newMessage', (messageData) {
      _logger.i('New message received: $messageData');
      // Handle the received message (e.g., update UI)
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      _logger.i('Disconnected from server');
    });
  }

  // Send a message to the server
  void sendMessage(String user, String content) {
    final messageData = {
      'user': user,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Log the message data before sending
    _logger.i('Sending message: $messageData');

    _socket.emit('sendMessage', messageData);
  }

  // Close the socket connection
  void closeConnection() {
    _socket.disconnect();
  }

  // ChatSocketService.dart
  void onNewMessage(Function(Map<String, dynamic>) callback) {
    _socket.on('newMessage', (messageData) {
      _logger.i('New message received: $messageData');
      callback(messageData); // Call the provided callback with the new message
    });
  }
}
