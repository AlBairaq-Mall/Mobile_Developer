// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import '../../../../core/utils/launcher_utils.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../../../core/widgets/app_message.dart';
// import '../../models/delivery_order_model.dart';
// import '../../providers/delivery_provider.dart';

// class DeliveryOrderDetailsSheet extends StatefulWidget {
//   final DeliveryOrderModel order;

//   const DeliveryOrderDetailsSheet({super.key, required this.order});

//   static void show(BuildContext context, DeliveryOrderModel order) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => DeliveryOrderDetailsSheet(order: order),
//     );
//   }

//   @override
//   State<DeliveryOrderDetailsSheet> createState() => _DeliveryOrderDetailsSheetState();
// }

// class _DeliveryOrderDetailsSheetState extends State<DeliveryOrderDetailsSheet> {
//   bool _isClaiming = false;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<DeliveryProvider>();
//     final isAvailableOrder = provider.availableOrders.any((o) => o.id == widget.order.id);

//     // We use provider's order if it was updated locally
//     final currentOrder = provider.orders.firstWhere(
//       (o) => o.id == widget.order.id,
//       orElse: () => widget.order,
//     );

//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.9,
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 12),
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'طلب #${currentOrder.orderNumber}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           currentOrder.status,
//                           style: TextStyle(
//                             color: Colors.blue.shade700,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Customer details
//                   _SectionTitle('العميل'),
//                   _InfoRow(
//                     icon: Icons.person_outline,
//                     title: currentOrder.customerName,
//                   ),
//                   if (currentOrder.customerPhone.isNotEmpty)
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _InfoRow(
//                             icon: Icons.phone_outlined,
//                             title: currentOrder.customerPhone,
//                             isPhone: true,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             Clipboard.setData(ClipboardData(text: currentOrder.customerPhone));
//                             AppMessage.success(context, 'تم نسخ الرقم');
//                           },
//                           icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             final success = await LauncherUtils.callPhone(currentOrder.customerPhone);
//                             if (!success && mounted) {
//                               AppMessage.error(context, 'لا يمكن إجراء المكالمة');
//                             }
//                           },
//                           icon: Icon(Icons.phone, size: 20, color: Colors.green.shade700),
//                         ),
//                       ],
//                     ),

//                   const SizedBox(height: 24),

//                   // Address
//                   _SectionTitle('عنوان التوصيل'),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.location_on_outlined, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           currentOrder.address,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               Clipboard.setData(ClipboardData(text: currentOrder.address));
//                               AppMessage.success(context, 'تم نسخ العنوان');
//                             },
//                             icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
//                             constraints: const BoxConstraints(),
//                             padding: const EdgeInsets.only(bottom: 8),
//                           ),
//                           if (currentOrder.location?.latitude != null &&
//                               currentOrder.location?.longitude != null)
//                             IconButton(
//                               onPressed: () async {
//                                 final success = await LauncherUtils.openMap(
//                                   currentOrder.location!.latitude!,
//                                   currentOrder.location!.longitude!,
//                                 );
//                                 if (!success && mounted) {
//                                   AppMessage.error(context, 'تعذر فتح الخرائط');
//                                 }
//                               },
//                               icon: Icon(Icons.map, size: 20, color: Colors.blue.shade700),
//                               constraints: const BoxConstraints(),
//                               padding: EdgeInsets.zero,
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   if (currentOrder.notes != null && currentOrder.notes!.isNotEmpty) ...[
//                     const SizedBox(height: 24),
//                     _SectionTitle('ملاحظات'),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               currentOrder.notes!,
//                               style: TextStyle(color: Colors.orange.shade900),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],

//                   const SizedBox(height: 24),

//                   // Payment details
//                   _SectionTitle('الدفع (${currentOrder.paymentMethod})'),
//                   _PriceRow('المجموع الفرعي', currentOrder.subtotal),
//                   _PriceRow('رسوم التوصيل', currentOrder.deliveryFee),
//                   if (currentOrder.discount > 0)
//                     _PriceRow('الخصم', -currentOrder.discount, isDiscount: true),
//                   if (currentOrder.couponDiscount > 0)
//                     _PriceRow('خصم الكوبون', -currentOrder.couponDiscount, isDiscount: true),
//                   const Divider(height: 24),
//                   _PriceRow('الإجمالي', currentOrder.total, isTotal: true),

//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       const Text('حالة الدفع: '),
//                       Text(
//                         currentOrder.paymentStatus,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: currentOrder.paymentStatus == 'paid' ? Colors.green : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),
//                   _SectionTitle('المنتجات (${currentOrder.items.length})'),
//                   ...currentOrder.items.map((item) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 32,
//                             height: 32,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               '${item.quantity}x',
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item.product?.displayName ?? 'منتج',
//                                   style: const TextStyle(fontWeight: FontWeight.w600),
//                                 ),
//                                 if (item.unit != null)
//                                   Text(
//                                     item.unit!.displayName,
//                                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           if (item.isGift)
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Colors.pink.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Text(
//                                 'هدية',
//                                 style: TextStyle(color: Colors.pink, fontSize: 12),
//                               ),
//                             )
//                           else
//                             Text('${item.total} ر.س'),
//                         ],
//                       ),
//                     );
//                   }),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),

//           // Actions
//           Container(
//             padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, -5),
//                 ),
//               ],
//             ),
//             child: isAvailableOrder
//                 ? SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isClaiming ? null : () async {
//                         setState(() => _isClaiming = true);
//                         final error = await context.read<DeliveryProvider>().claimOrder(currentOrder.id);
//                         if (!mounted) return;
//                         setState(() => _isClaiming = false);

//                         if (error != null) {
//                           AppMessage.error(context, error);
//                         } else {
//                           AppMessage.success(context, 'تم استلام الطلب للتوصيل بنجاح');
//                           Navigator.pop(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.blue.shade700,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: _isClaiming
//                           ? const AppLoading(type: AppLoadingType.bars, size: 24, color: Colors.white)
//                           : const Text('استلام الطلب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     ),
//                   )
//                 : (currentOrder.status != 'delivered' && currentOrder.status != 'cancelled')
//                     ? Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: ElevatedButton(
//                               onPressed: provider.isUpdating ? null : () {
//                                 _showPaymentStatusDialog(context, currentOrder);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                                 backgroundColor: Colors.green.shade600,
//                                 foregroundColor: Colors.white,
//                               ),
//                               child: provider.isUpdating
//                                   ? const AppLoading(type: AppLoadingType.bars, size: 24, color: Colors.white)
//                                   : const Text('تسليم الطلب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             flex: 1,
//                             child: OutlinedButton(
//                               onPressed: provider.isUpdating ? null : () {
//                                 _showCancelConfirmation(context, currentOrder);
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                                 foregroundColor: Colors.red,
//                                 side: const BorderSide(color: Colors.red),
//                               ),
//                               child: const Text('إلغاء'),
//                             ),
//                           ),
//                         ],
//                       )
//                     : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPaymentStatusDialog(BuildContext context, DeliveryOrderModel order) {
//     String selectedPaymentStatus = order.paymentStatus;
//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: const Text('تسليم الطلب'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('اختر حالة الدفع عند التسليم:'),
//               const SizedBox(height: 16),
//               RadioListTile<String>(
//                 title: const Text('غير مدفوع'),
//                 value: 'pending',
//                 groupValue: selectedPaymentStatus,
//                 onChanged: (val) => setStateDialog(() => selectedPaymentStatus = val!),
//               ),
//               RadioListTile<String>(
//                 title: const Text('مدفوع'),
//                 value: 'paid',
//                 groupValue: selectedPaymentStatus,
//                 onChanged: (val) => setStateDialog(() => selectedPaymentStatus = val!),
//               ),
//               RadioListTile<String>(
//                 title: const Text('فشل الدفع'),
//                 value: 'failed',
//                 groupValue: selectedPaymentStatus,
//                 onChanged: (val) => setStateDialog(() => selectedPaymentStatus = val!),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('تراجع', style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(ctx);
//                 final error = await context.read<DeliveryProvider>().updateStatus(
//                   orderId: order.id,
//                   status: 'delivered',
//                   paymentStatus: selectedPaymentStatus,
//                 );

//                 if (!mounted) return;

//                 if (error != null) {
//                   AppMessage.error(context, error);
//                 } else {
//                   AppMessage.success(context, 'تم تسليم الطلب بنجاح');
//                   Navigator.pop(context); // Close details sheet
//                 }
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Text('تأكيد التسليم'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCancelConfirmation(BuildContext context, DeliveryOrderModel order) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('إلغاء الطلب'),
//         content: const Text('هل أنت متأكد من إلغاء الطلب؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('تراجع', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               final error = await context.read<DeliveryProvider>().updateStatus(
//                 orderId: order.id,
//                 status: 'cancelled',
//               );

//               if (!mounted) return;

//               if (error != null) {
//                 AppMessage.error(context, error);
//               } else {
//                 AppMessage.success(context, 'تم إلغاء الطلب بنجاح');
//                 Navigator.pop(context); // Close details sheet
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('تأكيد الإلغاء'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final bool isPhone;

//   const _InfoRow({
//     required this.icon,
//     required this.title,
//     this.isPhone = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey, size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               title,
//               textDirection: isPhone ? TextDirection.ltr : null,
//               textAlign: isPhone ? TextAlign.right : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PriceRow extends StatelessWidget {
//   final String title;
//   final double amount;
//   final bool isTotal;
//   final bool isDiscount;

//   const _PriceRow(
//     this.title,
//     this.amount, {
//     this.isTotal = false,
//     this.isDiscount = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : null,
//               fontSize: isTotal ? 16 : 14,
//             ),
//           ),
//           Text(
//             '${amount.toStringAsFixed(2)} ر.س',
//             style: TextStyle(
//               fontWeight: isTotal ? FontWeight.bold : null,
//               fontSize: isTotal ? 16 : 14,
//               color: isDiscount ? Colors.red : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/launcher_utils.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/app_message.dart';
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
      builder: (_) => DeliveryOrderDetailsSheet(order: order),
    );
  }

  @override
  State<DeliveryOrderDetailsSheet> createState() =>
      _DeliveryOrderDetailsSheetState();
}

class _DeliveryOrderDetailsSheetState extends State<DeliveryOrderDetailsSheet> {
  bool _isClaiming = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryProvider>();

    final isAvailableOrder = provider.availableOrders.any(
      (o) => o.id == widget.order.id,
    );

    // Use provider's order if it was updated locally.
    final currentOrder = provider.orders.firstWhere(
      (o) => o.id == widget.order.id,
      orElse: () => widget.order,
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طلب #${currentOrder.orderNumber}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          currentOrder.status,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Customer details
                  _SectionTitle('العميل'),
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: currentOrder.customerName,
                  ),
                  if (currentOrder.customerPhone.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: _InfoRow(
                            icon: Icons.phone_outlined,
                            title: currentOrder.customerPhone,
                            isPhone: true,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: currentOrder.customerPhone,
                              ),
                            );
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
                          onPressed: () async {
                            final success = await LauncherUtils.callPhone(
                              currentOrder.customerPhone,
                            );

                            if (!context.mounted) return;

                            if (!success) {
                              AppMessage.error(
                                context,
                                'لا يمكن إجراء المكالمة',
                              );
                            }
                          },
                          icon: Icon(
                            Icons.phone,
                            size: 20,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Address
                  _SectionTitle('عنوان التوصيل'),
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
                          currentOrder.address,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: currentOrder.address,
                                ),
                              );
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
                            padding: const EdgeInsets.only(bottom: 8),
                          ),
                          if (currentOrder.location?.latitude != null &&
                              currentOrder.location?.longitude != null)
                            IconButton(
                              onPressed: () async {
                                final latitude =
                                    currentOrder.location!.latitude!;
                                final longitude =
                                    currentOrder.location!.longitude!;

                                final success = await LauncherUtils.openMap(
                                  latitude,
                                  longitude,
                                );

                                if (!context.mounted) return;

                                if (!success) {
                                  AppMessage.error(
                                    context,
                                    'تعذر فتح الخرائط',
                                  );
                                }
                              },
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

                  if (currentOrder.notes != null &&
                      currentOrder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle('ملاحظات'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentOrder.notes!,
                              style: TextStyle(
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Payment details
                  _SectionTitle(
                    'الدفع (${currentOrder.paymentMethod})',
                  ),
                  _PriceRow(
                    'المجموع الفرعي',
                    currentOrder.subtotal,
                  ),
                  _PriceRow(
                    'رسوم التوصيل',
                    currentOrder.deliveryFee,
                  ),
                  if (currentOrder.discount > 0)
                    _PriceRow(
                      'الخصم',
                      -currentOrder.discount,
                      isDiscount: true,
                    ),
                  if (currentOrder.couponDiscount > 0)
                    _PriceRow(
                      'خصم الكوبون',
                      -currentOrder.couponDiscount,
                      isDiscount: true,
                    ),
                  const Divider(height: 24),
                  _PriceRow(
                    'الإجمالي',
                    currentOrder.total,
                    isTotal: true,
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('حالة الدفع: '),
                      Text(
                        currentOrder.paymentStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: currentOrder.paymentStatus == 'paid'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _SectionTitle(
                    'المنتجات (${currentOrder.items.length})',
                  ),
                  ...currentOrder.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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
                                borderRadius: BorderRadius.circular(12),
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
                            Text('${item.total} ر.س'),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Actions
          Container(
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
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: isAvailableOrder
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isClaiming
                          ? null
                          : () async {
                              setState(() => _isClaiming = true);

                              final deliveryProvider =
                                  context.read<DeliveryProvider>();

                              final error = await deliveryProvider.claimOrder(
                                currentOrder.id,
                              );

                              if (!mounted) return;

                              setState(() => _isClaiming = false);

                              if (error != null) {
                                AppMessage.error(
                                  this.context,
                                  error,
                                );
                              } else {
                                AppMessage.success(
                                  this.context,
                                  'تم استلام الطلب للتوصيل بنجاح',
                                );
                                Navigator.pop(this.context);
                              }
                            },
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
                  )
                : (currentOrder.status != 'delivered' &&
                        currentOrder.status != 'cancelled')
                    ? Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: provider.isUpdating
                                  ? null
                                  : () {
                                      _showPaymentStatusDialog(
                                        context,
                                        currentOrder,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                              ),
                              child: provider.isUpdating
                                  ? const AppLoading(
                                      type: AppLoadingType.bars,
                                      size: 24,
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'تسليم الطلب',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: provider.isUpdating
                                  ? null
                                  : () {
                                      _showCancelConfirmation(
                                        context,
                                        currentOrder,
                                      );
                                    },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                foregroundColor: Colors.red,
                                side: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              child: const Text('إلغاء'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showPaymentStatusDialog(
    BuildContext context,
    DeliveryOrderModel order,
  ) {
    String selectedPaymentStatus = order.paymentStatus;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) => AlertDialog(
          title: const Text('تسليم الطلب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اختر حالة الدفع عند التسليم:'),
              const SizedBox(height: 16),
              RadioGroup<String>(
                groupValue: selectedPaymentStatus,
                onChanged: (value) {
                  if (value == null) return;

                  setStateDialog(
                    () => selectedPaymentStatus = value,
                  );
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('غير مدفوع'),
                      value: 'pending',
                    ),
                    RadioListTile<String>(
                      title: const Text('مدفوع'),
                      value: 'paid',
                    ),
                    RadioListTile<String>(
                      title: const Text('فشل الدفع'),
                      value: 'failed',
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'تراجع',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final deliveryProvider = context.read<DeliveryProvider>();

                final error = await deliveryProvider.updateStatus(
                  orderId: order.id,
                  status: 'delivered',
                  paymentStatus: selectedPaymentStatus,
                );

                if (!mounted) return;

                if (error != null) {
                  AppMessage.error(
                    this.context,
                    error,
                  );
                } else {
                  AppMessage.success(
                    this.context,
                    'تم تسليم الطلب بنجاح',
                  );
                  Navigator.pop(this.context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('تأكيد التسليم'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(
    BuildContext context,
    DeliveryOrderModel order,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء الطلب'),
        content: const Text('هل أنت متأكد من إلغاء الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'تراجع',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final deliveryProvider = context.read<DeliveryProvider>();

              final error = await deliveryProvider.updateStatus(
                orderId: order.id,
                status: 'cancelled',
              );

              if (!mounted) return;

              if (error != null) {
                AppMessage.error(
                  this.context,
                  error,
                );
              } else {
                AppMessage.success(
                  this.context,
                  'تم إلغاء الطلب بنجاح',
                );
                Navigator.pop(this.context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
