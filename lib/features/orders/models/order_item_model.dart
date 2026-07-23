import '../../../core/models/product_model.dart';
import '../../../core/utils/json_parser.dart';
import '../../products/models/product_unit_model.dart';

class OrderItemModel {
  final String id;
  final ProductModel product;
  final ProductUnitModel unit;
  final int quantity;
  final double price;
  final double total;

  const OrderItemModel({
    required this.id,
    required this.product,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OrderItemModel(
      id: JsonParser.string(json["id"]),
      product: ProductModel.fromJson(
        json["product"] ?? {},
      ),
      unit: ProductUnitModel.fromJson(
        json["unit"] ?? {},
      ),
      quantity: JsonParser.intValue(
        json["quantity"],
      ),
      price: JsonParser.doubleValue(
        json["price"],
      ),
      total: JsonParser.doubleValue(
        json["total"],
      ),
    );
  }
}
