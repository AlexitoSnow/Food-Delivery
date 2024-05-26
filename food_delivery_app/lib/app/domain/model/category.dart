// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Category {
  Icecream,
  Pizza,
  Salad,
  Burger,
}

extension Icon on Category {
  IconData get icon {
    switch (this) {
      case Category.Icecream:
        return Icons.icecream_outlined;
      case Category.Pizza:
        return Icons.local_pizza_outlined;
      case Category.Salad:
        return Icons.food_bank;
      case Category.Burger:
        return Icons.fastfood_outlined;
    }
  }
}