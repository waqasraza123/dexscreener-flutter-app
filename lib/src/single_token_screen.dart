import 'package:flutter/material.dart';
import './chat/token_messages_screen.dart';

class SingleTokenScreen extends StatelessWidget {
  final dynamic token;

  const SingleTokenScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(token['token']['tokenSymbol']?.toUpperCase() ?? 'Token'),
        actions: [
          // Message icon button
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // Navigate to the MessagesPage when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TokenMessagesScreen(token: token),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display token details
            Text(
              '${token['token']['tokenSymbol']?.toUpperCase()} / ${token['token']['chainSymbol']?.toUpperCase()}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${token['price'] ?? '0'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Split the 24h Change into two Text widgets
            Row(
              children: [
                const Text(
                  '24h Change: ',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '${token['24h'] ?? '0'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: (double.tryParse(token['24h'] ?? '0') ?? 0) >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Liquidity: ${token['liquidity'] ?? '0'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Volume: ${token['volume'] ?? '0'}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Market Cap: ${token['mcap']?.toString() ?? '0'}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
