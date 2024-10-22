import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:magic_sdk/magic_sdk.dart';

class MagicLinkInit {
  static late final Magic _magic;

  static void init() {
    final String magicAPIKey = dotenv.env['MAGIC_LINK_PUBLISHABLE_KEY'] ?? '';
    if (magicAPIKey.isEmpty) {
      throw Exception('Magic API key is missing. Check your .env file.');
    }
    _magic = Magic(magicAPIKey);
  }

  static Magic get magic {
    return _magic;
  }
}
