import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import 'product_card.dart';

class ProductHorizontalList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductHorizontalList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          return SizedBox(
            width: 180,
            child: ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}
