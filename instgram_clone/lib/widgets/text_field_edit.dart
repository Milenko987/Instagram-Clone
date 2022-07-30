import 'package:flutter/material.dart';

class TextFieldEdit extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  bool isPassword;
  final TextInputType keyboardType;
  TextFieldEdit(
      {Key? key,
      required this.controller,
      required this.text,
      required this.keyboardType,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
        ),
        hintText: text,
        contentPadding: const EdgeInsets.all(8),
        filled: true,
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }
}
