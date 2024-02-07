import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

typedef OnClick = Function();

class App2Button extends StatelessWidget {
  const App2Button({super.key, required this.text, required this.onClick});

  final String text;
  final OnClick onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: AppColor.primaryGradient,
          boxShadow: [
            primaryShadow(),
          ]),
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
