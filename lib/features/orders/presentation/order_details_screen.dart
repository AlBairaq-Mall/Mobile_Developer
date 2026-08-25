import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
// unused
import '../utils/payment_method_text.dart';
import '../widgets/order_progress.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppPageHeader(
        title: 'تفاصيل الطلب',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================================================================
          // معلومات الطلب الأساسية
          // ================================================================
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              title: Text(
                order.orderNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(order.createdAt),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: order.statusEnum.color.withValues(
                    alpha: .15,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  order.statusEnum.label,
                  style: TextStyle(
                    color: order.statusEnum.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================================================================
          // حالة الطلب
          // ================================================================
          const Text(
            'حالة الطلب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          OrderProgress(
            status: order.status,
          ),

          const SizedBox(height: 20),

          // ================================================================
          // معلومات الطلب
          // ================================================================
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow(
                    'رقم الطلب',
                    order.orderNumber,
                  ),
                  _infoRow(
                    'طريقة الدفع',
                    paymentMethodText(order.paymentMethod),
                  ),
                  _infoRow(
                    'حالة الدفع',
                    order.paymentStatus.toLowerCase() == 'pending'
                        ? 'قيد الانتظار'
                        : order.paymentStatus,
                  ),
                  _infoRow(
                    'العنوان',
                    order.location.address,
                  ),
                  if (order.notes != null && order.notes!.trim().isNotEmpty)
                    _infoRow(
                      'ملاحظات',
                      order.notes!,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================================================================
          // المنتجات
          // ================================================================
          const Text(
            'المنتجات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...order.items.map(
            (item) => Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.isGift ? AppColors.success.withValues(alpha: 0.1) : null,
                  child: Icon(
                    item.isGift ? Icons.card_giftcard : Icons.shopping_bag_outlined,
                    color: item.isGift ? AppColors.success : null,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product?.nameAr ?? 'منتج غير متوفر',
                      ),
                    ),
                    if (item.isGift)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'هدية',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(
                  '${item.unit?.unitName ?? 'غير معروف'} • ${item.price} ر.ي',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '× ${item.quantity}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${item.total} ر.ي',
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================================================================
          // ملخص الأسعار
          // ================================================================
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // المجموع قبل الخصم
                  _priceRow(
                    'المجموع',
                    order.subtotal,
                  ),

                  // رسوم التوصيل
                  _priceRow(
                    'التوصيل',
                    order.deliveryFee,
                  ),

                  // الخصم العام
                  if (order.discount > 0)
                    _priceRow(
                      'الخصم',
                      -order.discount,
                      color: Colors.green,
                    ),

                  // خصم الكوبون
                  if (order.couponDiscount > 0)
                    _priceRow(
                      'خصم الكوبون',
                      -order.couponDiscount,
                      color: Colors.green,
                    ),

                  const Divider(),

                  // الإجمالي النهائي القادم من Backend
                  _priceRow(
                    'الإجمالي',
                    order.total,
                    bold: true,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ==========================================================================
  // معلومات
  // ==========================================================================

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // الأسعار
  // ==========================================================================

  Widget _priceRow(
    String title,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style,
          ),
          Text(
            '${value.toStringAsFixed(2)} ر.ي',
            style: style,
          ),
        ],
      ),
    );
  }
}
