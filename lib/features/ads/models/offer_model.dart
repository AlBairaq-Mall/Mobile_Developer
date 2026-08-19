import '../../../core/utils/json_parser.dart';

// ══════════════════════════════════════════════════════════════════════════════
// OfferGiftModel
// ══════════════════════════════════════════════════════════════════════════════

class OfferGiftModel {
  final String productUnitId;
  final String productId;
  final String productNameAr;
  final String productNameEn;
  final String unitId;
  final String unitNameAr;
  final String unitNameEn;
  final int unitQuantity;
  final int quantity;

  const OfferGiftModel({
    required this.productUnitId,
    required this.productId,
    required this.productNameAr,
    required this.productNameEn,
    required this.unitId,
    required this.unitNameAr,
    required this.unitNameEn,
    required this.unitQuantity,
    required this.quantity,
  });

  String get productName =>
      JsonParser.currentLanguage == 'ar' ? productNameAr : productNameEn;

  String get unitName =>
      JsonParser.currentLanguage == 'ar' ? unitNameAr : unitNameEn;

  factory OfferGiftModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map? ?? {};
    final unit = json['unit'] as Map? ?? {};

    return OfferGiftModel(
      productUnitId: JsonParser.string(json['product_unit_id']),
      productId: JsonParser.string(product['id']),
      productNameAr: JsonParser.string(product['name_ar']),
      productNameEn: JsonParser.string(product['name_en']),
      unitId: JsonParser.string(unit['id']),
      unitNameAr: JsonParser.string(unit['name_ar']),
      unitNameEn: JsonParser.string(unit['name_en']),
      unitQuantity: JsonParser.intValue(unit['quantity']),
      quantity: JsonParser.intValue(json['quantity']),
    );
  }
}

class OfferCartLine {
  final String productId;
  final String unitId;
  final int quantity;

  const OfferCartLine({
    required this.productId,
    required this.unitId,
    required this.quantity,
  });
}

class GiftRewardModel {
  final String offerId;
  final OfferGiftModel gift;
  final int quantity;

  const GiftRewardModel({
    required this.offerId,
    required this.gift,
    required this.quantity,
  });
}

// ══════════════════════════════════════════════════════════════════════════════
// OfferProductUnitModel
// ══════════════════════════════════════════════════════════════════════════════

class OfferProductUnitModel {
  final String id;
  final String productId;
  final String productNameAr;
  final String productNameEn;
  final String productImage;
  final String unitId;
  final String unitNameAr;
  final String unitNameEn;
  final int unitQuantity;
  final double oldPrice;
  final double price;

  const OfferProductUnitModel({
    required this.id,
    required this.productId,
    required this.productNameAr,
    required this.productNameEn,
    required this.productImage,
    required this.unitId,
    required this.unitNameAr,
    required this.unitNameEn,
    required this.unitQuantity,
    required this.oldPrice,
    required this.price,
  });

  String get productName =>
      JsonParser.currentLanguage == 'ar' ? productNameAr : productNameEn;

  String get unitName =>
      JsonParser.currentLanguage == 'ar' ? unitNameAr : unitNameEn;

  factory OfferProductUnitModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map? ?? {};
    final unit = json['unit'] as Map? ?? {};

    return OfferProductUnitModel(
      id: JsonParser.string(json['id']),
      productId: JsonParser.string(product['id']),
      productNameAr: JsonParser.string(product['name_ar']),
      productNameEn: JsonParser.string(product['name_en']),
      productImage: JsonParser.string(product['image']),
      unitId: JsonParser.string(unit['id']),
      unitNameAr: JsonParser.string(unit['name_ar']),
      unitNameEn: JsonParser.string(unit['name_en']),
      unitQuantity: JsonParser.intValue(unit['quantity']),
      oldPrice: JsonParser.doubleValue(json['old_price']),
      price: JsonParser.doubleValue(json['price']),
    );
  }

  bool get hasDiscount => oldPrice > price;
}

// ══════════════════════════════════════════════════════════════════════════════
// OfferModel
// ══════════════════════════════════════════════════════════════════════════════

class OfferModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String image;

  /// type: e.g. "percentage", "fixed", "buy_x_get_y"
  final String type;

  /// Discount amount or percentage. Gift offers do not require a value.
  final double? value;

  final List<OfferProductUnitModel> productUnits;

  /// buy_quantity: for buy-X-get-Y offers
  final int? buyQuantity;

  final OfferGiftModel? gift;

  final String? startDate;
  final String? endDate;

  final bool isActive;

  final String? createdAt;
  final String? updatedAt;

  const OfferModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    required this.type,
    this.value,
    required this.productUnits,
    this.buyQuantity,
    this.gift,
    this.startDate,
    this.endDate,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  String get title => JsonParser.currentLanguage == 'ar' ? titleAr : titleEn;

  String get description =>
      JsonParser.currentLanguage == 'ar' ? descriptionAr : descriptionEn;

  bool get isGift => type == 'gift';

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final giftRaw = json['gift'];
    OfferGiftModel? gift;
    if (giftRaw is Map) {
      final giftJson = Map<String, dynamic>.from(giftRaw);
      giftJson['quantity'] ??= json['gift_quantity'];
      gift = OfferGiftModel.fromJson(giftJson);
    }

    return OfferModel(
      id: JsonParser.string(json['id']),
      titleAr: JsonParser.string(json['title_ar']),
      titleEn: JsonParser.string(json['title_en']),
      descriptionAr: JsonParser.string(json['description_ar']),
      descriptionEn: JsonParser.string(json['description_en']),
      image: JsonParser.string(json['image']),
      type: JsonParser.string(json['type']),
      value:
          json['value'] == null ? null : JsonParser.doubleValue(json['value']),
      productUnits: JsonParser.list(
        json['product_units'],
        OfferProductUnitModel.fromJson,
      ),
      buyQuantity: json['buy_quantity'] != null
          ? JsonParser.intValue(json['buy_quantity'])
          : null,
      gift: gift,
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      isActive: JsonParser.boolValue(json['is_active']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
