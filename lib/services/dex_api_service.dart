import 'dart:convert';
import 'package:http/http.dart' as http;

class DexApiService {
  static const String baseUrl = 'http://localhost:9000/api';

  Future<List<dynamic>> fetchDexData() async {
    final response = await http.get(Uri.parse('$baseUrl/dex/tokens'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
