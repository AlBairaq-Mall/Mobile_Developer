import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
/// إدارة العروض الخاصة على المنتجات
/// العرض يحتوي: سعر جديد أو نسبة خصم + تاريخ + صورة + متعدد المنتجات
class AdminOffersScreen extends StatefulWidget {
  const AdminOffersScreen({super.key});
  @override State<AdminOffersScreen> createState() => _AdminOffersScreenState();
}

class _AdminOffersScreenState extends State<AdminOffersScreen> {
  // TODO: GET /api/admin/offers
  final _offers = <_Offer>[
    _Offer(id:'1', title:'خصم 20% على المشروبات', discount:20, type:'percent', active:true,  start:'2026-07-01', end:'2026-07-15', productCount: 8),
    _Offer(id:'2', title:'باكت الألبان الاقتصادي', discount:500, type:'fixed',   active:false, start:'2026-07-10', end:'2026-07-20', productCount: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة العروض')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOfferDialog(context),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.local_offer_outlined),
        label: const Text('عرض جديد'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: _offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final offer = _offers[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: offer.active ? AppColors.error.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          offer.type == 'percent' ? '-${offer.discount}%' : '-${offer.discount} ر.ي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15,
                            color: offer.active ? AppColors.error : Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold))),
                      Switch(
                        value: offer.active,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _offers[i] = _Offer(
                          id: offer.id, title: offer.title, discount: offer.discount,
                          type: offer.type, active: v, start: offer.start, end: offer.end,
                          productCount: offer.productCount)),
                        // TODO: PATCH /api/admin/offers/{id}/toggle
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('${offer.start} → ${offer.end}',
                          style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.inventory_2_outlined, size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('${offer.productCount} منتج',
                          style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {}, // TODO: open product picker
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text('إضافة منتجات للعرض', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 34),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit',   child: Text('تعديل')),
                          PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOfferDialog(BuildContext context) {
    String selectedType = 'percent';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSS) => Container(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إضافة عرض جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'عنوان العرض', prefixIcon: Icon(Icons.local_offer))),
                const SizedBox(height: 12),

                // Discount type
                const Text('نوع الخصم:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _TypeChip('نسبة %', 'percent', selectedType, () => setSS(() => selectedType = 'percent')),
                    const SizedBox(width: 10),
                    _TypeChip('مبلغ ثابت', 'fixed', selectedType, () => setSS(() => selectedType = 'fixed')),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: selectedType == 'percent' ? 'نسبة الخصم (مثال: 20)' : 'مبلغ الخصم بالريال',
                    prefixIcon: const Icon(Icons.percent),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(decoration: const InputDecoration(labelText: 'تاريخ البداية'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(decoration: const InputDecoration(labelText: 'تاريخ النهاية'))),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('رفع صورة العرض'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // TODO: POST /api/admin/offers
                  },
                  child: const Text('حفظ العرض'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label, value, selected;
  final VoidCallback onTap;
  const _TypeChip(this.label, this.value, this.selected, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected == value ? AppColors.primary : Colors.transparent,
        border: Border.all(color: selected == value ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: selected == value ? Colors.white : null, fontWeight: FontWeight.bold)),
    ),
  );
}

class _Offer {
  final String id, title, type, start, end;
  final double discount;
  final bool active;
  final int productCount;
  const _Offer({required this.id, required this.title, required this.discount,
      required this.type, required this.active, required this.start,
      required this.end, required this.productCount});
}
