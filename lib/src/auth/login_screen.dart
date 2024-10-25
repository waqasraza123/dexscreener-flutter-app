import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/colors.dart';
import './login/login_form.dart';
import 'login/opt_login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isOtpMode = false; // Toggle for showing the OTP email input

  // Toggle between regular login and OTP mode
  void _toggleOtpMode() {
    setState(() {
      _isOtpMode = !_isOtpMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: deepBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Conditionally show either Login or OTP form
              _isOtpMode
                  ? OtpForm(
                      authService: _authService,
                      isLoading: _isLoading,
                      onToggleMode: _toggleOtpMode,
                    )
                  : LoginForm(
                      authService: _authService,
                      isLoading: _isLoading,
                      onToggleMode: _toggleOtpMode,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
