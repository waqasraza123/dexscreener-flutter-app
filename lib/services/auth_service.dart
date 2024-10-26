import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

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
    Logger logger = Logger();
    final loginUrl = Uri.parse('$apiBaseURL/auth/login');

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
        // Extract the user data from the response
        final userData = data['user'];
        logger.i(userData);

        return {
          'success': true,
          'message': 'Login successful.',
          'data': userData,
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed.',
        };
      }
    } catch (e) {
      logger.e('An error occurred during login: $e');
      return {
        'success': false,
        'message': 'An error occurred. $e',
      };
    }
  }
}
