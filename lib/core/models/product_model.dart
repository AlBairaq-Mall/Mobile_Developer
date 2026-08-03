import 'package:bhm_supermarket/features/products/models/product_unit_model.dart';

import '../utils/json_parser.dart';

class ProductModel {
  final String id;
  final String itemCode;
  final String categoryId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> images;
  final String categoryNameAr;
  final String categoryNameEn;
  final String barcode;

  /// السعر الافتراضي (أول وحدة)
  final double price;

  /// اسم الوحدة الافتراضية
  final String unit;

  /// كمية الوحدة الافتراضية
  final String package;

  /// جميع الوحدات
  final List<ProductUnitModel> units;

  final double? oldPrice;
  final String? label;
  final bool isFavorite;
  final String? favoriteId;
  final bool isAvailable;
  final String brand;
  final bool isRecommended;
  final bool isFlashDeal;
  final bool isBestSeller;

  const ProductModel({
    required this.id,
    required this.itemCode,
    required this.categoryId,
    required this.categoryNameAr,
    required this.categoryNameEn,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.images,
    required this.price,
    required this.unit,
    required this.barcode,
    required this.package,
    required this.units,
    this.oldPrice,
    this.label,
    this.isFavorite = false,
    this.favoriteId,
    this.isAvailable = true,
    required this.brand,
    required this.isRecommended,
    required this.isFlashDeal,
    required this.isBestSeller,
  });
  String get name => JsonParser.currentLanguage == 'ar' ? nameAr : nameEn;

  String get description =>
      JsonParser.currentLanguage == 'ar' ? descriptionAr : descriptionEn;

  String get categoryName =>
      JsonParser.currentLanguage == 'ar' ? categoryNameAr : categoryNameEn;

  String get image => images.isEmpty ? '' : images.first;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final units = JsonParser.list(
      json['units'],
      ProductUnitModel.fromJson,
    );

    final firstUnit = units.isNotEmpty ? units.first : null;

    final imageList = json['images'] as List?;
    final parsedImages = imageList?.map((e) {
          if (e is Map) {
            return JsonParser.string(e['image']);
          }
          return JsonParser.string(e);
        }).toList() ??
        <String>[];

    return ProductModel(
        units: units,
        barcode: JsonParser.string(json['barcode'] ?? ''),
        categoryNameAr: JsonParser.string(
            json['category']?['name_ar'] ?? json['category_name_ar'] ?? ''),
        categoryNameEn: JsonParser.string(
            json['category']?['name_en'] ?? json['category_name_en'] ?? ''),
        id: JsonParser.string(json['id']),
        itemCode: JsonParser.string(json['unique_number']),
        categoryId: JsonParser.string(
            json['category']?['id'] ?? json['category_id'] ?? ''),
        nameAr: JsonParser.string(json['name_ar']),
        nameEn: JsonParser.string(json['name_en']),
        descriptionAr: JsonParser.string(json['description_ar']),
        descriptionEn: JsonParser.string(json['description_en']),
        images: parsedImages,
        price: JsonParser.doubleValue(json['price'] ?? firstUnit?.price ?? 0),
        unit: JsonParser.string(json['unit'] ?? firstUnit?.unitName ?? ''),
        package: JsonParser.string(json['package'] ?? firstUnit?.package ?? ''),
        oldPrice: JsonParser.doubleValue(json['old_price']),
        label: json['label'],
        isFavorite: JsonParser.boolValue(json['is_favorite'] ?? false),
        favoriteId: json['favorite_id']?.toString(),
        isAvailable: JsonParser.boolValue(
            json['status'] ?? json['is_available'] ?? true),
        brand: JsonParser.string(
          json['brand'] ?? '',
        ),
        isRecommended: JsonParser.boolValue(json['is_recommended'] ?? false),
        isFlashDeal: JsonParser.boolValue(json['is_flash_deal'] ?? false),
        isBestSeller: JsonParser.boolValue(json['is_best_seller'] ?? false));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'unique_number': itemCode,
        'category_id': categoryId,
        'category_name_ar': categoryNameAr,
        'category_name_en': categoryNameEn,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_ar': descriptionAr,
        'description_en': descriptionEn,
        'images': images.map((e) => {'image': e}).toList(),
        'price': price,
        'old_price': oldPrice,
        'unit': unit,
        'package': package,
        'label': label,
        'is_favorite': isFavorite,
        'favorite_id': favoriteId,
        'is_available': isAvailable,
        'brand': brand,
        'is_recommended': isRecommended,
        'is_flash_deal': isFlashDeal,
        'is_best_seller': isBestSeller,
        'units': units.map((u) => u.toJson()).toList(),
      };

  ProductModel copyWith({
    String? id,
    String? itemCode,
    String? categoryId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    List<String>? images,
    double? price,
    double? oldPrice,
    String? unit,
    String? package,
    List<ProductUnitModel>? units,
    String? label,
    bool? isFavorite,
    String? favoriteId,
    bool? isAvailable,
    String? brand,
    bool? isRecommended,
    bool? isFlashDeal,
    bool? isBestSeller,
    String? barcode,
    String? categoryNameAr,
    String? categoryNameEn,
  }) {
    return ProductModel(
      barcode: barcode ?? this.barcode,
      categoryNameAr: categoryNameAr ?? this.categoryNameAr,
      categoryNameEn: categoryNameEn ?? this.categoryNameEn,
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      categoryId: categoryId ?? this.categoryId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      images: images ?? this.images,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      package: package ?? this.package,
      units: units ?? this.units,
      oldPrice: oldPrice ?? this.oldPrice,
      label: label ?? this.label,
      isFavorite: isFavorite ?? this.isFavorite,
      isAvailable: isAvailable ?? this.isAvailable,
      favoriteId: favoriteId ?? this.favoriteId,
      brand: brand ?? this.brand,
      isRecommended: isRecommended ?? this.isRecommended,
      isFlashDeal: isFlashDeal ?? this.isFlashDeal,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }
}
