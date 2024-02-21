import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(50)),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(AppPng.AppAvatarPath),
              backgroundColor: AppColor.secondaryColor,
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Armando',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 14,
                  wordSpacing: 3,
                ),
              ),
              Text(
                'Responder',
                style: TextStyle(
                  color: AppColor.secondaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 14,
                  wordSpacing: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
