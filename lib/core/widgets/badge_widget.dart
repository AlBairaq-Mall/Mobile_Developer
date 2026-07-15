import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String text;

  const BadgeWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
