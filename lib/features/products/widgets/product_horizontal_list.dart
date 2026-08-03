import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import 'products_grid.dart';

class ProductHorizontalList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductHorizontalList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ProductsGrid(
      products: products,
    );
  }
}
