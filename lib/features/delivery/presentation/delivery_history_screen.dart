import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../models/delivery_order_model.dart';
import '../providers/delivery_provider.dart';

class DeliveryHistoryScreen extends StatefulWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  State<DeliveryHistoryScreen> createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // يستخدم نفس الـ provider — الطلبات المحملة تشمل الكل
        final provider = context.read<DeliveryProvider>();
        if (provider.orders.isEmpty && !provider.isLoading) {
          provider.loadOrders();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryProvider>();

    // نصفّي الطلبات المنتهية للعرض في السجل
    final history = provider.orders
        .where((o) => o.status == 'delivered' || o.status == 'cancelled')
        .toList();

    return Scaffold(
      appBar: const AppPageHeader(title: 'سجل التوصيل', showBack: false),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? _ErrorView(
                  error: provider.error!,
                  onRetry: () => context.read<DeliveryProvider>().loadOrders(),
                )
              : Column(
                  children: [
                    // ملخص
                    Container(
                      margin: const EdgeInsets.all(14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _SummaryItem('إجمالي الطلبات', '${history.length}'),
                          _SummaryItem(
                            'مُسلَّمة',
                            '${history.where((o) => o.status == 'delivered').length}',
                          ),
                          _SummaryItem(
                            'ملغاة',
                            '${history.where((o) => o.status == 'cancelled').length}',
                          ),
                        ],
                      ),
                    ),

                    // List
                    Expanded(
                      child: history.isEmpty
                          ? const Center(
                              child: Text(
                                'لا يوجد سجل توصيل',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  context.read<DeliveryProvider>().refresh(),
                              child: ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                itemCount: history.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (_, i) {
                                  final h = history[i];
                                  return _HistoryTile(order: h);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════

class _SummaryItem extends StatelessWidget {
  final String label, value;
  const _SummaryItem(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      );
}

class _HistoryTile extends StatelessWidget {
  final DeliveryOrderModel order;

  const _HistoryTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'delivered';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showOrderDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رقم الطلب + الحالة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#${order.orderNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDelivered
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDelivered
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          size: 15,
                          color: isDelivered ? AppColors.success : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDelivered ? 'تم التسليم' : 'ملغي',
                          style: TextStyle(
                            color: isDelivered ? AppColors.success : Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // العميل
              if (order.customerName.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        order.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

              if (order.customerName.isNotEmpty) const SizedBox(height: 7),

              // العنوان
              if (order.address.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        order.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // التاريخ + الإجمالي
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            order.createdAt ?? '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${order.total.toStringAsFixed(0)} ر.ي',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HistoryOrderDetails(order: order),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 12),
            Text(error, style: const TextStyle(color: Colors.grey)),
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

class _HistoryOrderDetails extends StatelessWidget {
  final DeliveryOrderModel order;

  const _HistoryOrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status == 'delivered';

    return Container(
      constraints: const BoxConstraints(maxHeight: 650),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'طلب #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _HistoryDetailRow(
              icon: Icons.person_outline,
              title: 'العميل',
              value: order.customerName.isNotEmpty ? order.customerName : '—',
            ),
            _HistoryDetailRow(
              icon: Icons.location_on_outlined,
              title: 'العنوان',
              value: order.address.isNotEmpty ? order.address : '—',
            ),
            _HistoryDetailRow(
              icon: Icons.access_time_rounded,
              title: 'التاريخ',
              value: order.createdAt ?? '—',
            ),
            const SizedBox(height: 10),
            const Text(
              'ملخص الطلب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product?.displayName ?? 'منتج'} × ${item.quantity}',
                      ),
                    ),
                    Text(
                      '${item.total.toStringAsFixed(0)} ر.ي',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            _HistoryTotalRow(label: 'المجموع الفرعي', value: order.subtotal),
            _HistoryTotalRow(label: 'رسوم التوصيل', value: order.deliveryFee),
            if (order.discount > 0)
              _HistoryTotalRow(
                label: 'الخصم',
                value: -order.discount,
                color: AppColors.success,
              ),
            const Divider(height: 20),
            _HistoryTotalRow(label: 'الإجمالي', value: order.total, bold: true),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.payment_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 7),
                Text(
                  'الدفع: ${order.paymentMethod == 'cash' ? 'نقدي' : order.paymentMethod}',
                ),
                const Spacer(),
                Text(
                  order.paymentStatus == 'paid' ? 'مدفوع' : 'غير مدفوع',
                  style: TextStyle(
                    color: order.paymentStatus == 'paid'
                        ? AppColors.success
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDelivered
                    ? AppColors.success.withValues(alpha: 0.08)
                    : Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isDelivered ? 'تم تسليم الطلب بنجاح' : 'تم إلغاء الطلب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDelivered ? AppColors.success : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _HistoryDetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTotalRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;
  final bool bold;

  const _HistoryTotalRow({
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(0)} ر.ي',
            style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: bold ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
