import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/shimmer_widget.dart';
import '../../cart/providers/cart_provider.dart';
import 'order_tracking_screen.dart';

class _SampleOrder {
  final String id, number, customer, status, date;
  final double total;
  final int itemCount;
  const _SampleOrder({required this.id, required this.number, required this.customer,
    required this.status, required this.date, required this.total, required this.itemCount});
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // TODO: replace with API call → GET /api/orders (paginated)
  static const _orders = [
    _SampleOrder(id:'1', number:'1045', customer:'أنت', status:'خرج للتوصيل', date:'2026-07-03', total:4500, itemCount:3),
    _SampleOrder(id:'2', number:'1042', customer:'أنت', status:'تم التسليم',  date:'2026-06-25', total:12000, itemCount:7),
    _SampleOrder(id:'3', number:'1038', customer:'أنت', status:'ملغي',        date:'2026-06-20', total:2000, itemCount:2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: _orders.isEmpty
          ? const EmptyState(emoji:'📦', title:'لا توجد طلبات',
              subtitle:'ابدأ تسوقك الآن وستظهر طلباتك هنا')
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _OrderCard(order: _orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final _SampleOrder order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'تم التسليم':      return AppColors.success;
      case 'ملغي':            return AppColors.error;
      case 'خرج للتوصيل':    return AppColors.info;
      default:                return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('طلب #${order.number}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order.status, style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${order.itemCount} منتجات  •  ${order.total.toStringAsFixed(0)} ر.ي',
                style: const TextStyle(color: AppColors.textSecondary)),
            Text(order.date, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            const SizedBox(height: 14),
            Row(
              children: [
                // Track button
                if (order.status != 'ملغي')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(orderNumber: order.number))),
                      icon: const Icon(Icons.location_on_outlined, size: 16),
                      label: const Text('تتبع الطلب'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (order.status != 'ملغي') const SizedBox(width: 10),
                // Reorder button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: GET /api/orders/{id}/items → add all to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت إضافة منتجات الطلب للسلة'),
                            backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating));
                    },
                    icon: const Icon(Icons.replay_rounded, size: 16),
                    label: const Text('إعادة الطلب'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
