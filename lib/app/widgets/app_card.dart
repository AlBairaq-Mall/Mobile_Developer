import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: padding ?? const EdgeInsets.all(14),
            child: child,
          ),
        ),
      ),
    );
  }
}
