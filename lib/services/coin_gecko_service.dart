import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinGeckoService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<List<dynamic>> fetchTokens() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/gecko/coins-list-with-market-data'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tokens');
      }
    } catch (e) {
      throw Exception('Error fetching tokens: $e');
    }
  }
}
