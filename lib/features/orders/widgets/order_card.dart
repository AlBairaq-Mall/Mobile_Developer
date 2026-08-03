import 'package:bhm_supermarket/features/orders/utils/payment_method_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../models/order_model.dart';
import '../utils/order_status_color.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard(
    this.order, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.orderNumber,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.createdAt,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: orderStatusColor(order.status).withValues(alpha: .15),
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
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "الإجمالي : ${order.total} ر.ي",
            ),
            const SizedBox(height: 6),
            Text(
              "الدفع : ${paymentMethodText(order.paymentMethod)}",
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    AppRoutes.orderDetails,
                    extra: order,
                  );
                },
                child: const Text(
                  "تفاصيل الطلب",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
