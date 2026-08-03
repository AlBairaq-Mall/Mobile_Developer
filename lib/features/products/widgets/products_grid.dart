import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/models/product_model.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.lg,
      crossAxisSpacing: AppSpacing.md,
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.sm,
          ),
          child: ProductCard(
            product: products[index],
          ),
        );
      },
    );
  }
}
