import 'package:flutter/material.dart';
import 'package:my_first_app/ui/constants/app_color.dart';

typedef OnClick = Function();

class DialogBar extends StatelessWidget {
  const DialogBar({super.key, required this.onClick, required this.title});

  final OnClick onClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppColor.secondaryBackgroundColor,
                wordSpacing: 2,
                letterSpacing: 1,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: onClick,
            iconSize: 30,
            color: AppColor.primaryColor,
            icon: Icon(Icons.backspace),
          ),
        ],
      ),
    );
  }
}
