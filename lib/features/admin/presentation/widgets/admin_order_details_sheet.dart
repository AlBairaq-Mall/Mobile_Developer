import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_message.dart';
import '../../../delivery/models/delivery_order_model.dart';
import '../../providers/admin_orders_provider.dart';
import 'admin_driver_picker_sheet.dart';

class AdminOrderDetailsSheet extends StatelessWidget {
  final DeliveryOrderModel order;
  const AdminOrderDetailsSheet({super.key, required this.order});

  static Future<void> show(BuildContext context, DeliveryOrderModel order) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminOrderDetailsSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCustomerSection(),
                  const Divider(height: 24),
                  _buildDriverSection(context),
                  const Divider(height: 24),
                  _buildProductsList(),
                  const Divider(height: 24),
                  _buildTotals(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '#${order.orderNumber}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                order.status,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildCustomerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'معلومات العميل',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.person_rounded, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(child: Text(order.customerName)),
          ],
        ),
        const SizedBox(height: 8),
        if (order.customerPhone.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.phone_rounded, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(child: Text(order.customerPhone)),
            ],
          ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 20,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(order.address)),
          ],
        ),
      ],
    );
  }

  Widget _buildDriverSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'عامل التوصيل',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton(
              onPressed: () async {
                final driverId = await AdminDriverPickerSheet.show(context);
                if (driverId != null && context.mounted) {
                  final error = await context
                      .read<AdminOrdersProvider>()
                      .assignDriver(order.id, driverId);

                  if (error != null && context.mounted) {
                    AppMessage.error(context, error);
                  } else if (context.mounted) {
                    AppMessage.success(context, 'تم تعيين السائق بنجاح');
                    Navigator.pop(context); // Close the details sheet so it reloads cleanly
                  }
                }
              },
              child: Text(order.deliveryDriver == null ? 'تعيين' : 'تغيير'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (order.deliveryDriver == null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'لم يتم تعيين سائق',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.delivery_dining, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.deliveryDriver!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (order.deliveryDriver!.phone != null)
                    Text(
                      order.deliveryDriver!.phone!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildProductsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المنتجات',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...order.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  '${item.quantity}x',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${item.product?.displayName ?? "منتج"} - ${item.unit?.displayName ?? ""}'),
                ),
                Text(
                  '${item.total.toStringAsFixed(0)} ر.ي',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotals() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTotalRow('المجموع', order.subtotal),
          const SizedBox(height: 4),
          _buildTotalRow('التوصيل', order.deliveryFee),
          if (order.couponDiscount > 0) ...[
            const SizedBox(height: 4),
            _buildTotalRow(
              'الخصم (كوبون)',
              -order.couponDiscount,
              isDiscount: true,
            ),
          ],
          const Divider(),
          _buildTotalRow('الإجمالي', order.total, isGrand: true),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('حالة الدفع'),
              Text(
                order.paymentStatus,
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
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isGrand = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isGrand ? FontWeight.bold : FontWeight.normal,
            fontSize: isGrand ? 16 : 14,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(0)} ر.ي',
          style: TextStyle(
            fontWeight: isGrand ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.red : null,
            fontSize: isGrand ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
