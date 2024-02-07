import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({
    super.key,
    required this.body,
  });
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: body,
        ),
      ),
    );
  }
}
