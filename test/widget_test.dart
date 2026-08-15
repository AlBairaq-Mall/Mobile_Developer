import 'package:bhm_supermarket/core/network/api_response.dart';
import 'package:bhm_supermarket/features/checkout/models/coupon_totals.dart';
import 'package:bhm_supermarket/features/ads/domain/repositories/offers_repository.dart';
import 'package:bhm_supermarket/features/ads/models/offer_model.dart';
import 'package:bhm_supermarket/features/ads/providers/offers_provider.dart';
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
        'product': {'id': 1, 'name_en': 'Pepsi', 'name_ar': 'Pepsi'},
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
      'product': {'id': 2, 'name_en': 'Juice', 'name_ar': 'Juice'},
      'unit': {'id': 1, 'name_en': 'Piece', 'name_ar': 'Piece', 'quantity': 1},
    },
    'gift_quantity': 1,
    'is_active': true,
  });

  test('gift offer parses a nullable value and top-level gift quantity', () {
    expect(giftOffer.value, isNull);
    expect(giftOffer.gift?.productNameEn, 'Juice');
    expect(giftOffer.gift?.quantity, 1);
  });

  test('gift count follows floor(purchased / buy) × gift quantity', () async {
    final provider = OffersProvider(_FakeOffersRepository([giftOffer]));
    await provider.load();

    List<GiftRewardModel> rewardsFor(int quantity) => provider.giftRewardsFor([
      OfferCartLine(productId: '1', unitId: '1', quantity: quantity),
    ]);

    expect(rewardsFor(1), isEmpty);
    expect(rewardsFor(2).single.quantity, 1);
    expect(rewardsFor(4).single.quantity, 2);
    expect(rewardsFor(5).single.quantity, 2);
  });

  test('gift offer matches both product and unit', () async {
    final provider = OffersProvider(_FakeOffersRepository([giftOffer]));
    await provider.load();

    expect(
      provider.giftRewardsFor([
        const OfferCartLine(productId: '1', unitId: '99', quantity: 2),
      ]),
      isEmpty,
    );
  });

  test('percentage coupon applies only to paid products before delivery', () {
    const subtotal = 10000.0;
    const delivery = 500.0;
    const apiDiscount = 2500.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: apiDiscount,
      currentSubtotal: subtotal,
      appliedSubtotal: subtotal,
    );
    final total = CouponTotals.grandTotal(
      subtotal: subtotal,
      deliveryFee: delivery,
      couponDiscount: discount,
    );

    expect(discount, 2500);
    expect(total, 8000);
  });

  test('fixed coupon uses the API amount once', () {
    const subtotal = 10000.0;
    const delivery = 500.0;
    const apiDiscount = 1000.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: apiDiscount,
      currentSubtotal: subtotal,
      appliedSubtotal: subtotal,
    );

    expect(
      CouponTotals.grandTotal(
        subtotal: subtotal,
        deliveryFee: delivery,
        couponDiscount: discount,
      ),
      9500,
    );
  });

  test('a free gift does not change the coupon calculation base', () {
    const paidProductsSubtotal = 10000.0;
    const delivery = 500.0;

    final discount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: 2500,
      currentSubtotal: paidProductsSubtotal,
      appliedSubtotal: paidProductsSubtotal,
    );

    expect(
      CouponTotals.grandTotal(
        subtotal: paidProductsSubtotal,
        deliveryFee: delivery,
        couponDiscount: discount,
      ),
      8000,
    );
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

  test('coupon discount is subtracted once', () {
    expect(
      CouponTotals.grandTotal(
        subtotal: 10000,
        deliveryFee: 0,
        couponDiscount: 2500,
      ),
      7500,
    );
  });
}

class _FakeOffersRepository implements OffersRepository {
  final List<OfferModel> offers;

  _FakeOffersRepository(this.offers);

  @override
  Future<ApiResponse<List<OfferModel>>> getOffers() async =>
      ApiResponse.success(offers);

  @override
  Future<ApiResponse<OfferModel>> getOfferById(String id) async =>
      ApiResponse.success(offers.firstWhere((offer) => offer.id == id));
}
