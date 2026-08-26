import 'package:bhm_supermarket/core/models/product_model.dart';
import 'package:bhm_supermarket/core/network/api_response.dart';
import 'package:bhm_supermarket/core/pagination/pagination_meta.dart';
import 'package:bhm_supermarket/features/checkout/models/coupon_totals.dart';
import 'package:bhm_supermarket/features/ads/domain/repositories/offers_repository.dart';
import 'package:bhm_supermarket/features/ads/models/offer_model.dart';
import 'package:bhm_supermarket/features/ads/providers/offers_provider.dart';
import 'package:bhm_supermarket/features/products/domain/repositories/product_repository.dart';
import 'package:bhm_supermarket/features/products/models/product_unit_model.dart';
import 'package:bhm_supermarket/features/scanner/providers/barcode_scanner_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final giftOffer = OfferModel.fromJson({
    'id': 2,
    'title_en': 'Buy 2 Get 1 Free',
    'title_ar': 'Buy 2 Get 1 Free',
    'type': 'gift',
    'value': null,
    'product_units': [
      {
        'id': 11,
        'product': {
          'id': 1,
          'name_en': 'Pepsi',
          'name_ar': 'Pepsi',
        },
        'unit': {
          'id': 1,
          'name_en': 'Piece',
          'name_ar': 'Piece',
          'quantity': 1,
        },
        'old_price': 3500,
        'price': 3500,
      },
    ],
    'buy_quantity': 2,
    'gift': {
      'product': {
        'id': 2,
        'name_en': 'Juice',
        'name_ar': 'Juice',
      },
      'unit': {
        'id': 1,
        'name_en': 'Piece',
        'name_ar': 'Piece',
        'quantity': 1,
      },
    },
    'gift_quantity': 1,
    'is_active': true,
  });

  test('gift offer parses a nullable value and top-level gift quantity', () {
    expect(giftOffer.value, isNull);
    expect(giftOffer.gift?.productNameEn, 'Juice');
    expect(giftOffer.gift?.quantity, 1);
  });

  test(
    'gift count follows floor(purchased / buy) × gift quantity',
    () async {
      final provider = OffersProvider(
        _FakeOffersRepository([giftOffer]),
      );

      await provider.load();

      List<GiftRewardModel> rewardsFor(int quantity) {
        return provider.giftRewardsFor([
          OfferCartLine(
            productId: '1',
            unitId: '1',
            quantity: quantity,
          ),
        ]);
      }

      expect(rewardsFor(1), isEmpty);
      expect(rewardsFor(2).single.quantity, 1);
      expect(rewardsFor(4).single.quantity, 2);
      expect(rewardsFor(5).single.quantity, 2);
    },
  );

  test('gift offer matches both product and unit', () async {
    final provider = OffersProvider(
      _FakeOffersRepository([giftOffer]),
    );

    await provider.load();

    expect(
      provider.giftRewardsFor([
        const OfferCartLine(
          productId: '1',
          unitId: '99',
          quantity: 2,
        ),
      ]),
      isEmpty,
    );
  });

  test('coupon discount uses the API amount without recalculation', () {
    const subtotal = 10000.0;
    const apiDiscount = 2500.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: apiDiscount,
      currentSubtotal: subtotal,
      appliedSubtotal: subtotal,
    );

    expect(discount, 2500);
  });

  test('fixed coupon uses the API amount once', () {
    const subtotal = 10000.0;
    const apiDiscount = 1000.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: apiDiscount,
      currentSubtotal: subtotal,
      appliedSubtotal: subtotal,
    );

    expect(discount, 1000);
  });

  test('a free gift does not change the coupon calculation base', () {
    const paidProductsSubtotal = 10000.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: 2500,
      currentSubtotal: paidProductsSubtotal,
      appliedSubtotal: paidProductsSubtotal,
    );

    expect(discount, 2500);
  });

  test('coupon discount cannot exceed the paid-products subtotal', () {
    expect(
      CouponTotals.effectiveCouponDiscount(
        apiDiscountAmount: 1500,
        currentSubtotal: 1000,
        appliedSubtotal: 1000,
      ),
      1000,
    );
  });

  test('coupon is not reused after the cart subtotal changes', () {
    expect(
      CouponTotals.effectiveCouponDiscount(
        apiDiscountAmount: 2500,
        currentSubtotal: 5000,
        appliedSubtotal: 10000,
      ),
      0,
    );
  });

  test('coupon discount is zero when no coupon was applied', () {
    expect(
      CouponTotals.effectiveCouponDiscount(
        apiDiscountAmount: 2500,
        currentSubtotal: 10000,
        appliedSubtotal: null,
      ),
      0,
    );
  });

  test('coupon discount is zero when API returns zero', () {
    expect(
      CouponTotals.effectiveCouponDiscount(
        apiDiscountAmount: 0,
        currentSubtotal: 10000,
        appliedSubtotal: 10000,
      ),
      0,
    );
  });

  group('BarcodeScannerProvider Tests', () {
    final sampleProduct = ProductModel(
      id: '10',
      uniqueNumber: 'PROD-9988',
      categoryId: '1',
      categoryNameAr: 'ألبان',
      categoryNameEn: 'Dairy',
      nameAr: 'حليب المراعي',
      nameEn: 'Almarai Milk',
      descriptionAr: 'حليب طازج',
      descriptionEn: 'Fresh milk',
      images: const ['milk.png'],
      price: 1500,
      barcode: '6281003301234',
      units: const [
        ProductUnitModel(
          id: '101',
          nameAr: 'حبة 1 لتر',
          nameEn: '1 Liter Piece',
          price: 1500,
          originalPrice: 1500,
          quantity: 1,
        ),
        ProductUnitModel(
          id: '102',
          nameAr: 'كرتون 12 حبة',
          nameEn: 'Carton 12 Pieces',
          price: 16000,
          originalPrice: 18000,
          discount: 2000,
          finalPrice: 16000,
          quantity: 12,
        ),
      ],
    );

    test('lookupBarcode finds product and sets found state', () async {
      final fakeRepo = _FakeProductRepository([sampleProduct]);
      final provider = BarcodeScannerProvider(fakeRepo);

      final result = await provider.lookupBarcode('6281003301234');

      expect(result, isNotNull);
      expect(result?.uniqueNumber, 'PROD-9988');
      expect(provider.state, ScannerState.found);
      expect(provider.scannedProduct?.nameAr, 'حليب المراعي');
      expect(provider.scannedProduct?.units.length, 2);
    });

    test('lookupBarcode with non-existent barcode sets notFound state', () async {
      final fakeRepo = _FakeProductRepository([sampleProduct]);
      final provider = BarcodeScannerProvider(fakeRepo);

      final result = await provider.lookupBarcode('0000000000000');

      expect(result, isNull);
      expect(provider.state, ScannerState.notFound);
      expect(provider.errorMessage, contains('لم يتم العثور على أي منتج'));
    });

    test('lookupBarcode with empty barcode sets error state', () async {
      final fakeRepo = _FakeProductRepository([sampleProduct]);
      final provider = BarcodeScannerProvider(fakeRepo);

      final result = await provider.lookupBarcode('   ');

      expect(result, isNull);
      expect(provider.state, ScannerState.error);
      expect(provider.errorMessage, contains('يرجى إدخال'));
    });
  });
}

class _FakeProductRepository implements ProductRepository {
  final List<ProductModel> products;

  _FakeProductRepository(this.products);

  @override
  Future<ApiResponse<PaginatedResult<List<ProductModel>>>> getProducts({
    String? categoryId,
    String? search,
    int page = 1,
    bool? isBestSeller,
    bool? isFlashDeal,
    bool? isRecommended,
  }) async {
    if (search != null && search.isNotEmpty) {
      final filtered = products.where((p) {
        return p.barcode.contains(search) ||
            p.uniqueNumber.contains(search) ||
            p.nameAr.contains(search);
      }).toList();

      return ApiResponse.success(
        PaginatedResult(
          items: filtered,
          meta: PaginationMeta(
            currentPage: 1,
            lastPage: 1,
            total: filtered.length,
            perPage: 10,
            from: filtered.isNotEmpty ? 1 : 0,
            to: filtered.length,
            hasNext: false,
            hasPrevious: false,
          ),
        ),
      );
    }

    return ApiResponse.success(
      PaginatedResult(
        items: products,
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          total: products.length,
          perPage: 10,
          from: products.isNotEmpty ? 1 : 0,
          to: products.length,
          hasNext: false,
          hasPrevious: false,
        ),
      ),
    );
  }

  @override
  Future<ApiResponse<ProductModel>> getProductById(String id) async {
    final product = products.firstWhere((p) => p.id == id);
    return ApiResponse.success(product);
  }
}

class _FakeOffersRepository implements OffersRepository {
  final List<OfferModel> offers;

  _FakeOffersRepository(this.offers);

  @override
  Future<ApiResponse<List<OfferModel>>> getOffers() async {
    return ApiResponse.success(offers);
  }

  @override
  Future<ApiResponse<OfferModel>> getOfferById(String id) async {
    return ApiResponse.success(
      offers.firstWhere((offer) => offer.id == id),
    );
  }
}
