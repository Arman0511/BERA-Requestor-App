import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:my_first_app/ui/constants/app_png.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.name, this.imagePath});

  final String name;
  final String? imagePath;

  ImageProvider getImage() {
    if (imagePath == null) return const AssetImage(AppPng.AppAvatarPath);
    return NetworkImage(imagePath!);
  }

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
              backgroundImage: getImage(),
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
                name,
                style: TextStyle(
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
