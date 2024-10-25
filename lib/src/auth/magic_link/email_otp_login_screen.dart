import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:magic_sdk/magic_sdk.dart';

class MagicLinkEmailOTPLoginScreen extends StatefulWidget {
  const MagicLinkEmailOTPLoginScreen({super.key});

  @override
  MagicLinkEmailOTPLoginScreenState createState() =>
      MagicLinkEmailOTPLoginScreenState();
}

class MagicLinkEmailOTPLoginScreenState
    extends State<MagicLinkEmailOTPLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';

  Future<void> _loginWithEmailOTP() async {
    Logger logger = Logger();

    try {
      var magic = Magic.instance;
      await magic.auth.loginWithEmailOTP(email: _emailController.text);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Email OTP'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loginWithEmailOTP,
              child: const Text('Send OTP'),
            ),
            const SizedBox(height: 16),
            Text(_message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
