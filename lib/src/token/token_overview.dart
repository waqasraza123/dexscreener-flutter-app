import 'package:flutter/material.dart';

class TokenOverview extends StatelessWidget {
  final dynamic token;

  const TokenOverview({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${token['token']['tokenSymbol']?.toUpperCase()} / ${token['token']['chainSymbol']?.toUpperCase()}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Price: ${token['price'] ?? '0'}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('24h Change: ', style: TextStyle(fontSize: 16)),
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
          Text('Liquidity: ${token['liquidity'] ?? '0'}',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Volume: ${token['volume'] ?? '0'}',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text('Market Cap: ${token['mcap']?.toString() ?? '0'}',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
