import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/launcher_utils.dart';
import '../../../../core/widgets/app_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../models/delivery_order_model.dart';
import '../../providers/delivery_provider.dart';

class DeliveryOrderDetailsSheet extends StatefulWidget {
  final DeliveryOrderModel order;

  const DeliveryOrderDetailsSheet({
    super.key,
    required this.order,
  });

  static void show(
    BuildContext context,
    DeliveryOrderModel order,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeliveryOrderDetailsSheet(
        order: order,
      ),
    );
  }

  @override
  State<DeliveryOrderDetailsSheet> createState() =>
      _DeliveryOrderDetailsSheetState();
}

class _DeliveryOrderDetailsSheetState extends State<DeliveryOrderDetailsSheet> {
  bool _isClaiming = false;
  bool _isDelivering = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryProvider>();

    final isAvailableOrder = provider.availableOrders.any(
      (order) => order.id == widget.order.id,
    );

    final currentOrder = provider.orders.firstWhere(
      (order) => order.id == widget.order.id,
      orElse: () => provider.selectedOrder?.id == widget.order.id
          ? provider.selectedOrder!
          : widget.order,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(
                    currentOrder,
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(
                    'العميل',
                  ),
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: currentOrder.customerName,
                  ),
                  if (currentOrder.customerPhone.isNotEmpty)
                    _buildPhoneRow(
                      currentOrder.customerPhone,
                    ),
                  const SizedBox(height: 24),
                  _buildAddressSection(
                    currentOrder,
                  ),
                  if (currentOrder.notes != null &&
                      currentOrder.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      'ملاحظات',
                    ),
                    _buildNotes(
                      currentOrder.notes!,
                    ),
                  ],
                  const SizedBox(height: 24),
                  _buildPaymentSection(
                    currentOrder,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(
                    'المنتجات (${currentOrder.items.length})',
                  ),
                  ...currentOrder.items.map(
                    _buildOrderItem,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          _buildBottomAction(
            provider: provider,
            order: currentOrder,
            isAvailableOrder: isAvailableOrder,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Header
  // ===========================================================================

  Widget _buildOrderHeader(
    DeliveryOrderModel order,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'طلب #${order.orderNumber}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _StatusBadge(
          status: order.status,
        ),
      ],
    );
  }

  // ===========================================================================
  // Phone
  // ===========================================================================

  Widget _buildPhoneRow(
    String phone,
  ) {
    return Row(
      children: [
        Expanded(
          child: _InfoRow(
            icon: Icons.phone_outlined,
            title: phone,
            isPhone: true,
          ),
        ),
        IconButton(
          tooltip: 'نسخ الرقم',
          onPressed: () {
            Clipboard.setData(
              ClipboardData(
                text: phone,
              ),
            );

            if (!mounted) return;

            AppMessage.success(
              context,
              'تم نسخ الرقم',
            );
          },
          icon: const Icon(
            Icons.copy,
            size: 20,
            color: Colors.grey,
          ),
        ),
        IconButton(
          tooltip: 'اتصال',
          onPressed: () => _callCustomer(phone),
          icon: Icon(
            Icons.phone,
            size: 20,
            color: Colors.green.shade700,
          ),
        ),
      ],
    );
  }

  Future<void> _callCustomer(
    String phone,
  ) async {
    final success = await LauncherUtils.callPhone(
      phone,
    );

    if (!mounted) return;

    if (!success) {
      AppMessage.error(
        context,
        'لا يمكن إجراء المكالمة',
      );
    }
  }

  // ===========================================================================
  // Address
  // ===========================================================================

  Widget _buildAddressSection(
    DeliveryOrderModel order,
  ) {
    final location = order.location;

    final hasCoordinates =
        location?.latitude != null && location?.longitude != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          'عنوان التوصيل',
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.address.isEmpty ? 'لا يوجد عنوان' : order.address,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'نسخ العنوان',
                  onPressed: order.address.isEmpty
                      ? null
                      : () {
                          Clipboard.setData(
                            ClipboardData(
                              text: order.address,
                            ),
                          );

                          if (!mounted) {
                            return;
                          }

                          AppMessage.success(
                            context,
                            'تم نسخ العنوان',
                          );
                        },
                  icon: const Icon(
                    Icons.copy,
                    size: 20,
                    color: Colors.grey,
                  ),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                ),
                if (hasCoordinates)
                  IconButton(
                    tooltip: 'فتح الخرائط',
                    onPressed: () => _openMap(
                      location!.latitude!,
                      location.longitude!,
                    ),
                    icon: Icon(
                      Icons.map,
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openMap(
    double latitude,
    double longitude,
  ) async {
    final success = await LauncherUtils.openMap(
      latitude,
      longitude,
    );

    if (!mounted) return;

    if (!success) {
      AppMessage.error(
        context,
        'تعذر فتح الخرائط',
      );
    }
  }

  // ===========================================================================
  // Notes
  // ===========================================================================

  Widget _buildNotes(
    String notes,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              notes,
              style: TextStyle(
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Payment
  // ===========================================================================

  Widget _buildPaymentSection(
    DeliveryOrderModel order,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          'الدفع (${order.paymentMethod})',
        ),
        _PriceRow(
          'المجموع الفرعي',
          order.subtotal,
        ),
        _PriceRow(
          'رسوم التوصيل',
          order.deliveryFee,
        ),
        if (order.discount > 0)
          _PriceRow(
            'الخصم',
            -order.discount,
            isDiscount: true,
          ),
        if (order.couponDiscount > 0)
          _PriceRow(
            'خصم الكوبون',
            -order.couponDiscount,
            isDiscount: true,
          ),
        const Divider(
          height: 24,
        ),
        _PriceRow(
          'الإجمالي',
          order.total,
          isTotal: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'حالة الدفع: ',
            ),
            Text(
              _paymentStatusLabel(
                order.paymentStatus,
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _paymentStatusColor(
                  order.paymentStatus,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _paymentStatusLabel(
    String status,
  ) {
    switch (status) {
      case 'paid':
        return 'مدفوع';

      case 'pending':
        return 'غير مدفوع';

      case 'failed':
        return 'فشل الدفع';

      default:
        return status.isEmpty ? 'غير محدد' : status;
    }
  }

  Color _paymentStatusColor(
    String status,
  ) {
    switch (status) {
      case 'paid':
        return Colors.green.shade700;

      case 'failed':
        return Colors.red.shade700;

      case 'pending':
      default:
        return Colors.orange.shade700;
    }
  }

  // ===========================================================================
  // Items
  // ===========================================================================

  Widget _buildOrderItem(
    DeliveryOrderItemModel item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}x',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.displayName ?? 'منتج',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.unit != null)
                  Text(
                    item.unit!.displayName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          if (item.isGift)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              child: const Text(
                'هدية',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 12,
                ),
              ),
            )
          else
            Text(
              '${item.total.toStringAsFixed(2)} ر.س',
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Bottom Action
  // ===========================================================================

  Widget _buildBottomAction({
    required DeliveryProvider provider,
    required DeliveryOrderModel order,
    required bool isAvailableOrder,
  }) {
    // Available order → claim it.
    if (isAvailableOrder) {
      return _buildClaimAction(
        order: order,
      );
    }

    // Assigned order → deliver it.
    if (order.status == 'shipped') {
      return _buildDeliverAction(
        order: order,
      );
    }

    // Delivered / cancelled / other final states.
    return const SizedBox.shrink();
  }

  // ===========================================================================
  // Claim button
  // ===========================================================================

  Widget _buildClaimAction({
    required DeliveryOrderModel order,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isClaiming
              ? null
              : () => _claimOrder(
                    order,
                  ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
          child: _isClaiming
              ? const AppLoading(
                  type: AppLoadingType.bars,
                  size: 24,
                  color: Colors.white,
                )
              : const Text(
                  'استلام الطلب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Deliver button
  // ===========================================================================

  Widget _buildDeliverAction({
    required DeliveryOrderModel order,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isDelivering
              ? null
              : () => _deliverOrder(
                    order,
                  ),
          icon: _isDelivering
              ? const SizedBox.shrink()
              : const Icon(
                  Icons.check_circle_outline,
                ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
          ),
          label: _isDelivering
              ? const AppLoading(
                  type: AppLoadingType.bars,
                  size: 24,
                  color: Colors.white,
                )
              : const Text(
                  'تم التسليم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Claim
  // ===========================================================================

  Future<void> _claimOrder(
    DeliveryOrderModel order,
  ) async {
    if (_isClaiming) return;

    setState(() {
      _isClaiming = true;
    });

    final provider = context.read<DeliveryProvider>();

    final error = await provider.claimOrder(
      order.id,
    );

    if (!mounted) return;

    setState(() {
      _isClaiming = false;
    });

    if (error != null) {
      AppMessage.error(
        context,
        error,
      );

      return;
    }

    AppMessage.success(
      context,
      'تم استلام الطلب للتوصيل بنجاح',
    );

    Navigator.of(context).pop();
  }

  // ===========================================================================
  // Deliver
  // ===========================================================================

  Future<void> _deliverOrder(
    DeliveryOrderModel order,
  ) async {
    if (_isDelivering) return;

    setState(() {
      _isDelivering = true;
    });

    final provider = context.read<DeliveryProvider>();

    final error = await provider.updateOrderStatus(
      order.id,
      status: 'delivered',
      paymentStatus: 'paid',
    );

    if (!mounted) return;

    setState(() {
      _isDelivering = false;
    });

    if (error != null) {
      AppMessage.error(
        context,
        error,
      );

      return;
    }

    AppMessage.success(
      context,
      'تم تسليم الطلب بنجاح',
    );

    Navigator.of(context).pop();
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
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          color: _foregroundColor(
            status,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _label(
    String value,
  ) {
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

  Color _backgroundColor(
    String value,
  ) {
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

  Color _foregroundColor(
    String value,
  ) {
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
// Section Title
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(
    this.title,
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

// =============================================================================
// Info Row
// =============================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isPhone;

  const _InfoRow({
    required this.icon,
    required this.title,
    this.isPhone = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              textDirection: isPhone ? TextDirection.ltr : null,
              textAlign: isPhone ? TextAlign.right : null,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Price Row
// =============================================================================

class _PriceRow extends StatelessWidget {
  final String title;
  final double amount;
  final bool isTotal;
  final bool isDiscount;

  const _PriceRow(
    this.title,
    this.amount, {
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : null,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} ر.س',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : null,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}
