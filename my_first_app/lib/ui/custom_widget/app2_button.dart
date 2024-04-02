import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

typedef OnClick = Function();

class App2Button extends StatelessWidget {
  const App2Button(
      {super.key,
      required this.text,
      required this.onClick,
      required this.isSelected});

  final String text;
  final OnClick onClick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
          foregroundColor: Colors.white,
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 242, 165, 11)
              : const Color.fromARGB(255, 43, 0, 255), // Change the text color
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Round the corners
            side: BorderSide(color: Colors.black, width: 2), // Add a border
          ),
          elevation: 5, // Add elevation for a raised effect
        ),
        child: Text(
          text,
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
