import '../../../core/utils/json_parser.dart';

class ProductUnitModel {
  final String id;
  final String itemCode;
  final String unitName;
  final double price;
  final String package;
  final String description;
  final String unit;
  final String? label;
  final double? oldPrice;
  final bool isDefault;

  const ProductUnitModel({
    required this.id,
    required this.itemCode,
    required this.unitName,
    required this.price,
    required this.package,
    required this.description,
    required this.unit,
    this.label,
    this.oldPrice,
    required this.isDefault,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) =>
      ProductUnitModel(
        id: JsonParser.string(json['id']),
        itemCode: JsonParser.string(json['item_code']),
        unitName: JsonParser.string(json['unit_name']),
        price: JsonParser.doubleValue(json['price']),
        package: JsonParser.string(json['package']),
        description: JsonParser.string(json['description']),
        unit: JsonParser.string(json['unit']),
        label: json['label']?.toString(),
        oldPrice: json['old_price'] != null
            ? JsonParser.doubleValue(json['old_price'])
            : null,
        isDefault: JsonParser.boolValue(json['is_default']),
      );
}
