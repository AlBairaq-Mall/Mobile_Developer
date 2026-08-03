import 'package:bhm_supermarket/app/router/app_routes.dart';
import 'package:bhm_supermarket/features/orders/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_back_button.dart';
import '../../address/providers/address_provider.dart';
import '../../address/widgets/address_card.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
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
  double _discount = 0;
  bool _isPlacing = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    // TODO: ربط بـ API الكوبونات
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'WELCOME10') {
      setState(() => _discount = 10);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تطبيق الكوبون: خصم 10%')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('كود الكوبون غير صحيح')));
    }
  }

  Future<void> _placeOrder() async {
    final addressProvider = context.read<AddressProvider>();
    final cart = context.read<CartProvider>();
    final checkout = context.read<CheckoutProvider>();

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

    final discountAmount = cart.subtotal * (_discount / 100);

    try {
      final response = await DependencyInjection.orderRepository.createOrder(
        addressId: addressProvider.selectedAddress!.id,
        paymentMethod: paymentApiValue(checkout.paymentMethod),
        deliveryFee: cart.deliveryFee,
        discount: discountAmount,
        notes: null,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isEmpty ? "فشل إنشاء الطلب" : response.message,
            ),
          ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
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
    final checkout = context.watch<CheckoutProvider>();
    final discountAmount = cart.subtotal * (_discount / 100);
    final finalTotal = cart.grandTotal - discountAmount;

    return PopScope(
      // منع الخروج العرضي أثناء معالجة الطلب
      canPop: !_isPlacing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isPlacing) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يُرجى الانتظار حتى اكتمال إرسال الطلب...'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: AppBackButton(fallbackRoute: AppRoutes.cart),
            title: const Text('إتمام الطلب')),
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
                  AddressCard(
                    address: addressProvider.selectedAddress!,
                  ),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                final addressProvider =
                                    context.read<AddressProvider>();

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
                  )
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
                  )
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
                              horizontal: 12, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _applyCoupon,
                        child: const Text("تطبيق"),
                      ),
                    ),
                  ],
                ),

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
                                    '${item.totalPrice.toStringAsFixed(0)} ر.ي'),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        _summaryRow('المجموع', cart.subtotal),
                        _summaryRow('التوصيل', cart.deliveryFee),
                        if (_discount > 0)
                          _summaryRow('الخصم ($_discount%)', -discountAmount,
                              color: Colors.green),
                        const Divider(),
                        _summaryRow('الإجمالي', finalTotal, bold: true),
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
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('تأكيد الطلب',
                            style: TextStyle(fontSize: 17)),
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

  Widget _summaryRow(String label, double value,
      {bool bold = false, Color? color}) {
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
