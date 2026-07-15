import 'package:flutter/material.dart';

import '../../../app/widgets/app_section.dart';
import '../../../core/models/product_model.dart';
import '../../products/widgets/product_horizontal_list.dart';

// Fix: was using '../../../../core/' (wrong - 4 levels) → corrected to '../../../core/' (3 levels)
class ProductSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: title,
      child: ProductHorizontalList(products: products),
    );
  }
}
