import 'package:flutter/material.dart';

class ProductCardContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ProductCardContainer({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xffEEF1F4), width: .8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .035),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
