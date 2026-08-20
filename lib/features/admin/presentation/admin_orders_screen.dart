import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:bhm_supermarket/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../providers/admin_orders_provider.dart';
import '../../delivery/models/delivery_order_model.dart';
import 'widgets/admin_order_details_sheet.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrdersProvider>().loadOrders();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppPageHeader(
        title: 'الطلبات',
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'الجديدة'),
            Tab(text: 'قيد التجهيز'),
            Tab(text: 'خرجت للتوصيل'),
          ],
        ),
      ),
      body: Consumer<AdminOrdersProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.orders.isEmpty) {
            return const Center(child: AppLoading());
          }

          if (provider.error != null && provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: provider.loadOrders,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabs,
            children: [
              _OrderList(orders: provider.orders, provider: provider),
              _OrderList(
                orders: provider.orders.where((o) => o.status == 'new').toList(),
                provider: provider,
              ),
              _OrderList(
                orders: provider.orders.where((o) => o.status == 'preparing').toList(),
                provider: provider,
              ),
              _OrderList(
                orders: provider.orders.where((o) => o.status == 'out_for_delivery').toList(),
                provider: provider,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<DeliveryOrderModel> orders;
  final AdminOrdersProvider provider;
  const _OrderList({required this.orders, required this.provider});

  Color _statusColor(String s) {
    if (s == 'new') return Colors.blue;
    if (s == 'preparing') return Colors.orange;
    if (s == 'out_for_delivery') return Colors.purple;
    if (s == 'delivered') return AppColors.success;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: const [
            SizedBox(height: 100),
            Center(child: Text('لا يوجد طلبات')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final o = orders[i];
          return Card(
            child: Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  AdminOrderDetailsSheet.show(context, o);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _statusColor(o.status).withValues(alpha: 0.1),
                    child: Text(
                      '#${o.id}',
                      style: TextStyle(fontSize: 10, color: _statusColor(o.status)),
                    ),
                  ),
                  title: Text(
                    o.customerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${o.total.toStringAsFixed(0)} ر.ي  •  ${o.createdAt?.substring(0, 10) ?? ''}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(o.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          o.status,
                          style: TextStyle(
                            color: _statusColor(o.status),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
