import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// ```
class AppBackButton extends StatelessWidget {
  /// مسار الرجوع الاحتياطي عندما لا يمكن pop.
  final String? fallbackRoute;

  /// Callback مخصص — يتجاوز السلوك الافتراضي.
  final VoidCallback? onPressed;

  /// لون الأيقونة.
  final Color? iconColor;

  /// لون خلفية الزر.
  final Color? backgroundColor;

  /// أيقونة مخصصة.
  final IconData? icon;

  const AppBackButton({
    super.key,
    this.fallbackRoute,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.icon,
  });

  void _handleBack(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
      return;
    }
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else if (fallbackRoute != null) {
      context.go(fallbackRoute!);
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final resolvedIcon = icon ??
        (isRtl
            ? Icons.arrow_forward_ios_rounded
            : Icons.arrow_back_ios_rounded);
    final resolvedIconColor =
        iconColor ?? IconTheme.of(context).color ?? AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleBack(context),
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                resolvedIcon,
                size: 20,
                color: resolvedIconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// نسخة دائرية مُعتِمة للاستخدام فوق صور أو تدرجات لونية.
class AppBackButtonOverlay extends StatelessWidget {
  final String? fallbackRoute;
  final VoidCallback? onPressed;
  final Color iconColor;
  final IconData icon;

  const AppBackButtonOverlay({
    super.key,
    this.fallbackRoute,
    this.onPressed,
    this.iconColor = AppColors.textPrimary,
    this.icon = Icons.close_rounded,
  });

  void _handleBack(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
      return;
    }
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else if (fallbackRoute != null) {
      context.go(fallbackRoute!);
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, top: 8),
      child: GestureDetector(
        onTap: () => _handleBack(context),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
