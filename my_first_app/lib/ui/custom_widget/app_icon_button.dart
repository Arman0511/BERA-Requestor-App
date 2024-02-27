import 'package:flutter/material.dart';

import '../constants/App_color.dart';

typedef OnClick = Function();

class AppIconButton extends StatelessWidget {
  const AppIconButton(
      {super.key, required this.onClick, required this.icon, this.size});

  final OnClick onClick;
  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onClick,
      child: AbsorbPointer(
        child: Icon(size: size, color: AppColor.secondaryBackgroundColor, icon),
      ),
    );
  }
}
