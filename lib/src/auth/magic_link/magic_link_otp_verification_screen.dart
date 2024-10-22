import 'package:flutter/material.dart';
import 'package:magic_sdk/magic_sdk.dart';
import '../../../utils/magic_link_init.dart';

class MagicLinkOtpVerificationScreen extends StatefulWidget {
  final String email;

  const MagicLinkOtpVerificationScreen({super.key, required this.email});

  @override
  MagicLinkOTPVerificationScreenState createState() =>
      MagicLinkOTPVerificationScreenState();
}

class MagicLinkOTPVerificationScreenState
    extends State<MagicLinkOtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _message = '';

  Future<void> _verifyOTP() async {
    final magic = MagicLinkInit.magic;
    try {
      // Here, we will use the Magic SDK to verify the OTP
      await magic.auth.loginWithEmailOTP(
        email: widget.email,
        //otp: _otpController.text,
      );

      // Successful login logic (e.g., navigate to the main screen)
      Navigator.pushReplacementNamed(
          context, '/'); // Change to your main screen route
    } catch (e) {
      setState(() {
        _message = 'OTP verification failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 16),
            Text(_message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
