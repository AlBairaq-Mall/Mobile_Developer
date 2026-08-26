import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/design_system/components/app_icon.dart';

class HomeSearchBar extends StatelessWidget {
  final bool enableHero;

  /// عند readOnly=true يعمل مثل الصفحة الرئيسية
  final bool readOnly;

  /// عند false يصبح TextField حقيقي
  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final String hint;

  final bool autofocus;

  const HomeSearchBar({
    super.key,
    this.enableHero = true,
    this.readOnly = true,
    this.controller,
    this.onChanged,
    this.onTap,
    this.hint = "ابحث عن أي منتج...",
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .35),
        ),
        boxShadow: AppShadows.search,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        onTap: readOnly
            ? (onTap ??
                () {
                  context.push(AppRoutes.search);
                })
            : null,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 13,
          ),
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: AppIcon(
              Icons.search_rounded,
              size: AppIconSize.small,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );

    if (!enableHero) return child;

    return Hero(
      tag: "home_search",
      child: Material(color: Colors.transparent, child: child),
    );
  }
}
