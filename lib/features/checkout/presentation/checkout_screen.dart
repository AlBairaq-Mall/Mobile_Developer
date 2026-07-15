import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../address/providers/address_provider.dart';
import '../../address/widgets/address_card.dart';
import '../../cart/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../widgets/payment_method_selector.dart';
import '../models/payment_method.dart';

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
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم تطبيق الكوبون: خصم 10%')));
    } else {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('كود الكوبون غير صحيح')));
    }
  }

  Future<void> _placeOrder() async {
    final addressProvider = context.read<AddressProvider>();
    if (addressProvider.selectedAddress == null) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('الرجاء اختيار عنوان التوصيل')));
      return;
    }

    setState(() => _isPlacing = true);
    // TODO: استدعاء API إنشاء الطلب الفعلي
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    context.read<CartProvider>().clear();
    // توليد رقم طلب مؤقت حتى يتوفر الـ API
    final orderNum = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    context.go('/order-success', extra: orderNum);
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    final cart = context.watch<CartProvider>();
    final checkout = context.watch<CheckoutProvider>();
    final discountAmount = cart.subtotal * (_discount / 100);
    final finalTotal = cart.grandTotal - discountAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('إتمام الطلب')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── القسم الثاني: العنوان ──────────────────────────────
            _sectionTitle('عنوان التوصيل'),
            const SizedBox(height: 12),
            if (addressProvider.selectedAddress != null)
              AddressCard(address: addressProvider.selectedAddress!)
            else
              const Card(
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('لم يتم تحديد عنوان'),
                  subtitle: Text('الرجاء إضافة عنوان التوصيل'),
                ),
              ),

            const SizedBox(height: 24),

            // ── القسم الثالث: طريقة الدفع ─────────────────────────
            _sectionTitle('طريقة الدفع'),
            const SizedBox(height: 12),
            const PaymentMethodSelector(),

            // حقل رفع صورة السند إذا اختار "تحويل بنكي"
            if (checkout.paymentMethod == PaymentMethod.card) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: فتح معرض الصور لرفع صورة السند
                },
                icon: const Icon(Icons.upload_outlined),
                label: const Text('رفع صورة إيصال الدفع'),
              ),
            ],

            const SizedBox(height: 24),

            // ── كوبون الخصم ───────────────────────────────────────
            _sectionTitle('كوبون الخصم'),
            const SizedBox(height: 12),
            Row(
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  child: const Text('تطبيق'),
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
                            Text('${item.totalPrice.toStringAsFixed(0)} ر.ي'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    _summaryRow('المجموع', cart.subtotal),
                    _summaryRow('التوصيل', cart.deliveryFee),
                    if (_discount > 0)
                      _summaryRow('الخصم ($_discount%)', -discountAmount, color: Colors.green),
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
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('تأكيد الطلب', style: TextStyle(fontSize: 17)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      );

  Widget _summaryRow(String label, double value, {bool bold = false, Color? color}) {
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

