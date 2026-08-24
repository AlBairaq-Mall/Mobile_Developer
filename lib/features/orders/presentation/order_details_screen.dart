import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../utils/order_status_color.dart';
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
    // الخصم النهائي = الخصم العام + خصم الكوبون
    final totalDiscount = order.discount + order.couponDiscount;

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
                  color: orderStatusColor(order.status).withValues(
                    alpha: .15,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  orderStatusText(order.status),
                  style: TextStyle(
                    color: orderStatusColor(order.status),
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
                    order.paymentStatus,
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
                leading: const CircleAvatar(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                  ),
                ),
                title: Text(
                  item.product.nameAr,
                ),
                subtitle: Text(
                  '${item.unit.unitName} • ${item.price} ر.ي',
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
                  if (order.deliveryFee > 0)
                    _priceRow(
                      'التوصيل',
                      order.deliveryFee,
                    ),

                  // الخصم العام + خصم الكوبون
                  if (totalDiscount > 0)
                    _priceRow(
                      'الخصم',
                      -totalDiscount,
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
