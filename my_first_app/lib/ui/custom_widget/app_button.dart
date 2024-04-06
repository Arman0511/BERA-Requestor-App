import '../common/ui_helpers.dart';
import '../constants/App_color.dart';
import 'package:flutter/material.dart';

typedef OnClick = Function();

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onClick,
    required bool isSelected,
  });

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
          textAlign: TextAlign.center,
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
