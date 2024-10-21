import 'package:flutter/material.dart';
import '../../../utils/amount_converter.dart';
import '../../../utils/time_converter.dart';

class TransferCard extends StatelessWidget {
  final dynamic transfer;

  const TransferCard({
    super.key,
    required this.transfer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), // Margin between cards
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16), // Adjusted padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7A6BC5), // Less vibrant color
            Color(0xFF6B5CBA), // Less vibrant color
            Color(0xFF4B5CBA), // Less vibrant color
            Color(0xFFAB8D47), // Less vibrant color
          ],
        ),
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: SingleChildScrollView(
        // Add scroll view
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person,
                    color: Colors.white), // Icon for "From"
                const SizedBox(width: 8), // Spacing between icon and text
                Expanded(
                  child: Text(
                    'From: ${transfer['from']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "monospace",
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    color: Colors.white), // Arrow icon for transfer direction
                const SizedBox(width: 8), // Spacing between icons
                Expanded(
                  child: Text(
                    'To: ${transfer['to']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "monospace",
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Amount: ${formatAmount(transfer['change_amount'])}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: "monospace",
              ),
            ),
            Text(
              'Signature: ${transfer['signature']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: "monospace",
              ),
            ),
            Text(
              'Time: ${formatTime(transfer['time'])}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: "monospace",
              ),
            ),
            const SizedBox(height: 8), // Spacing between content and bottom
          ],
        ),
      ),
    );
  }
}
