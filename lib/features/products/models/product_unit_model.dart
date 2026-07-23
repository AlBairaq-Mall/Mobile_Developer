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
      json['name_${JsonParser.currentLanguage}'],
    );

    return ProductUnitModel(
      id: JsonParser.string(json['id']),
      itemCode: '',
      unitName: unitName,
      price: JsonParser.doubleValue(json['price']),
      package: JsonParser.string(json['quantity']),
      description: '',
      unit: unitName,
      label: null,
      oldPrice: null,
      isDefault: false,
    );
  }
}
