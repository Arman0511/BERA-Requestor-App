import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 83, 252, 235),
      Color.fromARGB(255, 39, 192, 253),
      Color.fromARGB(255, 16, 146, 253),
    ],
  );

  static const primaryColor = Color(0xFFD94720);
  static const secondaryColor = Color(0xFF505050);

  static const primaryBackgroundColor = Color(0xF0F1F0F0);
  static const secondaryBackgroundColor = Color(0xF0BB0707);
}
