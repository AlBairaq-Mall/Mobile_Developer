import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_message.dart';
import '../../../core/widgets/app_dialog.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../widgets/pick_location_sheet.dart';
import '../../../core/utils/validators.dart';

class AddressManagementScreen extends StatefulWidget {
  final bool fromCheckout;
  // final PickedLocation? pickedLocation;

  const AddressManagementScreen({
    super.key,
    this.fromCheckout = false,
    // this.pickedLocation,
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
      appBar: AppPageHeader(
        title: "عناوين التوصيل",
        onBack: () {
          Navigator.of(context).pop(widget.fromCheckout);
        },
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
            return const LoadingWidget();
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final address = provider.addresses[index];

              return _AddressTile(
                address: address,
                onEdit: () {
                  _showAddressDialog(context, existing: address);
                },
                onDelete: () {
                  _confirmDelete(context, provider, address.id);
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

  Future<void> _showAddressDialog(
    BuildContext context, {
    AddressModel? existing,
  }) async {
    final pickedLocation = await showModalBottomSheet<PickedLocation>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const PickLocationSheet(),
    );

    if (!context.mounted) return;

    await _showManualForm(existing, picked: pickedLocation);
  }

  Future<void> _showManualForm(
    AddressModel? existing, {
    PickedLocation? picked,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddressFormSheet(
        existing: existing,
        fromCheckout: widget.fromCheckout,
        pickedLocation: picked,
      ),
    );

    if (!mounted) return;

    // الـ BottomSheet أُغلق بنجاح
    if (saved == true && widget.fromCheckout) {
      Navigator.of(context).pop(true);
    }
  }

  void _confirmDelete(
    BuildContext context,
    AddressProvider provider,
    String id,
  ) {
    AppDialog.confirm(
      context,
      title: 'حذف العنوان',
      message: 'هل تريد حذف هذا العنوان نهائياً؟',
      confirmText: 'حذف',
      isDanger: true,
    ).then((confirmed) async {
      if (confirmed != true || !context.mounted) return;

      final success = await provider.deleteAddress(int.parse(id));

      if (!context.mounted) return;
      if (success) {
        AppMessage.success(context, 'تم حذف العنوان بنجاح');
      } else {
        AppMessage.error(context, 'فشل حذف العنوان، حاول مرة أخرى');
      }
    });
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
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("افتراضي"),
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
                    child: const Text("تعيين افتراضي"),
                  ),
                const Spacer(),
                IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
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
  final PickedLocation? pickedLocation;

  const _AddressFormSheet({
    this.existing,
    this.fromCheckout = false,
    this.pickedLocation,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _titleCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();

  bool _isDefault = false;
  bool _isSaving = false;

  // Reserved for future Google Maps location picker integration
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();

    final e = widget.existing;

    if (e != null) {
      _titleCtrl.text = e.title;
      _streetCtrl.text = e.address;
      _isDefault = e.isDefault;
      _latitude = e.latitude;
      _longitude = e.longitude;
    }

    if (widget.pickedLocation != null) {
      _streetCtrl.text = widget.pickedLocation!.address;
      _latitude = widget.pickedLocation!.latitude;
      _longitude = widget.pickedLocation!.longitude;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _streetCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // منع الضغط المتكرر أثناء الحفظ
    if (_isSaving) {
      return;
    }

    final title = _titleCtrl.text.trim();
    final address = _streetCtrl.text.trim();

    // ─────────────────────────────────────────────────────────────
    // التحقق من اسم العنوان
    // ─────────────────────────────────────────────────────────────

    final titleError = Validators.required(
      title,
      'اسم العنوان',
    );

    if (titleError != null) {
      AppMessage.warning(context, titleError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // التحقق من طول اسم العنوان
    // ─────────────────────────────────────────────────────────────

    final titleLengthError = Validators.minLength(
      title,
      2,
      'اسم العنوان',
    );

    if (titleLengthError != null) {
      AppMessage.warning(context, titleLengthError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // التحقق من العنوان / الشارع
    // ─────────────────────────────────────────────────────────────

    final addressError = Validators.required(
      address,
      'العنوان',
    );

    if (addressError != null) {
      AppMessage.warning(context, addressError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // التحقق من طول العنوان
    // ─────────────────────────────────────────────────────────────

    final addressLengthError = Validators.minLength(
      address,
      3,
      'العنوان',
    );

    if (addressLengthError != null) {
      AppMessage.warning(context, addressLengthError);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // بدء الحفظ
    // ─────────────────────────────────────────────────────────────

    setState(() {
      _isSaving = true;
    });

    final provider = context.read<AddressProvider>();

    String? error;

    if (widget.existing == null) {
      // ───────────────────────────────────────────────────────────
      // إضافة عنوان جديد
      // ───────────────────────────────────────────────────────────

      error = await provider.addAddress(
        title: title,
        address: address,
        isDefault: _isDefault,
        latitude: _latitude,
        longitude: _longitude,
      );
    } else {
      // ───────────────────────────────────────────────────────────
      // تعديل عنوان موجود
      // ───────────────────────────────────────────────────────────

      error = await provider.editAddress(
        id: int.parse(widget.existing!.id),
        title: title,
        address: address,
        latitude: _latitude,
        longitude: _longitude,
        isDefault: _isDefault,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    // ─────────────────────────────────────────────────────────────
    // فشل الحفظ
    // ─────────────────────────────────────────────────────────────

    if (error != null) {
      AppMessage.error(
        context,
        error,
      );
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // نجاح الحفظ
    // ─────────────────────────────────────────────────────────────

    Navigator.of(context).pop(true);
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.existing == null ? "إضافة عنوان" : "تعديل عنوان",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _field("اسم العنوان", _titleCtrl),
            _field("الشارع", _streetCtrl),
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final pickedLocation =
                    await showModalBottomSheet<PickedLocation>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => const PickLocationSheet(),
                );

                if (pickedLocation == null) return;

                setState(() {
                  _latitude = pickedLocation.latitude;
                  _longitude = pickedLocation.longitude;
                  _streetCtrl.text = pickedLocation.address;
                });
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.map, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(child: Text("اختيار الموقع من الخريطة")),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
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
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const AppLoading(
                        type: AppLoadingType.bars,
                        size: 22,
                        color: Colors.white,
                      )
                    : const Text("حفظ"),
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
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
