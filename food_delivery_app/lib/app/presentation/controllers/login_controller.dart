import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/routes/app_screens.dart';
import '../../data/sources/database.dart';
import '../../data/sources/shared_pref.dart';

class LoginController extends ChangeNotifier {
  String email = '';
  String password = '';
  bool _isVisible = false;
  final database = Database();

  bool get isVisible => _isVisible;

  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void onEmailChanged(String value) {
    email = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    password = value;
    notifyListeners();
  }

  Future<String?> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = await database.getUser(email);
      SharedPref.saveUser(user);
      AppScreens.appRouter().pushReplacementNamed(AppRoutes.home);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return 'No user found for that email';
      } else if (error.code == 'invalid-credential') {
        return 'Invalid email or password';
      }
    }
    return null;
  }
}
