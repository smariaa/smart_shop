import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> register(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_username', username);
    await prefs.setString('registered_email', email);
    await prefs.setString('registered_password', password);
  }

  Future<void> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsername = prefs.getString('registered_username');
    final registeredPassword = prefs.getString('registered_password');
    final registeredEmail = prefs.getString('registered_email');

    if (username == registeredUsername && password == registeredPassword) {
      _user = User(username: username, email: registeredEmail ?? '$username@example.com');
      _isLoggedIn = true;

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', _user!.username);
      await prefs.setString('email', _user!.email);

      notifyListeners();
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Do not clear registered user

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!loggedIn) return;

    final username = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';

    if (username.isNotEmpty && email.isNotEmpty) {
      _user = User(username: username, email: email);
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}
