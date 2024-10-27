import 'package:magic_sdk/magic_sdk.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  final Logger logger = Logger();

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? uid = prefs.getString('uid');
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    // Check if all necessary fields are available
    if (uid != null) {
      _user = User(
        email: email!,
        uid: uid,
        displayName: null,
        accessToken: accessToken!,
        refreshToken: refreshToken,
      );
      notifyListeners();
    }
  }

  void setUser(User user) {
    _user = user;

    SharedPreferences.getInstance().then((prefs) {
      // Save user details in SharedPreferences
      prefs.setString('email', user.email);
      prefs.setString('uid', user.uid);
      prefs.setString('accessToken', user.accessToken);
      if (user.refreshToken != null) {
        prefs.setString('refreshToken', user.refreshToken!);
      }

      notifyListeners();
    });
  }

  Future<void> logoutUser() async {
    try {
      await Magic.instance.user.logout();
    } catch (e) {
      logger.i("failed to logout");
    }

    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('uid');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    notifyListeners();
  }
}
