import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(
    {required OutlineInputBorder inputBorder, required String hintText}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    border: inputBorder,
    focusedBorder: inputBorder,
    enabledBorder: inputBorder,
  );
}
