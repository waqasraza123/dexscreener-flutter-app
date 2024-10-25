import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../utils/button.dart';

class LoginForm extends StatefulWidget {
  final AuthService authService;
  final bool isLoading;
  final VoidCallback onToggleMode;

  const LoginForm({
    required this.authService,
    required this.isLoading,
    required this.onToggleMode,
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form state before login
      // Call the login method from AuthService
      await widget.authService.loginUser(_email!, _password!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
          widget.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Button(
                  text: 'Login',
                  onPressed: () => _login(context),
                ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.onToggleMode,
            child: const Text('Login with Email OTP'),
          ),
        ],
      ),
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
