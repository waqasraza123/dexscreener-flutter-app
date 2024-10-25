import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../utils/button.dart';
import '../../../utils/colors.dart';

class LoginForm extends StatefulWidget {
  final AuthService authService;

  const LoginForm({
    required this.authService,
    super.key,
  });

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _otpEmail;
  bool _isOtpMode = false;
  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      await widget.authService.loginUser(_email!, _password!);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithOtp(BuildContext context) async {
    if (_otpEmail != null && _otpEmail!.isNotEmpty) {
      setState(() => _isLoading = true);
      await widget.authService.loginWithEmailOTP(_otpEmail!);
      setState(() => _isLoading = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  void _toggleOtpMode() {
    setState(() => _isOtpMode = !_isOtpMode);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isOtpMode
            ? _buildOtpForm() // Display OTP Form
            : _buildLoginForm(), // Display Regular Login Form
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('LoginForm'),
      children: [
        TextFormField(
          decoration:
              _buildInputDecoration('Email Address', Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
          onSaved: (value) => _email = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: _buildInputDecoration('Password', Icons.lock_outline),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          onSaved: (value) => _password = value,
        ),
        const SizedBox(height: 32),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Button(
                text: 'Login',
                onPressed: () => _login(context),
              ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _toggleOtpMode,
          child: const Text(
            'Login with Email OTP',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            'Don\'t have an account? Register here.',
            style: TextStyle(
              color: deepBlue,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      key: const ValueKey('OtpForm'),
      children: [
        TextFormField(
          decoration:
              _buildInputDecoration('Email for OTP', Icons.email_outlined),
          onChanged: (value) => _otpEmail = value,
        ),
        const SizedBox(height: 16),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Button(
                text: 'Send OTP',
                onPressed: () => _loginWithOtp(context),
              ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _toggleOtpMode,
          child: const Text(
            'Back to Login',
            style: TextStyle(color: customBlack),
          ),
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
