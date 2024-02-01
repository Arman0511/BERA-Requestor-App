import 'package:flutter/material.dart';

typedef OnClick = Function();

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.title,
    required this.onClick,
    required Container child,
  }) : super(key: key);

  final String title;
  final OnClick onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE35629),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class AppButton2 extends StatelessWidget {
  AppButton2({
    Key? key,
    required this.title,
    required this.onClick,
    this.isSelected = false,

  }) : super(key: key);

  final String title;
  final OnClick onClick;
  
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color.fromARGB(255, 224, 158, 2) : const Color.fromARGB(255, 41, 47, 227),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
