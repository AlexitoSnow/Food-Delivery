import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle headlineTextFieldStyle() {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightTextFieldStyle() {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle semiBoldTextFieldStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontFamily: 'Poppins',
    );
  }
}
