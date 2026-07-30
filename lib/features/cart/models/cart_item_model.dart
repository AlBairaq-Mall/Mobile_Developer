import '../../../core/models/product_model.dart';
import '../../../core/utils/json_parser.dart';
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      selectedUnit: ProductUnitModel.fromJson(json['selected_unit']),
      unitPrice: JsonParser.doubleValue(json['unit_price']),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'selected_unit': selectedUnit.toJson(),
        'unit_price': unitPrice,
        'quantity': quantity,
      };

  double get totalPrice => unitPrice * quantity;
}
