import 'package:magic_sdk/magic_sdk.dart';

import '../utils/magic_link_init.dart';

class MagicAuthService {
  final Magic _magic;

  MagicAuthService() : _magic = MagicLinkInit.magic;

  Future<void> loginWithEmailOTP(String email) async {
    await _magic.auth.loginWithEmailOTP(email: email);
  }

  Future<dynamic> getUser() async {
    return await _magic.user.getInfo();
  }

  Future<void> logout() async {
    await _magic.user.logout();
  }
}
