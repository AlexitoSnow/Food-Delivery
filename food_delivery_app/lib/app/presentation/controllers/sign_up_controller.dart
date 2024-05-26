import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseException;
import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/routes/app_screens.dart';
import 'package:food_delivery_app/app/data/sources/database.dart';
import 'package:uuid/v4.dart';

import '../../data/sources/shared_pref.dart';
import '../../domain/model/user.dart';

class SignUpController extends ChangeNotifier {
  String name = '';
  String email = '';
  String password = '';
  bool _isVisible = false;
  final database = Database();

  bool get isVisible => _isVisible;

  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  void onNameChanged(String value) {
    name = value;
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

  Future<String?> signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = User(
        id: const UuidV4().generate(),
        name: name,
        email: email,
        wallet: 0,
      );
      await database.registerUser(user.toJson());
      await SharedPref.saveUser(user);
      AppScreens.appRouter().goNamed(AppRoutes.home);
      return 'Registered successful';
    } on FirebaseException catch (error) {
      if (error.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (error.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      }
    }
    return null;
  }
}
