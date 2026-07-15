import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final Widget? prefixIcon;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      textAlign: textAlign,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
