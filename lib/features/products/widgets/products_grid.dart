import 'package:flutter/material.dart';

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
    return GridView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
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
