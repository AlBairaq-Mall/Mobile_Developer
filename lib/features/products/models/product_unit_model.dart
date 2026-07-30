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

  String get displayName => unitName;

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    final unitName = JsonParser.string(
      json['unit_name'] ?? json['name_ar'] ?? json['name_en'] ?? json['name_${JsonParser.currentLanguage}'],
    );

    return ProductUnitModel(
      id: JsonParser.string(json['id']),
      itemCode: JsonParser.string(json['item_code'] ?? ''),
      unitName: unitName,
      price: JsonParser.doubleValue(json['price']),
      package: JsonParser.string(json['quantity'] ?? json['package'] ?? ''),
      description: JsonParser.string(json['description'] ?? ''),
      unit: JsonParser.string(json['unit'] ?? unitName),
      label: json['label'],
      oldPrice: JsonParser.doubleValue(json['old_price']),
      isDefault: JsonParser.boolValue(json['is_default'] ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_code': itemCode,
        'unit_name': unitName,
        'price': price,
        'package': package,
        'description': description,
        'unit': unit,
        'label': label,
        'old_price': oldPrice,
        'is_default': isDefault,
      };
}
