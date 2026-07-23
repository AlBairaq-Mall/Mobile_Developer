import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});
  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  // TODO: استبدل بـ API: GET /api/admin/orders?status=...
  final _orders = const [
    _AdminOrder(
        id: '1045',
        customer: 'أحمد علي',
        total: 4500,
        status: 'جديد',
        time: 'منذ 5 دقائق'),
    _AdminOrder(
        id: '1044',
        customer: 'سارة محمد',
        total: 12000,
        status: 'قيد التجهيز',
        time: 'منذ 20 دقيقة'),
    _AdminOrder(
        id: '1043',
        customer: 'خالد حسن',
        total: 8000,
        status: 'خرج للتوصيل',
        time: 'منذ ساعة'),
    _AdminOrder(
        id: '1042',
        customer: 'فاطمة أحمد',
        total: 3500,
        status: 'تم التسليم',
        time: 'أمس'),
    _AdminOrder(
        id: '1041',
        customer: 'محمد عمر',
        total: 6000,
        status: 'ملغي',
        time: 'أمس'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'جديد'),
            Tab(text: 'قيد التجهيز'),
            Tab(text: 'خرج للتوصيل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _OrderList(orders: _orders),
          _OrderList(orders: _orders.where((o) => o.status == 'جديد').toList()),
          _OrderList(
              orders: _orders.where((o) => o.status == 'قيد التجهيز').toList()),
          _OrderList(
              orders: _orders.where((o) => o.status == 'خرج للتوصيل').toList()),
        ],
      ),
    );
  }
}

class _AdminOrder {
  final String id, customer, status, time;
  final double total;
  const _AdminOrder(
      {required this.id,
      required this.customer,
      required this.total,
      required this.status,
      required this.time});
}

class _OrderList extends StatelessWidget {
  final List<_AdminOrder> orders;
  const _OrderList({required this.orders});

  Color _statusColor(String s) {
    if (s == 'جديد') return Colors.blue;
    if (s == 'قيد التجهيز') return Colors.orange;
    if (s == 'خرج للتوصيل') return Colors.purple;
    if (s == 'تم التسليم') return AppColors.success;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const Center(child: Text('لا توجد طلبات'));
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final o = orders[i];
        return Card(
          child: Material(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _statusColor(o.status).withOpacity(0.1),
                child: Text('#${o.id}',
                    style:
                        TextStyle(fontSize: 10, color: _statusColor(o.status))),
              ),
              title: Text(o.customer,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${o.total.toStringAsFixed(0)} ر.ي  •  ${o.time}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(o.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(o.status,
                        style: TextStyle(
                            color: _statusColor(o.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  // TODO: تغيير الحالة عبر PATCH /api/admin/orders/{id}/status
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 16),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'preparing', child: Text('قيد التجهيز')),
                      PopupMenuItem(value: 'out', child: Text('أرسل للتوصيل')),
                      PopupMenuItem(
                          value: 'cancel',
                          child: Text('إلغاء',
                              style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
