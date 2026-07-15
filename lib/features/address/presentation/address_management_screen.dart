import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';

/// شاشة إدارة العناوين (الصفحة رقم 14 في الوثيقة).
/// تتيح إضافة وتعديل وحذف وتحديد عنوان التوصيل الافتراضي.
class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عناوين التوصيل')),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('إضافة عنوان'),
      ),

      body: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.addresses.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('لا توجد عناوين محفوظة', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final address = provider.addresses[index];
              return _AddressTile(
                address: address,
                onSetDefault: () => provider.setDefault(address.id),
                onEdit: () => _showAddressDialog(context, existing: address),
                onDelete: () => _confirmDelete(context, provider, address.id),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل تريد حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteAddress(id);
              Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, {AddressModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(existing: existing),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressTile({
    required this.address,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  address.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'افتراضي',
                      style: TextStyle(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${address.city} - ${address.district} - ${address.street}'),
            Text('هاتف: ${address.phone}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!address.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('تعيين كافتراضي'),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'تعديل',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'حذف',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final AddressModel? existing;

  const _AddressFormSheet({this.existing});

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _titleCtrl    = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _streetCtrl   = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _titleCtrl.text    = e.title;
      _cityCtrl.text     = e.city;
      _districtCtrl.text = e.district;
      _streetCtrl.text   = e.street;
      _phoneCtrl.text    = e.phone;
      _isDefault         = e.isDefault;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _cityCtrl.dispose();
    _districtCtrl.dispose(); _streetCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleCtrl.text.isEmpty || _cityCtrl.text.isEmpty ||
        _districtCtrl.text.isEmpty || _streetCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')));
      return;
    }

    final provider = context.read<AddressProvider>();
    final address = AddressModel(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title:    _titleCtrl.text.trim(),
      city:     _cityCtrl.text.trim(),
      district: _districtCtrl.text.trim(),
      street:   _streetCtrl.text.trim(),
      phone:    _phoneCtrl.text.trim(),
      isDefault: _isDefault,
    );

    if (widget.existing != null) {
      provider.editAddress(widget.existing!.id, address);
    } else {
      provider.addAddress(address);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.existing == null ? 'إضافة عنوان' : 'تعديل العنوان',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _field('اسم العنوان (مثل: المنزل)', _titleCtrl),
            _field('المدينة', _cityCtrl),
            _field('الحي / المنطقة', _districtCtrl),
            _field('الشارع', _streetCtrl),
            _field('رقم الهاتف', _phoneCtrl, type: TextInputType.phone),
            SwitchListTile(
              value: _isDefault,
              contentPadding: EdgeInsets.zero,
              onChanged: (v) => setState(() => _isDefault = v),
              title: const Text('تعيين كعنوان افتراضي'),
              activeColor: AppColors.primary,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('حفظ', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
