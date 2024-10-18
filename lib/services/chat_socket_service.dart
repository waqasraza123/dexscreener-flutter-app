import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

class ChatSocketService {
  late IO.Socket _socket;
  final Logger _logger = Logger();
  bool _hasJoined = false; // Track if chat room has been joined

  void initializeSocket(String contractAddress) {
    const apiUrl =
        'http://localhost:9000'; // Replace with your actual server URL
    _socket = IO.io(apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listen for connection
    _socket.onConnect((_) {
      _logger.i('Connected to server');
      if (!_hasJoined) {
        joinChat(contractAddress);
        _hasJoined = true; // Set the flag to true after joining
      }
    });

    // Listen for new incoming messages
    _socket.on('receiveMessage', (messageData) {
      _logger.i('New message received: $messageData');
      // Handle the received message (e.g., update UI)
    });

    // Handle disconnection
    _socket.onDisconnect((_) {
      _logger.i('Disconnected from server');
      _hasJoined = false; // Reset the join flag when disconnected
    });
  }

  void joinChat(String contractAddress) {
    _logger.i('Joining chat for contract address: $contractAddress');
    _socket.emit('joinChat', {'contract_address': contractAddress});
  }

  void sendMessage(String user, String content, String contractAddress) {
    final messageData = {
      'user': user,
      'content': content,
      'contract_address': contractAddress,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _logger.i('Sending message: $messageData');
    _socket.emit('sendMessage', messageData);
  }

  void closeConnection() {
    _socket.disconnect();
  }

  // Callback for receiving new messages
  void onNewMessage(Function(dynamic) callback) {
    _socket.on('receiveMessage', callback);
  }
}
