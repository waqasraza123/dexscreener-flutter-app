import 'package:magic_sdk/magic_sdk.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? uid = prefs.getString('uid');
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    // Check if all necessary fields are available
    if (email != null &&
        uid != null &&
        accessToken != null &&
        refreshToken != null) {
      _user = User(
        email: email,
        uid: uid,
        displayName:
            null, // You can adjust this if you have a way to store/display names
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      notifyListeners();
    }
  }

  void setUser(User user) {
    _user = user;
    final Logger logger = Logger();

    SharedPreferences.getInstance().then((prefs) {
      // Log the user email for debugging
      logger.i(user);

      // Save user details in SharedPreferences
      prefs.setString('email', user.email);
      prefs.setString('uid', user.uid);
      prefs.setString('accessToken', user.accessToken);
      prefs.setString('refreshToken', user.refreshToken);

      notifyListeners();
    });
  }

  Future<void> logoutUser() async {
    await Magic.instance.user.logout();

    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('uid');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    notifyListeners();
  }
}
