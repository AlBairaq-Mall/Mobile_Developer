import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_back_button.dart';

enum OrderStatus { pending, preparing, ready, outForDelivery, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:        return 'جديد';
      case OrderStatus.preparing:      return 'قيد التجهيز';
      case OrderStatus.ready:          return 'جاهز للاستلام';
      case OrderStatus.outForDelivery: return 'خرج للتوصيل';
      case OrderStatus.delivered:      return 'تم التسليم';
      case OrderStatus.cancelled:      return 'ملغي';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:        return Icons.receipt_long_outlined;
      case OrderStatus.preparing:      return Icons.restaurant_outlined;
      case OrderStatus.ready:          return Icons.inventory_2_outlined;
      case OrderStatus.outForDelivery: return Icons.delivery_dining_outlined;
      case OrderStatus.delivered:      return Icons.check_circle_outline;
      case OrderStatus.cancelled:      return Icons.cancel_outlined;
    }
  }
}

/// شاشة تتبع الطلب (الصفحة رقم 11 في الوثيقة).
/// تعرض مراحل الطلب بشكل مرئي مع المرحلة الحالية مبرزة.
class OrderTrackingScreen extends StatelessWidget {
  final String orderNumber;
  final OrderStatus currentStatus;

  const OrderTrackingScreen({
    super.key,
    required this.orderNumber,
    this.currentStatus = OrderStatus.preparing,
  });

  @override
  Widget build(BuildContext context) {
    // مراحل الطلب الطبيعية (بدون "ملغي")
    const stages = [
      OrderStatus.pending,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    final currentIndex = stages.indexOf(currentStatus);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text('تتبع الطلب #$orderNumber'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: currentStatus == OrderStatus.cancelled
            ? _buildCancelled()
            : Column(
                children: [
                  const SizedBox(height: 20),
                  ...List.generate(stages.length, (i) {
                    final isDone = i <= currentIndex;
                    final isActive = i == currentIndex;
                    final isLast = i == stages.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العمود الأيمن: أيقونة + خط
                        Column(
                          children: [
                            _stepCircle(stages[i], isDone, isActive),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 50,
                                color: isDone
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                              ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // النص
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stages[i].label,
                                  style: TextStyle(
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isActive ? 17 : 15,
                                    color: isDone
                                        ? AppColors.textPrimary
                                        : Colors.grey,
                                  ),
                                ),
                                if (isActive)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'المرحلة الحالية',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 44),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _stepCircle(OrderStatus status, bool isDone, bool isActive) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? AppColors.primary : Colors.grey.shade200,
        border: isActive
            ? Border.all(color: AppColors.primary, width: 3)
            : null,
      ),
      child: Icon(
        status.icon,
        color: isDone ? Colors.white : Colors.grey,
        size: 20,
      ),
    );
  }

  Widget _buildCancelled() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel_outlined, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'تم إلغاء الطلب',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'رقم الطلب: $orderNumber',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
