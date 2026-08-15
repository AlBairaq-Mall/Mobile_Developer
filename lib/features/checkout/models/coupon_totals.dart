/// Coupon calculations for Checkout.
///
/// The backend supplies the actual coupon discount through `/coupons/check`.
/// This helper only keeps that value safe for the current paid-products
/// subtotal; it does not recalculate percentage or fixed rates.
class CouponTotals {
  CouponTotals._();

  static bool isCouponCurrent({
    required double? appliedSubtotal,
    required double currentSubtotal,
  }) {
    if (appliedSubtotal == null) return false;
    return (appliedSubtotal - currentSubtotal).abs() < 0.000001;
  }

  static double effectiveCouponDiscount({
    required double apiDiscountAmount,
    required double currentSubtotal,
    required double? appliedSubtotal,
  }) {
    if (!isCouponCurrent(
      appliedSubtotal: appliedSubtotal,
      currentSubtotal: currentSubtotal,
    )) {
      return 0;
    }

    return apiDiscountAmount.clamp(0, currentSubtotal).toDouble();
  }

  static double grandTotal({
    required double subtotal,
    required double deliveryFee,
    required double couponDiscount,
  }) {
    return (subtotal - couponDiscount).clamp(0, double.infinity).toDouble() +
        deliveryFee;
  }
}
