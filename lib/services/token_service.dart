import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TokenService {
  final String baseUrl = '${dotenv.env['API_BASE_URL']}/dex/tokens/token/';

  // Method to fetch token holders with pagination support
  Future<Map<String, dynamic>> fetchTokenHolders(
      String contractAddress, int limit, int offset) async {
    final String url =
        '$baseUrl$contractAddress/holders?limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load token holders');
    }
  }

  // Method to fetch token transfers with pagination support
  Future<Map<String, dynamic>> fetchTokenTransfers(
      String contractAddress, int limit, int offset) async {
    final String url =
        '$baseUrl$contractAddress/transfers?limit=$limit&offset=$offset';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load token transfers');
    }
  }

  // Method to fetch a single token's data
  Future<dynamic> fetchTokenData(String contractAddress) async {
    final String url = '$baseUrl$contractAddress';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load token data');
    }
  }
}
