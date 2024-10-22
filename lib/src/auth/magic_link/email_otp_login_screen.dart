import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import 'magic_link_otp_verification_screen.dart';

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
    final authService = AuthService();
    final response = await authService.loginWithEmailOTP(_emailController.text);

    if (response['success']) {
      // Navigate to the OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MagicLinkOtpVerificationScreen(email: _emailController.text),
        ),
      );
    } else {
      setState(() {
        _message = response['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with Email OTP')),
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
