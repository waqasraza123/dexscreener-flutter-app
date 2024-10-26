import 'package:flutter/material.dart';

class TokenHeader extends StatelessWidget {
  final dynamic token;

  const TokenHeader({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    String percentageString = token['24h'] ?? '0';
    double? percentage = double.tryParse(percentageString.replaceAll('%', ''));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.network(
            token['token']['tokenImageUrl'] ?? '',
            height: 20,
            width: 20,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 20);
            },
          ),
        ),
        const SizedBox(width: 8),
        _buildTokenSymbol(),
        const Spacer(),
        const SizedBox(width: 16),
        Text(
          token['price']?.toString() ?? '0',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        const Text('24h ', style: TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          percentageString,
          style: TextStyle(
              fontSize: 12,
              color: (percentage ?? 0) >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTokenSymbol() {
    final tokenSymbol =
        token['token']['tokenSymbol']?.toUpperCase() ?? 'UNKNOWN';
    return Row(
      children: [
        Text(
          tokenSymbol.length > 5
              ? '${tokenSymbol.substring(0, 5)}...'
              : tokenSymbol,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 4),
        const Text('/',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(
          token['token']['chainSymbol']?.toUpperCase() ?? 'UNKNOWN',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
