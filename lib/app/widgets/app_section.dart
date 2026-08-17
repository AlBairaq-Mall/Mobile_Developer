import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onSeeAll;

  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          //   child: SectionHeader(title: title, onSeeAll: onSeeAll),
          // ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
