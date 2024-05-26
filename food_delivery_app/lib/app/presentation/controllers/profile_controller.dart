import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/app/data/sources/database.dart';
import 'package:food_delivery_app/app/data/sources/shared_pref.dart';
import 'package:food_delivery_app/app/domain/model/user.dart';

class ProfileController extends ChangeNotifier {
  final database = Database();

  Future<User> getUser() async {
    return await SharedPref.getUser();
  }

  void updateImage(User user, String path) async {
    final image = File(path);
    final downloadUrl = await Database().updateUserProfile(user.id, image);
    user.image = downloadUrl;
    await SharedPref.saveUser(user);
    await database.updateUserInfo(user.id, user.toJson());
  }
}
