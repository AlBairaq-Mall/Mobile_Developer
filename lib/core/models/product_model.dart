import '../utils/json_parser.dart';

class ProductModel {
  final String id;
  final String itemCode;
  final String categoryId;
  final String name;
  final String description;
  final String image;
  final double price;
  final double? oldPrice;
  final String unit;
  final String package;
  final String? label;
  final bool isFavorite;
  final bool isAvailable;
  final String brand;
  final bool isRecommended;
  final bool isFlashDeal;
  final bool isBestSeller;

  const ProductModel({
    required this.id,
    required this.itemCode,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.oldPrice,
    required this.unit,
    required this.package,
    this.label,
    this.isFavorite = false,
    this.isAvailable = true,
    required this.brand,
    required this.isRecommended,
    required this.isFlashDeal,
    required this.isBestSeller,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: JsonParser.string(json['id']),
        itemCode: JsonParser.string(json['item_code']),
        categoryId: JsonParser.string(json['category_id']),
        name: JsonParser.string(json['name']),
        description: JsonParser.string(json['description']),
        image: JsonParser.string(json['image']),
        price: JsonParser.doubleValue(json['price']),
        oldPrice: json['old_price'] != null
            ? JsonParser.doubleValue(json['old_price'])
            : null,
        unit: JsonParser.string(json['unit']),
        package: JsonParser.string(json['package']),
        label: json['label']?.toString(),
        isFavorite: JsonParser.boolValue(json['is_favorite']),
        isAvailable: JsonParser.boolValue(json['is_available'], fallback: true),
        brand: JsonParser.string(json['brand']),
        isRecommended: JsonParser.boolValue(json['is_recommended']),
        isFlashDeal: JsonParser.boolValue(json['is_flash_deal']),
        isBestSeller: JsonParser.boolValue(json['is_best_seller']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'item_code': itemCode,
        'category_id': categoryId,
        'name': name,
        'description': description,
        'image': image,
        'price': price,
        'old_price': oldPrice,
        'unit': unit,
        'package': package,
        'label': label,
        'is_favorite': isFavorite,
        'is_available': isAvailable,
        'brand': brand,
        'is_recommended': isRecommended,
        'is_flash_deal': isFlashDeal,
        'is_best_seller': isBestSeller,
      };

  ProductModel copyWith({
    String? id,
    String? itemCode,
    String? categoryId,
    String? name,
    String? description,
    String? image,
    double? price,
    double? oldPrice,
    String? unit,
    String? package,
    String? label,
    bool? isFavorite,
    bool? isAvailable,
    String? brand,
    bool? isRecommended,
    bool? isFlashDeal,
    bool? isBestSeller,
  }) =>
      ProductModel(
        id: id ?? this.id,
        itemCode: itemCode ?? this.itemCode,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        oldPrice: oldPrice ?? this.oldPrice,
        unit: unit ?? this.unit,
        package: package ?? this.package,
        label: label ?? this.label,
        isFavorite: isFavorite ?? this.isFavorite,
        isAvailable: isAvailable ?? this.isAvailable,
        brand: brand ?? this.brand,
        isRecommended: isRecommended ?? this.isRecommended,
        isFlashDeal: isFlashDeal ?? this.isFlashDeal,
        isBestSeller: isBestSeller ?? this.isBestSeller,
      );
}
