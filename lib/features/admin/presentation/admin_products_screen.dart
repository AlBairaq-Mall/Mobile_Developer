import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../home/providers/home_provider.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});
  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final homeProv = context.watch<HomeProvider>();
    final products = homeProv.products;
    final filtered = products
        .where((p) => p.name.contains(_query) || p.itemCode.contains(_query))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'إضافة منتج',
            onPressed: () => _showProductDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'بحث بالاسم أو رمز SKU...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = filtered[i];
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                    ),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('SKU: ${p.itemCode}  •  ${p.price.toStringAsFixed(0)} ر.ي'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: p.isAvailable ? AppColors.success.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(p.isAvailable ? 'متوفر' : 'غير متوفر',
                              style: TextStyle(fontSize: 11, color: p.isAvailable ? AppColors.success : Colors.red)),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('تعديل')),
                            PopupMenuItem(value: 'units', child: Text('إدارة الوحدات')),
                            PopupMenuItem(value: 'delete', child: Text('حذف', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ProductFormSheet(),
    );
  }
}

class _ProductFormSheet extends StatelessWidget {
  const _ProductFormSheet();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('إضافة منتج جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: 'اسم المنتج', prefixIcon: Icon(Icons.label_outline))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'رمز SKU / Item Code', prefixIcon: Icon(Icons.qr_code))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'القسم', prefixIcon: Icon(Icons.category_outlined))),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'البراند', prefixIcon: Icon(Icons.branding_watermark_outlined))),
          const SizedBox(height: 20),
          // TODO: POST /api/admin/products
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('حفظ المنتج')),
        ],
      ),
    );
  }
}
