import 'package:flutter/material.dart';
import '../single_token_screen.dart';
import 'token_header.dart';
import 'token_details.dart';

class TokenCard extends StatelessWidget {
  final dynamic token;

  const TokenCard({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleTokenScreen(token: token),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TokenHeader(token: token),
              const SizedBox(height: 8),
              TokenDetails(token: token),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
