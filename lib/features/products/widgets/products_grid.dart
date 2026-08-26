import 'package:bhm_supermarket/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../../../core/design_system/patterns/app_responsive.dart';
import '../../../core/models/product_model.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ProductsGrid({
    super.key,
    required this.products,
    this.controller,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppAdaptiveGrid(
      // Intentional Component Dimension: 150.0 width to preserve 2 columns on mobile
      minItemWidth: 150.0,
      // Figma visual intent spacing for dense layout
      spacing: AppSpacing.sm, // 8.0
      runSpacing: AppSpacing.md, // 12.0
      // Intentional Aspect Ratio to accommodate ProductCard content
      childAspectRatio: 0.62,
      itemCount: products.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      controller: controller,
      // 10.0 horizontal to maintain exact C3 density and prevent double-margin
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: AppSpacing.md,
      ),
      itemBuilder: (_, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
