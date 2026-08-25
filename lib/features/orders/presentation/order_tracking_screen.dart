import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_page_header.dart';

import '../models/order_status.dart';

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
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentIndex = stages.indexOf(currentStatus);

    return Scaffold(
      appBar: AppPageHeader(title: 'تتبع الطلب #$orderNumber'),
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
        border:
            isActive ? Border.all(color: AppColors.primary, width: 3) : null,
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
