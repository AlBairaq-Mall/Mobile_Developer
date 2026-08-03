import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});
  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  bool _isOnline = true;

  // TODO: GET /api/delivery/current-orders
  final _pendingOrders = const [
    _DeliveryOrder(
        id: '1045',
        customer: 'أحمد علي',
        address: 'عدن - المنصورة - شارع الأمين',
        distance: '2.5 كم',
        total: 4500,
        phone: '777123456'),
    _DeliveryOrder(
        id: '1044',
        customer: 'سارة محمد',
        address: 'عدن - خور مكسر - شارع الجمهورية',
        distance: '1.8 كم',
        total: 8000,
        phone: '771456789'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.delivery_dining,
                              color: Colors.white, size: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('مرحباً، ${user?.name ?? 'السائق'}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const Text('سائق التوصيل',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      // Online Toggle
                      Column(
                        children: [
                          Switch(
                            value: _isOnline,
                            onChanged: (v) => setState(() => _isOnline = v),
                            activeThumbColor: Colors.greenAccent,
                            inactiveThumbColor: Colors.grey,
                          ),
                          Text(_isOnline ? 'متاح' : 'غير متاح',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    children: [
                      _StatPill('طلبات اليوم', '8', Icons.check_circle_outline),
                      const SizedBox(width: 10),
                      _StatPill('التقييم', '4.8 ★', Icons.star_outline),
                      const SizedBox(width: 10),
                      _StatPill('الأرباح', '12,000 ر.ي', Icons.attach_money),
                    ],
                  ),
                ],
              ),
            ),

            // Orders
            Expanded(
              child: _isOnline
                  ? (_pendingOrders.isEmpty
                      ? const Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('لا توجد طلبات حالياً',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                              child: Text('طلبات بانتظار التوصيل',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                itemCount: _pendingOrders.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) =>
                                    _OrderCard(order: _pendingOrders[i]),
                              ),
                            ),
                          ],
                        ))
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('أنت غير متاح حالياً',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                          Text('فعّل الحالة للاستقبال',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StatPill(this.label, this.value, this.icon);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ),
      );
}

class _DeliveryOrder {
  final String id, customer, address, distance, phone;
  final double total;
  const _DeliveryOrder(
      {required this.id,
      required this.customer,
      required this.address,
      required this.distance,
      required this.total,
      required this.phone});
}

class _OrderCard extends StatefulWidget {
  final _DeliveryOrder order;
  const _OrderCard({required this.order});
  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('طلب #${o.id}',
                      style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                Text('${o.total.toStringAsFixed(0)} ر.ي',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(o.customer,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(o.address,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13))),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.directions_car_outlined,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(o.distance,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ]),
            const SizedBox(height: 14),
            Row(
              children: [
                // اتصال بالعميل
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_outlined, size: 16),
                    label: const Text('اتصال'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      side: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // بدء / إتمام التوصيل
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_started) {
                        // TODO: PATCH /api/delivery/orders/{id}/complete
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('تم تسليم الطلب بنجاح ✓')));
                      } else {
                        // TODO: PATCH /api/delivery/orders/{id}/start
                        setState(() => _started = true);
                      }
                    },
                    icon: Icon(
                        _started
                            ? Icons.check_circle_outline
                            : Icons.delivery_dining_outlined,
                        size: 16),
                    label: Text(_started ? 'تم التسليم' : 'بدء التوصيل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _started ? AppColors.success : Colors.blue.shade700,
                      foregroundColor: Colors.white,
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
