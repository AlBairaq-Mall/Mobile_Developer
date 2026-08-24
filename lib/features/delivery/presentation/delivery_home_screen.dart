import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/loading_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/delivery_order_model.dart';
import '../providers/delivery_provider.dart';
import 'widgets/delivery_order_details_sheet.dart';

class DeliveryHomeScreen extends StatefulWidget {
  const DeliveryHomeScreen({super.key});

  @override
  State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
}

class _DeliveryHomeScreenState extends State<DeliveryHomeScreen>
    with WidgetsBindingObserver {
  static const Duration _autoRefreshInterval = Duration(seconds: 60);

  Timer? _refreshTimer;

  bool _isRefreshing = false;
  bool _initialSnapshotReady = false;

  Set<String> _knownAvailableOrderIds = <String>{};
  Map<String, String> _knownOrderStatuses = <String, String>{};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initialLoad();

      _refreshTimer = Timer.periodic(
        _autoRefreshInterval,
        (_) => _autoRefresh(),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  // ===========================================================================
  // App lifecycle
  // ===========================================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshOnResume();
    }
  }

  // ===========================================================================
  // Initial load
  // ===========================================================================

  Future<void> _initialLoad() async {
    if (!mounted) return;

    final provider = context.read<DeliveryProvider>();

    await provider.refresh();

    if (!mounted) return;

    _createInitialSnapshot(provider);
  }

  // ===========================================================================
  // Automatic refresh
  // ===========================================================================

  Future<void> _autoRefresh() async {
    if (!mounted || _isRefreshing) return;

    await _refreshAndDetectChanges(
      showRefreshIndicator: false,
    );
  }

  // ===========================================================================
  // Refresh when returning to app
  // ===========================================================================

  Future<void> _refreshOnResume() async {
    if (!mounted || _isRefreshing) return;

    await _refreshAndDetectChanges(
      showRefreshIndicator: false,
    );
  }

  // ===========================================================================
  // Pull to refresh
  // ===========================================================================

  Future<void> _manualRefresh() async {
    await _refreshAndDetectChanges(
      showRefreshIndicator: true,
    );
  }

  // ===========================================================================
  // Central refresh
  // ===========================================================================

  Future<void> _refreshAndDetectChanges({
    required bool showRefreshIndicator,
  }) async {
    if (!mounted || _isRefreshing) return;

    _isRefreshing = true;

    try {
      final provider = context.read<DeliveryProvider>();

      final oldAvailableIds = Set<String>.from(
        _knownAvailableOrderIds,
      );

      final oldStatuses = Map<String, String>.from(
        _knownOrderStatuses,
      );

      await provider.refresh();

      if (!mounted) return;

      final newAvailableOrders = provider.availableOrders;

      final newAvailableIds = newAvailableOrders
          .map((order) => order.id)
          .where((id) => id.isNotEmpty)
          .toSet();

      final newOrders = newAvailableOrders.where(
        (order) => order.id.isNotEmpty && !oldAvailableIds.contains(order.id),
      );

      final statusChanges = <DeliveryOrderModel>[];

      for (final order in provider.orders) {
        final previousStatus = oldStatuses[order.id];

        if (previousStatus != null && previousStatus != order.status) {
          statusChanges.add(order);
        }
      }

      _knownAvailableOrderIds = newAvailableIds;

      _knownOrderStatuses = {
        for (final order in provider.orders)
          if (order.id.isNotEmpty) order.id: order.status,
      };

      if (!_initialSnapshotReady) {
        _initialSnapshotReady = true;
        return;
      }

      // -----------------------------------------------------------------------
      // New available orders
      // -----------------------------------------------------------------------

      final newOrdersList = newOrders.toList();

      if (newOrdersList.isNotEmpty) {
        _showNotification(
          title: 'طلب جديد',
          message: newOrdersList.length == 1
              ? 'وصل طلب جديد متاح للتوصيل'
              : 'وصل ${newOrdersList.length} طلبات جديدة متاحة للتوصيل',
          icon: Icons.delivery_dining,
        );
      }

      // -----------------------------------------------------------------------
      // Existing order status changed
      // -----------------------------------------------------------------------

      if (statusChanges.isNotEmpty && newOrdersList.isEmpty) {
        final changedOrder = statusChanges.first;

        _showNotification(
          title: 'تحديث الطلب',
          message:
              'تم تحديث حالة الطلب #${changedOrder.orderNumber} إلى ${_statusLabel(changedOrder.status)}',
          icon: Icons.sync,
        );
      }
    } finally {
      _isRefreshing = false;
    }
  }

  // ===========================================================================
  // Initial snapshot
  // ===========================================================================

  void _createInitialSnapshot(DeliveryProvider provider) {
    _knownAvailableOrderIds = provider.availableOrders
        .map((order) => order.id)
        .where((id) => id.isNotEmpty)
        .toSet();

    _knownOrderStatuses = {
      for (final order in provider.orders)
        if (order.id.isNotEmpty) order.id: order.status,
    };

    _initialSnapshotReady = true;
  }

  // ===========================================================================
  // Notification
  // ===========================================================================

  void _showNotification({
    required String title,
    required String message,
    required IconData icon,
  }) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';

      case 'confirmed':
        return 'تم التأكيد';

      case 'processing':
        return 'قيد التجهيز';

      case 'shipped':
        return 'خرج للتوصيل';

      case 'delivered':
        return 'تم التسليم';

      case 'cancelled':
        return 'ملغي';

      default:
        return status.isEmpty ? 'غير محددة' : status;
    }
  }

  // ===========================================================================
  // Build
  // ===========================================================================

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
                activeOrdersCount: provider.activeOrders.length,
              ),
              const Material(
                color: Colors.white,
                child: TabBar(
                  tabs: [
                    Tab(text: 'طلبات متاحة'),
                    Tab(text: 'طلباتي'),
                  ],
                ),
              ),
              Expanded(
                child: provider.isLoading &&
                        provider.availableOrders.isEmpty &&
                        provider.orders.isEmpty
                    ? const LoadingWidget()
                    : TabBarView(
                        children: [
                          _buildAvailableOrders(
                            provider,
                          ),
                          _buildMyOrders(
                            provider,
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

  // ===========================================================================
  // Available orders
  // ===========================================================================

  Widget _buildAvailableOrders(
    DeliveryProvider provider,
  ) {
    if (provider.error != null && provider.availableOrders.isEmpty) {
      return _ErrorState(
        error: provider.error!,
        onRetry: _manualRefresh,
      );
    }

    if (provider.availableOrders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _manualRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            _EmptyState(
              message: 'لا توجد طلبات متاحة حالياً',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _manualRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: provider.availableOrders.length,
        itemBuilder: (context, index) {
          return _AvailableOrderCard(
            order: provider.availableOrders[index],
          );
        },
      ),
    );
  }

  // ===========================================================================
  // My active orders
  // ===========================================================================

  Widget _buildMyOrders(
    DeliveryProvider provider,
  ) {
    if (provider.error != null && provider.activeOrders.isEmpty) {
      return _ErrorState(
        error: provider.error!,
        onRetry: _manualRefresh,
      );
    }

    if (provider.activeOrders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _manualRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            _EmptyState(
              message: 'ليس لديك طلبات قيد التوصيل',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _manualRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: provider.activeOrders.length,
        itemBuilder: (context, index) {
          return _MyOrderCard(
            order: provider.activeOrders[index],
          );
        },
      ),
    );
  }
}

// =============================================================================
// Header
// =============================================================================

class _Header extends StatelessWidget {
  final String userName;
  final int activeOrdersCount;

  const _Header({
    required this.userName,
    required this.activeOrdersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
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
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (activeOrdersCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$activeOrdersCount طلب',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// Available Order Card
// =============================================================================

class _AvailableOrderCard extends StatelessWidget {
  final DeliveryOrderModel order;

  const _AvailableOrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          DeliveryOrderDetailsSheet.show(
            context,
            order,
          );
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
                    '${order.total.toStringAsFixed(0)} ر.ي',
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
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(order.customerName),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text('${order.items.length} منتجات'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.paymentMethod,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    DeliveryOrderDetailsSheet.show(
                      context,
                      order,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                    elevation: 0,
                  ),
                  child: const Text(
                    'عرض التفاصيل والاستلام',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// My Order Card
// =============================================================================

class _MyOrderCard extends StatelessWidget {
  final DeliveryOrderModel order;

  const _MyOrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          DeliveryOrderDetailsSheet.show(
            context,
            order,
          );
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
                  _StatusBadge(
                    status: order.status,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(order.customerName),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
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

// =============================================================================
// Status Badge
// =============================================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          color: _foregroundColor(status),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _label(String value) {
    switch (value) {
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'تم التأكيد';
      case 'processing':
        return 'قيد التجهيز';
      case 'shipped':
        return 'خرج للتوصيل';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغي';
      default:
        return value.isEmpty ? 'غير محدد' : value;
    }
  }

  Color _backgroundColor(String value) {
    switch (value) {
      case 'delivered':
        return Colors.green.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      case 'shipped':
        return Colors.blue.shade50;
      case 'processing':
        return Colors.orange.shade50;
      case 'confirmed':
        return Colors.indigo.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _foregroundColor(String value) {
    switch (value) {
      case 'delivered':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      case 'shipped':
        return Colors.blue.shade700;
      case 'processing':
        return Colors.orange.shade700;
      case 'confirmed':
        return Colors.indigo.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

// =============================================================================
// Empty State
// =============================================================================

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
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

// =============================================================================
// Error State
// =============================================================================

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
              ),
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
