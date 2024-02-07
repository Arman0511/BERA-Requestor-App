import 'package:my_first_app/ui/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/ui/common/ui_helpers.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key, required this.controller, required this.label, this.icon});

  final TextEditingController controller;
  final String label;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                primaryShadow(),
              ]),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: controller,
            decoration: InputDecoration(
              fillColor: AppColor.primaryBackgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: label,
              labelStyle: const TextStyle(
                color: Color(0xFF78746D),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: icon == null
                  ? Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 32, 202, 217),
                    )
                  : icon,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
