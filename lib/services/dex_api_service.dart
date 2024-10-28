import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DexApiService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Map<String, dynamic>> fetchDexData(int limit, int offset) async {
    final response = await http
        .get(Uri.parse('$baseUrl/dex/tokens?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
