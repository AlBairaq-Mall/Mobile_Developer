import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SecondaryButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onTap, child: Text(title));
  }
}
