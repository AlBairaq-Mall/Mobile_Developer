import '../../../core/models/product_model.dart';
import '../../products/models/product_unit_model.dart';

class CartItemModel {
  final ProductModel product;
  final ProductUnitModel selectedUnit;
  final double unitPrice;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.selectedUnit,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;
}
