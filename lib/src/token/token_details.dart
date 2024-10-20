// lib/widgets/token_card/token_details.dart

import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class TokenDetails extends StatelessWidget {
  final dynamic token;

  const TokenDetails({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          token['token']['dexLogoUrl'] ?? '',
          height: 20,
          width: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 20);
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            token['token']['tokenName'] ?? 'Unknown',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildStat('LIQ', token['liquidity'] ?? '0'),
        const SizedBox(width: 8),
        _buildStat('VOL', token['volume'] ?? '0'),
        const SizedBox(width: 8),
        _buildStat('MCAP', token['mcap']?.toString() ?? '0'),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 10, color: customBlack)),
        ],
      ),
    );
  }
}
