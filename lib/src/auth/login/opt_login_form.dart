import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../utils/button.dart';

class OtpForm extends StatefulWidget {
  final AuthService authService;
  bool isLoading;
  final VoidCallback onToggleMode;

  OtpForm({
    required this.authService,
    required this.isLoading,
    required this.onToggleMode,
  });

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String? _otpEmail;

  Future<void> _loginWithOtp(BuildContext context) async {
    if (_otpEmail != null && _otpEmail!.isNotEmpty) {
      setState(() {
        widget.isLoading = true;
      });
      // Call OTP login from AuthService
      await widget.authService.loginWithEmailOTP(_otpEmail!);
      setState(() {
        widget.isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration:
              _buildInputDecoration('Email for OTP', Icons.email_outlined),
          onChanged: (value) => _otpEmail = value,
        ),
        const SizedBox(height: 16),
        widget.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Button(
                text: 'Send OTP',
                onPressed: () => _loginWithOtp(context),
              ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onToggleMode,
          child: const Text('Back to Login'),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
    );
  }
}
