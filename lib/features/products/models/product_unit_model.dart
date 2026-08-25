import '../../../core/utils/json_parser.dart';

class ProductUnitModel {
  final String id;

  final String nameAr;
  final String nameEn;

  final int quantity;
  final double price;

  final int soldQuantityLast2Days;
  final int buyersCountLast2Days;

  const ProductUnitModel({
    required this.id,
    this.nameAr = '',
    this.nameEn = '',
    this.quantity = 0,
    required this.price,
    this.soldQuantityLast2Days = 0,
    this.buyersCountLast2Days = 0,
  });

  /// اسم الوحدة حسب اللغة الحالية.
  String get unitName {
    return JsonParser.currentLanguage == 'ar' ? nameAr : nameEn;
  }

  factory ProductUnitModel.fromJson(Map<String, dynamic> json) {
    return ProductUnitModel(
      id: JsonParser.string(json['id']),
      nameAr: JsonParser.string(json['name_ar']),
      nameEn: JsonParser.string(json['name_en']),
      quantity: JsonParser.intValue(json['quantity']),
      price: JsonParser.doubleValue(json['price']),
      soldQuantityLast2Days: JsonParser.intValue(
        json['sold_quantity_last_2_days'],
      ),
      buyersCountLast2Days: JsonParser.intValue(
        json['buyers_count_last_2_days'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'quantity': quantity,
      'price': price,
      'sold_quantity_last_2_days': soldQuantityLast2Days,
      'buyers_count_last_2_days': buyersCountLast2Days,
    };
  }

  @override
  String toString() {
    return 'ProductUnitModel('
        'id: $id, '
        'unitName: $unitName, '
        'quantity: $quantity, '
        'price: $price, '
        'soldQuantityLast2Days: $soldQuantityLast2Days, '
        'buyersCountLast2Days: $buyersCountLast2Days'
        ')';
  }
}
