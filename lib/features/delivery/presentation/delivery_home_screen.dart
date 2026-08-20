import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/delivery_order_model.dart';
import '../providers/delivery_provider.dart';
import 'widgets/delivery_order_details_sheet.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DeliveryProvider>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final provider = context.watch<DeliveryProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _Header(
                userName: user?.name ?? 'السائق',
                isOnline: _isOnline,
                activeOrdersCount: provider.activeOrders.length,
                onOnlineChanged: (value) {
                  setState(() => _isOnline = value);
                  if (value) {
                    context.read<DeliveryProvider>().refresh();
                  }
                },
              ),
              if (_isOnline)
                Container(
                  color: Colors.white,
                  child: const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: 'طلبات متاحة'),
                      Tab(text: 'طلباتي'),
                    ],
                  ),
                ),
              Expanded(
                child: !_isOnline
                    ? const _OfflineState()
                    : provider.isLoading
                        ? const LoadingWidget()
                        : TabBarView(
                            children: [
                              // Tab 1: Available Orders
                              provider.error != null && provider.availableOrders.isEmpty
                                  ? _ErrorState(
                                      error: provider.error!,
                                      onRetry: () =>
                                          context.read<DeliveryProvider>().refresh(),
                                    )
                                  : provider.availableOrders.isEmpty
                                      ? const _EmptyState(message: 'لا توجد طلبات متاحة حالياً')
                                      : RefreshIndicator(
                                          onRefresh: () => context.read<DeliveryProvider>().refresh(),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: provider.availableOrders.length,
                                            itemBuilder: (context, index) {
                                              return _AvailableOrderCard(
                                                order: provider.availableOrders[index],
                                              );
                                            },
                                          ),
                                        ),
                                        
                              // Tab 2: My Orders (Active)
                              provider.error != null && provider.activeOrders.isEmpty
                                  ? _ErrorState(
                                      error: provider.error!,
                                      onRetry: () =>
                                          context.read<DeliveryProvider>().refresh(),
                                    )
                                  : provider.activeOrders.isEmpty
                                      ? const _EmptyState(message: 'ليس لديك طلبات قيد التوصيل')
                                      : RefreshIndicator(
                                          onRefresh: () => context.read<DeliveryProvider>().refresh(),
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(16),
                                            itemCount: provider.activeOrders.length,
                                            itemBuilder: (context, index) {
                                              return _MyOrderCard(
                                                order: provider.activeOrders[index],
                                              );
                                            },
                                          ),
                                        ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Header
// ══════════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  final String userName;
  final bool isOnline;
  final int activeOrdersCount;
  final ValueChanged<bool> onOnlineChanged;

  const _Header({
    required this.userName,
    required this.isOnline,
    required this.activeOrdersCount,
    required this.onOnlineChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
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
                child: Icon(
                  Icons.delivery_dining,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، $userName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'سائق التوصيل',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: isOnline,
                    onChanged: onOnlineChanged,
                    activeThumbColor: Colors.greenAccent,
                    inactiveThumbColor: Colors.grey,
                  ),
                  Text(
                    isOnline ? 'متاح' : 'غير متاح',
                    style: TextStyle(
                      color: isOnline ? Colors.greenAccent : Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Available Order Card
// ══════════════════════════════════════════════════════════════════════════════

class _AvailableOrderCard extends StatelessWidget {
  final DeliveryOrderModel order;

  const _AvailableOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          DeliveryOrderDetailsSheet.show(context, order);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طلب #${order.orderNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${order.total} ر.س',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(order.customerName),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('${order.items.length} منتجات'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.paymentMethod,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    DeliveryOrderDetailsSheet.show(context, order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                    elevation: 0,
                  ),
                  child: const Text('عرض التفاصيل والاستلام'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// My Order Card
// ══════════════════════════════════════════════════════════════════════════════

class _MyOrderCard extends StatelessWidget {
  final DeliveryOrderModel order;

  const _MyOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          DeliveryOrderDetailsSheet.show(context, order);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طلب #${order.orderNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(order.customerName),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// States
// ══════════════════════════════════════════════════════════════════════════════

class _OfflineState extends StatelessWidget {
  const _OfflineState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'أنت غير متاح الآن',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'قم بتفعيل حالتك لتلقي الطلبات',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
