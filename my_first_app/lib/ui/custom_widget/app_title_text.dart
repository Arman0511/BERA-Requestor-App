import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  const AppTitleText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(239, 7, 166, 187),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(80),
          bottomLeft: Radius.circular(80),
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
                wordSpacing: 5),
          ),
          const SizedBox(
            height: 35,
          )
        ],
      ),
    );
  }
}
