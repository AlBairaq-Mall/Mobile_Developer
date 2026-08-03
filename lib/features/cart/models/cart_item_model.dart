import '../../../core/models/product_model.dart';
import '../../../core/utils/json_parser.dart';
import '../../products/models/product_unit_model.dart';

class CartItemModel {
  final ProductModel product;
  final String? cartId;
  final ProductUnitModel selectedUnit;
  final double price;
  final double total;
  final double unitPrice;
  final int quantity;

  const CartItemModel({
    this.cartId,
    required this.product,
    required this.selectedUnit,
    required this.price,
    required this.total,
    required this.unitPrice,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      selectedUnit: ProductUnitModel.fromJson(json['unit']),
      unitPrice: JsonParser.doubleValue(json['unit_price']),
      quantity: json['quantity'] as int? ?? 1,
      cartId: json['id']?.toString(),
      price: JsonParser.doubleValue(json['price']),
      total: JsonParser.doubleValue(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'unit': selectedUnit.toJson(),
        'unit_price': unitPrice,
        'quantity': quantity,
        'id': cartId,
        'price': price,
        'total': total,
      };
  CartItemModel copyWith({
    String? cartId,
    ProductModel? product,
    ProductUnitModel? selectedUnit,
    double? price,
    double? total,
    double? unitPrice,
    int? quantity,
  }) {
    return CartItemModel(
      cartId: cartId ?? this.cartId,
      product: product ?? this.product,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      price: price ?? this.price,
      total: total ?? this.total,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice {
    if (total > 0) {
      return total;
    }

    return unitPrice * quantity;
  }
}
