import 'package:flutter/material.dart';

// Fix: removed circular import to product_section.dart
// (section_header → product_section → app_section → section_header)

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text("عرض الكل")),
      ],
    );
  }
}
