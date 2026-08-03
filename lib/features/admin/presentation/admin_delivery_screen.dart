import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_back_button.dart';

class AdminDeliveryScreen extends StatelessWidget {
  const AdminDeliveryScreen({super.key});

  static const _drivers = [
    _Driver(name: 'محمد علي', phone: '733000001', status: 'متاح', deliveries: 8, rating: 4.8),
    _Driver(name: 'خالد أحمد', phone: '733000002', status: 'مشغول', deliveries: 5, rating: 4.5),
    _Driver(name: 'سعيد محمد', phone: '733000003', status: 'غير متاح', deliveries: 0, rating: 4.2),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('إدارة التوصيل'),
          actions: [
            IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: () {}, tooltip: 'إضافة سائق'),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'السائقون'), Tab(text: 'الطلبات الحالية')],
          ),
        ),
        body: TabBarView(
          children: [
            // السائقون
            ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _drivers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final d = _drivers[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _statusColor(d.status).withValues(alpha: 0.1),
                          radius: 26,
                          child: Icon(Icons.delivery_dining, color: _statusColor(d.status), size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(d.phone, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text('${d.rating}', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
                                  const SizedBox(width: 4),
                                  Text('${d.deliveries} توصيلة اليوم', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(d.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(d.status,
                                  style: TextStyle(color: _statusColor(d.status), fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(height: 8),
                            // TODO: POST /api/admin/assign-order
                            OutlinedButton(
                              onPressed: d.status == 'متاح' ? () {} : null,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                              child: const Text('تعيين طلب', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // الطلبات الحالية
            const Center(child: Text('لا توجد طلبات جارية الآن')),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    if (s == 'متاح') return AppColors.success;
    if (s == 'مشغول') return Colors.orange;
    return Colors.grey;
  }
}

class _Driver {
  final String name, phone, status;
  final int deliveries;
  final double rating;
  const _Driver({required this.name, required this.phone, required this.status,
      required this.deliveries, required this.rating});
}
