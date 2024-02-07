import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

typedef OnClick = Function();

class AppTextButton extends StatelessWidget {
  const AppTextButton({super.key, required this.title, required this.onClick});

  final String title;
  final OnClick onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      child: Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 32, 202, 217),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          wordSpacing: 4,
        ),
      ),
    );
  }
}
