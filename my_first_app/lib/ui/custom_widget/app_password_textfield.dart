import 'package:my_first_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class AppPasswordTextField extends StatefulWidget {
  AppPasswordTextField(
      {super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;
  bool isObscure = true;

  @override
  State<AppPasswordTextField> createState() => _GamePasswordTextFieldState();
}

class _GamePasswordTextFieldState extends State<AppPasswordTextField> {
  void onClick() {
    setState(() {
      widget.isObscure = !widget.isObscure;
    });
  }

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
            keyboardType: TextInputType.visiblePassword,
            controller: widget.controller,
            obscureText: widget.isObscure,
            decoration: InputDecoration(
              fillColor: AppColor.primaryBackgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: Color(0xFF78746D),
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(Icons.lock,
                  color: const Color.fromARGB(255, 32, 202, 217)),
              suffixIcon: IconButton(
                onPressed: onClick,
                icon: Transform.scale(
                  scale: 1,
                  child: Icon(
                    widget.isObscure == true
                        ? Icons.remove_red_eye
                        : Icons.visibility_off,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
