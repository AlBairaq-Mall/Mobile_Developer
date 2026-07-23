import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';

class AddressManagementScreen extends StatefulWidget {
  final bool fromCheckout;

  const AddressManagementScreen({
    super.key,
    this.fromCheckout = false,
  });

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final provider = context.read<AddressProvider>();

        if (provider.addresses.isEmpty) {
          await provider.loadAddresses();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("عناوين التوصيل"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("إضافة عنوان"),
        onPressed: () {
          _showAddressDialog(context);
        },
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.addresses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "لا يوجد أي عنوان",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "أضف عنوانك الأول لإتمام الطلب",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text("إضافة عنوان"),
                        onPressed: () {
                          _showAddressDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount: provider.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final address = provider.addresses[index];

              return _AddressTile(
                address: address,
                onEdit: () {
                  _showAddressDialog(
                    context,
                    existing: address,
                  );
                },
                onDelete: () {
                  _confirmDelete(
                    context,
                    provider,
                    address.id,
                  );
                },
                onSetDefault: () async {
                  await provider.setDefault(address.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAddressDialog(
    BuildContext context, {
    AddressModel? existing,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(
        existing: existing,
        fromCheckout: widget.fromCheckout,
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AddressProvider provider,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف العنوان"),
        content: const Text(
          "هل تريد حذف هذا العنوان؟",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              final success = await provider.deleteAddress(
                int.parse(id),
              );

              if (context.mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? "تم حذف العنوان" : "فشل حذف العنوان",
                    ),
                  ),
                );
              }
            },
            child: const Text(
              "حذف",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  final VoidCallback onSetDefault;

  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
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
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: const Text(
                      "افتراضي",
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(address.address),
            const SizedBox(height: 10),
            Row(
              children: [
                if (!address.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text(
                      "تعيين افتراضي",
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
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
  final bool fromCheckout;

  const _AddressFormSheet({
    this.existing,
    this.fromCheckout = false,
  });
  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _titleCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _isDefault = false;

  @override
  void initState() {
    super.initState();

    final e = widget.existing;

    if (e != null) {
      _titleCtrl.text = e.title;
      _streetCtrl.text = e.address;
      _isDefault = e.isDefault;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _streetCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty || _streetCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("الرجاء تعبئة جميع الحقول"),
        ),
      );
      return;
    }

    final provider = context.read<AddressProvider>();

    final address = _streetCtrl.text.trim();
    bool success;

    if (widget.existing == null) {
      success = await provider.addAddress(
        title: _titleCtrl.text.trim(),
        address: address,
        isDefault: _isDefault,
      );
    } else {
      success = await provider.editAddress(
        id: int.parse(widget.existing!.id),
        title: _titleCtrl.text.trim(),
        address: address,
        isDefault: _isDefault,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);

      if (widget.fromCheckout && mounted) {
        Navigator.of(context).pop(true);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existing == null ? 'تمت إضافة العنوان' : 'تم تحديث العنوان',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشلت العملية"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.existing == null ? "إضافة عنوان" : "تعديل عنوان",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _field(
              "اسم العنوان",
              _titleCtrl,
            ),
            _field(
              "الشارع",
              _streetCtrl,
            ),
            _field(
              "الهاتف",
              _phoneCtrl,
              type: TextInputType.phone,
            ),
            SwitchListTile(
              value: _isDefault,
              onChanged: (v) {
                setState(() {
                  _isDefault = v;
                });
              },
              title: const Text("عنوان افتراضي"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("حفظ"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
      ),
    );
  }
}
