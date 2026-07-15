import '../../../core/models/product_model.dart';

class CartItemModel {
  final ProductModel product;

  final String unit;

  final double unitPrice;

  final int quantity;

  const CartItemModel({
    required this.product,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice {
    return unitPrice * quantity;
  }
}
