import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/helpers/constants.dart';
import '../../data/sources/database.dart';
import '../../data/sources/shared_pref.dart';

class HomeController extends ChangeNotifier {
  String? _categorySelected = categories.keys.first;
  Stream<QuerySnapshot>? foodItems;
  final database = Database();

  String? get categorySelected => _categorySelected;

  set categorySelected(String? value) {
    _categorySelected = value;
    getFoodItems();
    notifyListeners();
  }

  Future<String> getUserName() async {
    final user = await SharedPref.getUser();
    return user.name;
  }

  Future<void> getFoodItems() async {
    foodItems = await database.getFoodItems(categorySelected!);
    notifyListeners();
  }
}
