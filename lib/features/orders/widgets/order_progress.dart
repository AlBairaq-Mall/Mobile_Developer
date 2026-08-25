import 'package:flutter/material.dart';

import '../models/order_status.dart';
import '../../../app/theme/app_colors.dart';

class OrderProgress extends StatelessWidget {
  final String status;

  const OrderProgress({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final currentStatus = OrderStatusExt.fromString(status);

    const stages = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    if (currentStatus == OrderStatus.cancelled || currentStatus == OrderStatus.unknown) {
       return const SizedBox();
    }

    final currentIndex = stages.indexOf(currentStatus);

    return Row(
      children: List.generate(stages.length, (index) {
        final active = index <= currentIndex;

        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: active ? AppColors.primary : Colors.grey.shade300,
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
              const SizedBox(height: 6),
              if (index != stages.length - 1)
                Container(
                  height: 4,
                  color: active ? AppColors.primary : Colors.grey.shade300,
                ),
            ],
          ),
        );
      }),
    );
  }
}
