import 'package:flutter/material.dart';
import '../../../utils/amount_converter.dart';
import '../../../utils/time_converter.dart';

class TransferCard extends StatelessWidget {
  final dynamic transfer;
  final Color cardColor;

  const TransferCard(
      {super.key, required this.transfer, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      child: ListTile(
        title: Text(
          'From: ${transfer['from']} To: ${transfer['to']}',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ${formatAmount(transfer['change_amount'])}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Signature: ${transfer['signature']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              'Time: ${formatTime(transfer['time'])}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
