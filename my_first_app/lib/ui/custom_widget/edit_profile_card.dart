import 'package:flutter/material.dart';

typedef OnClick = Function();

class EditProfileCard extends StatelessWidget {
  const EditProfileCard(
      {super.key,
      required this.text,
      required this.onClick,
      required this.label});

  final String text;
  final String label;
  final OnClick onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: 240,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 45,
            color: Colors.orange,
            onPressed: onClick,
            icon: Icon(
              Icons.edit,
            ),
          )
        ],
      ),
    );
  }
}
