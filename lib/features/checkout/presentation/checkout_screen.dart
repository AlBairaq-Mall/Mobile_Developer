import 'package:bhm_supermarket/app/router/app_routes.dart';
import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:bhm_supermarket/features/orders/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../coupons/providers/coupon_provider.dart';
import '../../ads/models/offer_model.dart';
import '../../ads/providers/offers_provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_message.dart';
import '../../address/providers/address_provider.dart';
import '../../address/widgets/address_card.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../models/coupon_totals.dart';
import '../widgets/payment_method_selector.dart';
import '../models/payment_method.dart';
import '../../orders/utils/payment_mapper.dart';
import '../../../app/di/dependency_injection.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _couponController = TextEditingController();
  double _discountAmount = 0;
  double? _couponSubtotal;
  String? _appliedCouponCode;
  bool _couponLoading = false;
  bool _isPlacing = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim().toUpperCase();

    if (code.isEmpty) {
      AppMessage.warning(context, 'أدخل كود الكوبون أولاً');
      return;
    }

    final cart = context.read<CartProvider>();
    final couponProvider = context.read<CouponProvider>();

    setState(() {
      _couponLoading = true;
    });

    final result = await couponProvider.checkCoupon(
      code: code,
      orderAmount: cart.subtotal,
    );

    if (!mounted) return;

    setState(() {
      _couponLoading = false;
    });

    if (result == null || !result.valid) {
      setState(() {
        _discountAmount = 0;
        _couponSubtotal = null;
        _appliedCouponCode = null;
      });

      AppMessage.error(
        context,
        result?.message ?? couponProvider.error ?? 'الكوبون غير صالح',
        title: 'كوبون غير صالح',
      );

      return;
    }

    final safeDiscount = result.discountAmount
        .clamp(0, cart.subtotal)
        .toDouble();

    setState(() {
      _discountAmount = safeDiscount;
      _couponSubtotal = cart.subtotal;
      _appliedCouponCode = code;
    });

    AppMessage.success(
      context,
      'تم تطبيق الكوبون، الخصم ${result.discountAmount.toStringAsFixed(0)} ر.ي',
      title: 'تم تطبيق الكوبون ✓',
    );
  }

  Future<void> _placeOrder() async {
    final addressProvider = context.read<AddressProvider>();
    final cart = context.read<CartProvider>();
    final checkout = context.read<CheckoutProvider>();
    final couponDiscount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: _discountAmount,
      currentSubtotal: cart.subtotal,
      appliedSubtotal: _couponSubtotal,
    );

    if (_appliedCouponCode != null &&
        !CouponTotals.isCouponCurrent(
          appliedSubtotal: _couponSubtotal,
          currentSubtotal: cart.subtotal,
        )) {
      AppMessage.warning(
        context,
        'تغيرت محتويات السلة، يرجى إعادة التحقق من الكوبون.',
        title: 'انتهت صلاحية الكوبون',
      );
      return;
    }

    if (addressProvider.selectedAddress == null) {
      final created = await context.push<bool>(
        AppRoutes.addresses,
        extra: true,
      );

      if (created == true) {
        await addressProvider.loadAddresses();
      }
      if (addressProvider.selectedAddress == null) {
        return;
      }
    }

    setState(() {
      _isPlacing = true;
    });

    try {
      final response = await DependencyInjection.orderRepository.createOrder(
        addressId: addressProvider.selectedAddress!.id,
        paymentMethod: paymentApiValue(checkout.paymentMethod),
        deliveryFee: cart.deliveryFee,
        discount: couponDiscount,
        notes: null,
        couponCode: _appliedCouponCode,
        items: cart.items.map((e) {
          return {
            "product_id": int.parse(e.product.id),
            "unit_id": int.parse(e.selectedUnit.id),
            "quantity": e.quantity,
          };
        }).toList(),
      );

      if (!mounted) return;

      if (!response.success) {
        AppMessage.error(
          context,
          response.message.isEmpty ? 'فشل إنشاء الطلب، حاول مرة أخرى' : response.message,
          title: 'فشل إرسال الطلب',
        );
        return;
      }

      cart.clear();

      try {
        await context.read<OrdersProvider>().refresh();
      } catch (_) {}

      if (!mounted) return;

      final orderNumber = response.data?["order_number"]?.toString() ?? "";

      context.go(AppRoutes.orderSuccess, extra: orderNumber);
    } catch (e) {
      if (!mounted) return;
      AppMessage.error(
        context,
        'حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى.',
        title: 'فشل إرسال الطلب',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final cart = context.watch<CartProvider>();
    final offers = context.watch<OffersProvider>();
    final giftRewards = offers.giftRewardsFor(
      cart.items.map(
        (item) => OfferCartLine(
          productId: item.product.id,
          unitId: item.selectedUnit.id,
          quantity: item.quantity,
        ),
      ),
    );
    final checkout = context.watch<CheckoutProvider>();
    final couponDiscount = CouponTotals.effectiveCouponDiscount(
      apiDiscountAmount: _discountAmount,
      currentSubtotal: cart.subtotal,
      appliedSubtotal: _couponSubtotal,
    );
    final couponNeedsRecheck =
        _appliedCouponCode != null &&
        !CouponTotals.isCouponCurrent(
          appliedSubtotal: _couponSubtotal,
          currentSubtotal: cart.subtotal,
        );
    final total = CouponTotals.grandTotal(
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      couponDiscount: couponDiscount,
    );

    return PopScope(
      // منع الخروج العرضي أثناء معالجة الطلب
      canPop: !_isPlacing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isPlacing) {
          AppMessage.info(
            context,
            'يُرجى الانتظار حتى اكتمال إرسال الطلب...',
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Scaffold(
        appBar: AppPageHeader(title: ('إتمام الطلب')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── القسم الثاني: العنوان ──────────────────────────────
                _sectionTitle('عنوان التوصيل'),
                const SizedBox(height: 12),
                if (addressProvider.selectedAddress != null) ...[
                  AddressCard(address: addressProvider.selectedAddress!),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_location_alt),
                      label: const Text("تغيير أو إضافة عنوان"),
                      onPressed: () async {
                        final addressProvider = context.read<AddressProvider>();

                        final result = await context.push<bool>(
                          AppRoutes.addresses,
                          extra: true,
                        );

                        if (!mounted) return;

                        if (result == true) {
                          await addressProvider.loadAddresses();
                        }
                      },
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.location_off),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "لا يوجد عنوان",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text("أضف عنوان التوصيل لإكمال الطلب"),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final addressProvider = context
                                    .read<AddressProvider>();

                                final result = await context.push<bool>(
                                  AppRoutes.addresses,
                                  extra: true,
                                );

                                if (!mounted) return;

                                if (result == true) {
                                  await addressProvider.loadAddresses();
                                }
                              },
                              child: const Text("إضافة عنوان"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── القسم الثالث: طريقة الدفع ─────────────────────────
                _sectionTitle('طريقة الدفع'),
                const SizedBox(height: 12),
                const PaymentMethodSelector(),

                // حقل رفع صورة السند إذا اختار "تحويل بنكي"
                if (checkout.paymentMethod == PaymentMethod.card) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_outlined),
                      label: const Text("رفع صورة إيصال الدفع"),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── كوبون الخصم ───────────────────────────────────────
                _sectionTitle('كوبون الخصم'),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          hintText: 'أدخل كود الخصم',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _couponLoading ? null : _applyCoupon,
                        child: _couponLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("تطبيق"),
                      ),
                    ),
                  ],
                ),
                if (couponNeedsRecheck) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'تغيرت قيمة السلة، أعد تطبيق الكوبون للتحقق من الخصم.',
                    style: TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 24),

                // ── القسم الرابع: ملخص الطلب ──────────────────────────
                _sectionTitle('ملخص الطلب'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...cart.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} × ${item.quantity}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(0)} ر.ي',
                                ),
                              ],
                            ),
                          ),
                        ),
                        ...giftRewards.map(
                          (reward) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'هدية مجانية: ${reward.gift.productName} × ${reward.quantity}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '0 ر.ي',
                                  style: TextStyle(color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        _summaryRow('المجموع', cart.subtotal),
                        _summaryRow('التوصيل', cart.deliveryFee),
                        if (couponDiscount > 0)
                          _summaryRow(
                            'الخصم',
                            -couponDiscount,
                            color: Colors.green,
                          ),
                        const Divider(),
                        _summaryRow('الإجمالي', total, bold: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ── زر تأكيد الطلب ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isPlacing ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isPlacing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'تأكيد الطلب',
                            style: TextStyle(fontSize: 17),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ), // end Scaffold
      ), // end PopScope
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  );

  Widget _summaryRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('${value.toStringAsFixed(0)} ر.ي', style: style),
        ],
      ),
    );
  }
}
