import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    super.key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    this.obscureText = false,
    required this.validator,
    required this.textInputAction,
    required this.focusNode,
  });

  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
      ),
      validator: validator,
    );
  }
}
