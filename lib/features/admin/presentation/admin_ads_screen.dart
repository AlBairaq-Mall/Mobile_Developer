import 'package:flutter/material.dart';
import '../../../app/widgets/app_back_button.dart';
import '../../../app/theme/app_colors.dart';

/// إدارة الإعلانات - بانرات الصفحة الرئيسية
class AdminAdsScreen extends StatefulWidget {
  const AdminAdsScreen({super.key});
  @override
  State<AdminAdsScreen> createState() => _AdminAdsScreenState();
}

class _AdminAdsScreenState extends State<AdminAdsScreen> {
  // TODO: GET /api/admin/ads
  final _ads = <_AdItem>[
    _AdItem(
        id: '1',
        title: 'خصم رمضان 30%',
        desc: 'جميع المشروبات',
        active: true,
        start: '2026-07-01',
        end: '2026-07-30'),
    _AdItem(
        id: '2',
        title: 'عروض الصيف',
        desc: 'منتجات الألبان',
        active: false,
        start: '2026-08-01',
        end: '2026-08-31'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('إدارة الإعلانات'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('إعلان جديد'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: _ads.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final ad = _ads[i];
          return Card(
            child: Material(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ad.active
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.campaign_outlined,
                      color: ad.active ? AppColors.primary : Colors.grey),
                ),
                title: Text(ad.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${ad.desc}  •  ${ad.start} → ${ad.end}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: ad.active,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) {
                        setState(() => _ads[i] = _AdItem(
                            id: ad.id,
                            title: ad.title,
                            desc: ad.desc,
                            active: v,
                            start: ad.start,
                            end: ad.end));
                        // TODO: PATCH /api/admin/ads/{id}/toggle
                      },
                    ),
                    PopupMenuButton<String>(
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('تعديل')),
                        PopupMenuItem(
                            value: 'delete',
                            child: Text('حذف',
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAdDialog(BuildContext context, [_AdItem? ad]) {
    final titleCtrl = TextEditingController(text: ad?.title);
    final descCtrl = TextEditingController(text: ad?.desc);
    // dispose will be called in _AdDialogSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
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
            Text(ad == null ? 'إضافة إعلان' : 'تعديل الإعلان',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                    labelText: 'عنوان الإعلان', prefixIcon: Icon(Icons.title))),
            const SizedBox(height: 12),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                    labelText: 'الوصف',
                    prefixIcon: Icon(Icons.description_outlined))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        decoration: const InputDecoration(
                            labelText: 'تاريخ البداية',
                            prefixIcon: Icon(Icons.calendar_today)))),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        decoration: const InputDecoration(
                            labelText: 'تاريخ النهاية',
                            prefixIcon: Icon(Icons.event)))),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {}, // TODO: Image picker + upload to /api/upload
              icon: const Icon(Icons.image_outlined),
              label: const Text('رفع صورة الإعلان'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: POST /api/admin/ads or PATCH /api/admin/ads/{id}
              },
              child: const Text('حفظ الإعلان'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdItem {
  final String id, title, desc, start, end;
  final bool active;
  const _AdItem(
      {required this.id,
      required this.title,
      required this.desc,
      required this.active,
      required this.start,
      required this.end});
}
