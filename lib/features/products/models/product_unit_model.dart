// import '../../../core/utils/json_parser.dart';

// class ProductUnitModel {
//   final String id;
//   final String itemCode;
//   final String unitName;
//   final double price;
//   final String package;
//   final String description;
//   final String unit;
//   final String? label;
//   final double? oldPrice;
//   final bool isDefault;

//   const ProductUnitModel({
//     required this.id,
//     required this.itemCode,
//     required this.unitName,
//     required this.price,
//     required this.package,
//     required this.description,
//     required this.unit,
//     this.label,
//     this.oldPrice,
//     required this.isDefault,
//   });

//   String get displayName => unitName;

//   factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
//     final unitName = JsonParser.string(
//       json['unit_name'] ??
//           json['name_ar'] ??
//           json['name_en'] ??
//           json['name_${JsonParser.currentLanguage}'],
//     );

//     return ProductUnitModel(
//       id: JsonParser.string(json['id']),
//       itemCode: JsonParser.string(json['item_code'] ?? ''),
//       unitName: unitName,
//       price: JsonParser.doubleValue(json['price']),
//       package: JsonParser.string(json['quantity'] ?? json['package'] ?? ''),
//       description: JsonParser.string(json['description'] ?? ''),
//       unit: JsonParser.string(json['unit'] ?? unitName),
//       label: json['label'],
//       oldPrice: JsonParser.doubleValue(json['old_price']),
//       isDefault: JsonParser.boolValue(json['is_default'] ?? false),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'item_code': itemCode,
//         'unit_name': unitName,
//         'price': price,
//         'package': package,
//         'description': description,
//         'unit': unit,
//         'label': label,
//         'old_price': oldPrice,
//         'is_default': isDefault,
//       };
// }

import '../../../core/utils/json_parser.dart';

class ProductUnitModel {
  final String id;

  final String nameAr;
  final String nameEn;

  /// اسم الوحدة المستخدم حاليًا في التطبيق.
  final String unitName;

  final int quantity;
  final double price;

  // Legacy compatibility
  final String itemCode;
  final String package;
  final String unit;
  final String description;
  final String? label;
  final double? oldPrice;
  final bool isDefault;

  const ProductUnitModel({
    required this.id,

    // New API fields
    this.nameAr = '',
    this.nameEn = '',
    required this.unitName,
    this.quantity = 0,
    required this.price,

    // Existing app fields
    this.itemCode = '',
    this.package = '',
    this.unit = '',
    this.description = '',
    this.label,
    this.oldPrice,
    this.isDefault = false,
  });

  String get displayName => unitName;

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    final nameAr = JsonParser.string(json['name_ar']);

    final nameEn = JsonParser.string(json['name_en']);

    final currentLanguage = JsonParser.currentLanguage;

    final unitName = JsonParser.string(
      currentLanguage == 'ar'
          ? (json['name_ar'] ?? json['name_en'])
          : (json['name_en'] ?? json['name_ar']),
    );

    final quantity = JsonParser.intValue(json['quantity']);

    return ProductUnitModel(
      id: JsonParser.string(json['id']),
      nameAr: nameAr,
      nameEn: nameEn,
      unitName: unitName,
      quantity: quantity,
      price: JsonParser.doubleValue(json['price']),
      itemCode: JsonParser.string(json['item_code'] ?? ''),
      package: JsonParser.string(json['package'] ?? json['quantity'] ?? ''),
      unit: unitName,
      description: JsonParser.string(json['description'] ?? ''),
      label: json['label']?.toString(),
      oldPrice: json['old_price'] != null
          ? JsonParser.doubleValue(json['old_price'])
          : null,
      isDefault: JsonParser.boolValue(json['is_default'] ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'quantity': quantity,
      'price': price,
      'item_code': itemCode,
      'package': package,
      'unit': unit,
      'description': description,
      'label': label,
      'old_price': oldPrice,
      'is_default': isDefault,
    };
  }

  @override
  String toString() {
    return 'ProductUnitModel('
        'id: $id, '
        'unitName: $unitName, '
        'quantity: $quantity, '
        'price: $price'
        ')';
  }
}
