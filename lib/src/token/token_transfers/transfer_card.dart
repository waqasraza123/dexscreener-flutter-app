import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return Animate(
      effects: [
        FadeEffect(duration: 500.ms), // Fade in effect
        ScaleEffect(delay: 300.ms), // Scale effect after fade
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8), // Margin between cards
        height: 250, // Increased height to reduce overflow
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Spacing between rows
              Row(
                children: [
                  const Icon(Icons.arrow_forward,
                      color: Colors.white), // Arrow icon for transfer direction
                  const SizedBox(width: 8), // Spacing between icons
                  Expanded(
                    child: Text(
                      'To: ${transfer['to']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Spacing between rows
              Row(
                children: [
                  const Icon(Icons.swap_horiz,
                      color: Colors.white), // Icon for "Amount"
                  const SizedBox(width: 8), // Spacing between icon and text
                  Expanded(
                    child: Text(
                      'Amount: ${formatAmount(transfer['change_amount'])}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "monospace",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Spacing between rows
              Row(
                children: [
                  const Icon(Icons.file_copy,
                      color: Colors.white), // Icon for "Signature"
                  const SizedBox(width: 8), // Spacing between icon and text
                  Expanded(
                    child: Text(
                      'Signature: ${transfer['signature']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: "monospace",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Spacing between rows
              Row(
                children: [
                  const Icon(Icons.access_time,
                      color: Colors.white), // Icon for "Time"
                  const SizedBox(width: 8), // Spacing between icon and text
                  Expanded(
                    child: Text(
                      'Time: ${formatTime(transfer['time'])}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: "monospace",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
