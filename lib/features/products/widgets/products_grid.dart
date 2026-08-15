import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductsGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .67,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
