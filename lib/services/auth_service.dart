import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:magic_sdk/magic_sdk.dart';
import '../utils/magic_link_init.dart';

class AuthService {
  final String apiBaseURL = dotenv.env['API_BASE_URL'] ?? '';

  Future<Map<String, dynamic>> register(String email, String password) async {
    final registerUrl = Uri.parse('$apiBaseURL/auth/register');

    try {
      final response = await http.post(
        registerUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Registration successful',
          'data': jsonDecode(response.body),
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final loginUrl = Uri.parse('$apiBaseURL/auth/login');
    final Logger logger = Logger();

    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Login successful.',
          'data': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. $e',
      };
    }
  }

  // method for login with email OTP
  Future<Map<String, dynamic>> loginWithEmailOTP(String email) async {
    Logger logger = Logger();
    logger.i("coming here");
    logger.i(MagicLinkInit.magic);
    //try {

    final aa = await MagicLinkInit.magic.auth.loginWithEmailOTP(email: email);

    logger.i(aa);
    return {
      'success': true,
      'message': 'OTP sent to your email. Please check your inbox.',
    };
    // } catch (e) {
    //   return {
    //     'success': false,
    //     'message': 'An error occurred: $e',
    //   };
    // }
  }
}
