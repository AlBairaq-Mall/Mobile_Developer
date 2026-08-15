import 'package:flutter/material.dart';

class OrderProgress extends StatelessWidget {
  final String status;

  const OrderProgress({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    const statuses = [
      "pending",
      "confirmed",
      "processing",
      "shipped",
      "delivered",
    ];

    final currentIndex = statuses.indexOf(status);

    return Row(
      children: List.generate(statuses.length, (index) {
        final active = index <= currentIndex;

        return Expanded(
          child: Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: active ? Colors.green : Colors.grey.shade300,
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
              const SizedBox(height: 6),
              if (index != statuses.length - 1)
                Container(
                  height: 4,
                  color: active ? Colors.green : Colors.grey.shade300,
                ),
            ],
          ),
        );
      }),
    );
  }
}
