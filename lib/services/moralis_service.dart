import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoralisService {
  final String apiBaseURL = dotenv.env['API_BASE_URL'] ?? '';

  // fetch NFTs
  Future<List<dynamic>> fetchNFTData() async {
    final response =
        await http.get(Uri.parse('$apiBaseURL/web3/moralis/nfts/multiple'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load NFT data');
    }
  }
}
