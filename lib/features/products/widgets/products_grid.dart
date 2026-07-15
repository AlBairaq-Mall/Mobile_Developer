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
      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: products.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),

      itemBuilder: (_, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
