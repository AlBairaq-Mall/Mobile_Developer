// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../app/theme/app_colors.dart';
// import '../../auth/providers/auth_provider.dart';
// import '../models/delivery_order_model.dart';
// import '../providers/delivery_provider.dart';

// class DeliveryHomeScreen extends StatefulWidget {
//   const DeliveryHomeScreen({super.key});

//   @override
//   State<DeliveryHomeScreen> createState() => _DeliveryHomeScreenState();
// }

// class _DeliveryHomeScreenState extends State<DeliveryHomeScreen> {
//   bool _isOnline = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         context.read<DeliveryProvider>().loadOrders();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthProvider>().user;
//     final provider = context.watch<DeliveryProvider>();

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ── Header ──────────────────────────────────────────────────
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.shade700, Colors.blue.shade500],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       const CircleAvatar(
//                         radius: 24,
//                         backgroundColor: Colors.white24,
//                         child: Icon(
//                           Icons.delivery_dining,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'مرحباً، ${user?.name ?? 'السائق'}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             const Text(
//                               'سائق التوصيل',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Online Toggle
//                       Column(
//                         children: [
//                           Switch(
//                             value: _isOnline,
//                             onChanged: (v) {
//                               setState(() => _isOnline = v);
//                               if (v) {
//                                 context.read<DeliveryProvider>().loadOrders();
//                               }
//                             },
//                             activeThumbColor: Colors.greenAccent,
//                             inactiveThumbColor: Colors.grey,
//                           ),
//                           Text(
//                             _isOnline ? 'متاح' : 'غير متاح',
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 11,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Stats Row
//                   Row(
//                     children: [
//                       _StatPill(
//                         'طلبات نشطة',
//                         '${provider.orders.length}',
//                         Icons.check_circle_outline,
//                       ),
//                       const SizedBox(width: 10),
//                       const _StatPill('التقييم', '— ★', Icons.star_outline),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // ── Orders Body ──────────────────────────────────────────────
//             Expanded(
//               child: !_isOnline
//                   ? const _OfflineState()
//                   : provider.isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : provider.error != null
//                           ? _ErrorState(
//                               error: provider.error!,
//                               onRetry: () =>
//                                   context.read<DeliveryProvider>().loadOrders(),
//                             )
//                           : provider.isEmpty
//                               ? const _EmptyState()
//                               : _OrdersList(orders: provider.orders),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ══════════════════════════════════════════════════════════════════════════════

// class _StatPill extends StatelessWidget {
//   final String label, value;
//   final IconData icon;
//   const _StatPill(this.label, this.value, this.icon);

//   @override
//   Widget build(BuildContext context) => Expanded(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.15),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             children: [
//               Icon(icon, color: Colors.white, size: 16),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.white70, fontSize: 10),
//               ),
//             ],
//           ),
//         ),
//       );
// }

// class _OfflineState extends StatelessWidget {
//   const _OfflineState();

//   @override
//   Widget build(BuildContext context) => const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.wifi_off_outlined, size: 64, color: Colors.grey),
//             SizedBox(height: 12),
//             Text(
//               'أنت غير متاح حالياً',
//               style: TextStyle(color: Colors.grey, fontSize: 16),
//             ),
//             Text(
//               'فعّل الحالة للاستقبال',
//               style: TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//           ],
//         ),
//       );
// }

// class _EmptyState extends StatelessWidget {
//   const _EmptyState();

//   @override
//   Widget build(BuildContext context) => const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
//             SizedBox(height: 12),
//             Text('لا توجد طلبات حالياً', style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       );
// }

// class _ErrorState extends StatelessWidget {
//   final String error;
//   final VoidCallback onRetry;
//   const _ErrorState({required this.error, required this.onRetry});

//   @override
//   Widget build(BuildContext context) => Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 12),
//             Text(
//               error,
//               style: const TextStyle(color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('إعادة المحاولة'),
//             ),
//           ],
//         ),
//       );
// }

// class _OrdersList extends StatelessWidget {
//   final List<DeliveryOrderModel> orders;
//   const _OrdersList({required this.orders});

//   @override
//   Widget build(BuildContext context) => Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
//             child: Text(
//               'طلبات بانتظار التوصيل',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () => context.read<DeliveryProvider>().loadOrders(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 itemCount: orders.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 10),
//                 itemBuilder: (_, i) => _OrderCard(order: orders[i]),
//               ),
//             ),
//           ),
//         ],
//       );
// }

// // ══════════════════════════════════════════════════════════════════════════════
// // Order Card
// // ══════════════════════════════════════════════════════════════════════════════

// class _OrderCard extends StatefulWidget {
//   final DeliveryOrderModel order;
//   const _OrderCard({required this.order});

//   @override
//   State<_OrderCard> createState() => _OrderCardState();
// }

// class _OrderCardState extends State<_OrderCard> {
//   bool _isUpdating = false;
//   Future<void> _handleDeliveryAction() async {
//     final order = widget.order;
//     // final provider = context.read<DeliveryProvider>();

//     // الطلب المؤكد → نعرض تأكيد التسليم مباشرة.
//     if (order.status == 'confirmed' || order.status == 'processing') {
//       await _confirmDelivery();
//       return;
//     }

//     if (order.status == 'delivered' || order.status == 'cancelled') {
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final o = widget.order;
//     final isDelivered = o.status == 'delivered';
//     final isCancelled = o.status == 'cancelled';
//     final isCompleted = o.status == 'delivered' || o.status == 'cancelled';

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order # + Total
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     'طلب #${o.orderNumber}',
//                     style: TextStyle(
//                       color: Colors.blue.shade700,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${o.total.toStringAsFixed(0)} ر.ي',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // Customer name
//             if (o.customerName.isNotEmpty)
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.person_outline,
//                     size: 16,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     o.customerName,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),

//             const SizedBox(height: 6),

//             // Address
//             if (o.address.isNotEmpty)
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on_outlined,
//                     size: 16,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       o.address,
//                       style: const TextStyle(color: Colors.grey, fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),

//             const SizedBox(height: 14),

//             // Status badge
//             if (isDelivered || isCancelled)
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isDelivered
//                       ? AppColors.success.withValues(alpha: 0.1)
//                       : Colors.red.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   isDelivered ? 'تم التسليم' : 'ملغي',
//                   style: TextStyle(
//                     color: isDelivered ? AppColors.success : Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             else
//               Row(
//                 children: [
//                   // Call button
//                   if (o.customerPhone.isNotEmpty)
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(Icons.phone_outlined, size: 16),
//                         label: const Text('اتصال'),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.blue.shade700,
//                           side: BorderSide(color: Colors.blue.shade700),
//                         ),
//                       ),
//                     ),
//                   if (o.customerPhone.isNotEmpty) const SizedBox(width: 10),

//                   // Deliver button
//                   // Deliver button
//                   if (!isCompleted)
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: _isUpdating ? null : _handleDeliveryAction,
//                         icon: _isUpdating
//                             ? const SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.check_circle_outline,
//                                 size: 16,
//                               ),
//                         label: Text(
//                           _isUpdating ? 'جاري...' : 'تسليم الطلب',
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.success,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _confirmDelivery() async {
//     final order = widget.order;

//     final paymentStatus = await showDialog<String>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('تأكيد تسليم الطلب'),
//           content: const Text(
//             'هل تم استلام مبلغ الطلب من العميل؟',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop('pending'),
//               child: const Text('لم يتم الدفع'),
//             ),
//             FilledButton(
//               onPressed: () => Navigator.of(context).pop('paid'),
//               child: const Text('تم الدفع'),
//             ),
//           ],
//         );
//       },
//     );

//     if (!mounted || paymentStatus == null) return;

//     setState(() => _isUpdating = true);

//     final error = await context.read<DeliveryProvider>().updateStatus(
//           orderId: order.id,
//           status: 'delivered',
//           paymentStatus: paymentStatus,
//         );

//     if (!mounted) return;

//     setState(() => _isUpdating = false);

//     if (error != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(error),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تم تسليم الطلب بنجاح ✓'),
//         backgroundColor: AppColors.success,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/delivery_order_model.dart';
import '../providers/delivery_provider.dart';

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
        context.read<DeliveryProvider>().loadOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final provider = context.watch<DeliveryProvider>();

    final activeOrders = provider.orders.where((order) {
      return order.status == 'confirmed' ||
          order.status == 'processing' ||
          order.status == 'shipped';
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              userName: user?.name ?? 'السائق',
              isOnline: _isOnline,
              activeOrdersCount: activeOrders.length,
              onOnlineChanged: (value) {
                setState(() => _isOnline = value);

                if (value) {
                  context.read<DeliveryProvider>().loadOrders();
                }
              },
            ),
            Expanded(
              child: !_isOnline
                  ? const _OfflineState()
                  : provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? _ErrorState(
                      error: provider.error!,
                      onRetry: () =>
                          context.read<DeliveryProvider>().loadOrders(),
                    )
                  : activeOrders.isEmpty
                  ? const _EmptyState()
                  : _OrdersList(orders: activeOrders),
            ),
          ],
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
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatPill(
                  'طلبات نشطة',
                  '$activeOrdersCount',
                  Icons.local_shipping_outlined,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _StatPill('التقييم', '— ★', Icons.star_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Stat
// ══════════════════════════════════════════════════════════════════════════════

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Orders
// ══════════════════════════════════════════════════════════════════════════════

class _OrdersList extends StatelessWidget {
  final List<DeliveryOrderModel> orders;

  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(
            'طلبات بانتظار التوصيل',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<DeliveryProvider>().loadOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                return _OrderCard(order: orders[i]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Order Card
// ══════════════════════════════════════════════════════════════════════════════

class _OrderCard extends StatefulWidget {
  final DeliveryOrderModel order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isUpdating = false;

  Future<void> _deliverOrder() async {
    final provider = context.read<DeliveryProvider>();

    setState(() => _isUpdating = true);

    final error = await provider.updateStatus(
      orderId: widget.order.id,
      status: 'delivered',
      paymentStatus: 'paid',
    );

    if (!mounted) return;

    setState(() => _isUpdating = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تسليم الطلب بنجاح ✓'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openDetails() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeliveryOrderDetailsModal(orderId: widget.order.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _openDetails,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'طلب #${order.orderNumber}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${order.total.toStringAsFixed(0)} ر.ي',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (order.customerName.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 17,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              if (order.address.isNotEmpty) ...[
                const SizedBox(height: 7),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _openDetails,
                      child: const Text('تفاصيل الطلب'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isUpdating ? null : _deliverOrder,
                      icon: _isUpdating
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(_isUpdating ? 'جاري...' : 'تسليم الطلب'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
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

// ══════════════════════════════════════════════════════════════════════════════
// Details Modal
// ══════════════════════════════════════════════════════════════════════════════

class _DeliveryOrderDetailsModal extends StatefulWidget {
  final String orderId;

  const _DeliveryOrderDetailsModal({required this.orderId});

  @override
  State<_DeliveryOrderDetailsModal> createState() =>
      _DeliveryOrderDetailsModalState();
}

class _DeliveryOrderDetailsModalState
    extends State<_DeliveryOrderDetailsModal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DeliveryProvider>().loadOrder(widget.orderId);
      }
    });
  }

  String _paymentStatusText(String value) {
    switch (value) {
      case 'paid':
        return 'مدفوع';
      case 'failed':
        return 'فشل الدفع';
      default:
        return 'غير مدفوع';
    }
  }

  String _paymentMethodText(String value) {
    switch (value) {
      case 'cash':
        return 'دفع نقدي';
      default:
        return value.isEmpty ? 'غير محدد' : value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryProvider>();
    final order = provider.selectedOrder;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: provider.isLoading && order == null
            ? const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              )
            : order == null
            ? SizedBox(
                height: 350,
                child: Center(
                  child: Text(provider.error ?? 'تعذر تحميل تفاصيل الطلب'),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'طلب #${order.orderNumber}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: [
                        _InfoCard(
                          title: 'العميل',
                          icon: Icons.person_outline,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerName.isNotEmpty
                                    ? order.customerName
                                    : 'غير محدد',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (order.customerPhone.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(order.customerPhone),
                              ],
                            ],
                          ),
                        ),
                        if (order.address.isNotEmpty)
                          _InfoCard(
                            title: 'عنوان التوصيل',
                            icon: Icons.location_on_outlined,
                            child: Text(order.address),
                          ),
                        _InfoCard(
                          title: 'المنتجات',
                          icon: Icons.shopping_bag_outlined,
                          child: Column(
                            children: [
                              ...order.items.map(
                                (item) => _OrderItemRow(item: item),
                              ),
                            ],
                          ),
                        ),
                        _InfoCard(
                          title: 'ملخص الطلب',
                          icon: Icons.receipt_long_outlined,
                          child: Column(
                            children: [
                              _SummaryRow('المجموع الفرعي', order.subtotal),
                              _SummaryRow('رسوم التوصيل', order.deliveryFee),
                              if (order.discount > 0)
                                _SummaryRow('الخصم', -order.discount),
                              if (order.couponDiscount > 0)
                                _SummaryRow(
                                  'خصم الكوبون',
                                  -order.couponDiscount,
                                ),
                              const Divider(height: 20),
                              _SummaryRow('الإجمالي', order.total, bold: true),
                            ],
                          ),
                        ),
                        _InfoCard(
                          title: 'الدفع',
                          icon: Icons.payments_outlined,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('طريقة الدفع'),
                                  const Spacer(),
                                  Text(
                                    _paymentMethodText(order.paymentMethod),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('حالة الدفع'),
                                  const Spacer(),
                                  Text(
                                    _paymentStatusText(order.paymentStatus),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: order.paymentStatus == 'paid'
                                          ? AppColors.success
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (order.coupon != null)
                          _InfoCard(
                            title: 'الكوبون',
                            icon: Icons.local_offer_outlined,
                            child: Row(
                              children: [
                                Text(
                                  order.coupon!.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  order.coupon!.type == 'percentage'
                                      ? '${order.coupon!.value}%'
                                      : '${order.coupon!.value} ر.ي',
                                ),
                              ],
                            ),
                          ),
                        if (order.notes != null &&
                            order.notes!.trim().isNotEmpty)
                          _InfoCard(
                            title: 'ملاحظات',
                            icon: Icons.notes_outlined,
                            child: Text(order.notes!),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: order.status == 'delivered'
                                ? null
                                : () async {
                                    final error = await provider.updateStatus(
                                      orderId: order.id,
                                      status: 'delivered',
                                      paymentStatus: 'paid',
                                    );

                                    if (!context.mounted) return;

                                    if (error != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(error),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم تسليم الطلب بنجاح ✓'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              order.status == 'delivered'
                                  ? 'تم تسليم الطلب'
                                  : 'تسليم الطلب',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Detail Widgets
// ══════════════════════════════════════════════════════════════════════════════

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 7),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final DeliveryOrderItemModel item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final name = item.product?.displayName ?? 'منتج';
    final unit = item.unit?.displayName ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.isGift
                ? Icons.card_giftcard_outlined
                : Icons.shopping_bag_outlined,
            size: 18,
            color: item.isGift ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.isGift ? '$name 🎁' : name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity} × $unit',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            item.isGift ? 'مجاني' : '${item.total.toStringAsFixed(2)} ر.ي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isGift ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;

  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final isNegative = value < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            '${value.abs().toStringAsFixed(2)} ر.ي',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: isNegative ? AppColors.success : null,
            ),
          ),
        ],
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'أنت غير متاح حالياً',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Text(
            'فعّل الحالة لاستقبال الطلبات',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'لا توجد طلبات بانتظار التوصيل',
            style: TextStyle(color: Colors.grey),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 12),
          Text(
            error,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
