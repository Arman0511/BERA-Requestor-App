import '../constants/app_color.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.label = "Loading"});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LinearProgressIndicator(
              color: AppColor.primaryColor,
              backgroundColor: AppColor.secondaryColor,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2,
                wordSpacing: 2,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
