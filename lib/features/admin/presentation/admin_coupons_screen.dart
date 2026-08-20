import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../coupons/models/coupon_model.dart';
import '../../coupons/providers/coupon_provider.dart';

class AdminCouponsScreen extends StatefulWidget {
  const AdminCouponsScreen({super.key});

  @override
  State<AdminCouponsScreen> createState() => _AdminCouponsScreenState();
}

class _AdminCouponsScreenState extends State<AdminCouponsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CouponProvider>().loadCoupons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الكوبونات'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openCouponForm(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة كوبون'),
      ),
      body: Consumer<CouponProvider>(
        builder: (context, provider, _) {
          if (provider.loading && provider.coupons.isEmpty) {
            return const LoadingWidget();
          }

          if (provider.error != null && provider.coupons.isEmpty) {
            return _ErrorState(
              message: provider.error!,
              onRetry: provider.loadCoupons,
            );
          }

          if (provider.coupons.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: provider.coupons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coupon = provider.coupons[index];

                return _CouponCard(
                  coupon: coupon,
                  onEdit: () => _openCouponForm(coupon),
                  onDelete: () => _deleteCoupon(coupon),
                  onToggle: (value) => _toggleCoupon(coupon, value),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openCouponForm([CouponModel? coupon]) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CouponFormSheet(coupon: coupon),
    );

    if (!mounted) return;

    if (result == true) {
      await context.read<CouponProvider>().loadCoupons();
    }
  }

  Future<void> _deleteCoupon(CouponModel coupon) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف الكوبون'),
          content: Text('هل أنت متأكد من حذف الكوبون "${coupon.code}"؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final error = await context.read<CouponProvider>().deleteCoupon(coupon.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'تم حذف الكوبون بنجاح'),
        backgroundColor: error == null ? AppColors.success : Colors.red,
      ),
    );
  }

  Future<void> _toggleCoupon(CouponModel coupon, bool value) async {
    final error = await context.read<CouponProvider>().toggleCoupon(
          id: coupon.id,
          isActive: value,
        );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Coupon Card
// ═══════════════════════════════════════════════════════════════════════════

class _CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _CouponCard({
    required this.coupon,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  String _discountText() {
    if (coupon.isPercentage) {
      return '${coupon.value.toStringAsFixed(0)}%';
    }

    return '${coupon.value.toStringAsFixed(0)} ر.ي';
  }

  String _dateText(DateTime? date) {
    if (date == null) return 'غير محدد';

    final local = date.toLocal();

    return '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = coupon.isActive ? Colors.green : Colors.grey;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    coupon.code,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    coupon.isActive ? 'نشط' : 'غير نشط',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: coupon.isPercentage
                        ? Icons.percent
                        : Icons.payments_outlined,
                    label: 'الخصم',
                    value: _discountText(),
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.shopping_cart_outlined,
                    label: 'الحد الأدنى',
                    value:
                        '${coupon.minimumOrderAmount.toStringAsFixed(0)} ر.ي',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.people_outline,
                    label: 'الاستخدام',
                    value: coupon.usageLimit == 0
                        ? '${coupon.usedCount} / غير محدود'
                        : '${coupon.usedCount} / ${coupon.usageLimit}',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'الصلاحية',
                    value: _dateText(coupon.endDate),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Switch(value: coupon.isActive, onChanged: onToggle),
                const Text('تفعيل', style: TextStyle(fontSize: 13)),
                const Spacer(),
                IconButton(
                  tooltip: 'تعديل',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'حذف',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Info item
// ═══════════════════════════════════════════════════════════════════════════

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Coupon Form
// ═══════════════════════════════════════════════════════════════════════════

class _CouponFormSheet extends StatefulWidget {
  final CouponModel? coupon;

  const _CouponFormSheet({this.coupon});

  @override
  State<_CouponFormSheet> createState() => _CouponFormSheetState();
}

class _CouponFormSheetState extends State<_CouponFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _minimumController = TextEditingController();
  final _usageLimitController = TextEditingController();

  String _type = 'percentage';
  bool _isActive = true;

  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isEditing => widget.coupon != null;

  @override
  void initState() {
    super.initState();

    final coupon = widget.coupon;

    if (coupon != null) {
      _codeController.text = coupon.code;
      _valueController.text = coupon.value.toString();
      _minimumController.text = coupon.minimumOrderAmount.toString();
      _usageLimitController.text =
          coupon.usageLimit == 0 ? '' : coupon.usageLimit.toString();

      _type = coupon.type;
      _isActive = coupon.isActive;

      _startDate = coupon.startDate;
      _endDate = coupon.endDate;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _minimumController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _startDate = picked;
    });
  }

  Future<void> _pickEndDate() async {
    final initial = _endDate ?? _startDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _endDate = picked;
    });
  }

  String _dateText(DateTime? date) {
    if (date == null) return 'غير محدد';

    final local = date.toLocal();

    return '${local.year}/${local.month.toString().padLeft(2, '0')}/${local.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final value = double.parse(_valueController.text.trim());

    final minimum = double.tryParse(_minimumController.text.trim()) ?? 0;

    final usageLimit = int.tryParse(_usageLimitController.text.trim()) ?? 0;

    if (_type == 'percentage' && value > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نسبة الخصم لا يمكن أن تتجاوز 100%')),
      );
      return;
    }

    if (_endDate != null &&
        _startDate != null &&
        _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تاريخ الانتهاء يجب أن يكون بعد تاريخ البداية'),
        ),
      );
      return;
    }

    final provider = context.read<CouponProvider>();

    String? error;

    if (_isEditing) {
      error = await provider.updateCoupon(
        id: widget.coupon!.id,
        code: _codeController.text.trim().toUpperCase(),
        type: _type,
        value: value,
        minOrderAmount: minimum,
        usageLimit: usageLimit,
        startsAt: _startDate,
        expiresAt: _endDate,
        isActive: _isActive,
      );
    } else {
      error = await provider.createCoupon(
        code: _codeController.text.trim().toUpperCase(),
        type: _type,
        value: value,
        minOrderAmount: minimum,
        usageLimit: usageLimit,
        startsAt: _startDate,
        expiresAt: _endDate,
        isActive: _isActive,
      );
    }

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CouponProvider>();

    return Container(
      margin: const EdgeInsets.only(top: 40),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEditing ? 'تعديل الكوبون' : 'إضافة كوبون',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                textDirection: TextDirection.ltr,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'كود الكوبون',
                  hintText: 'WELCOME10',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل كود الكوبون';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'نوع الخصم',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'percentage',
                    child: Text('نسبة مئوية (%)'),
                  ),
                  DropdownMenuItem(
                    value: 'fixed',
                    child: Text('مبلغ ثابت (ر.ي)'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _type = value;
                  });
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText:
                      _type == 'percentage' ? 'نسبة الخصم' : 'قيمة الخصم',
                  suffixText: _type == 'percentage' ? '%' : 'ر.ي',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'أدخل قيمة الخصم';
                  }

                  final number = double.tryParse(value.trim());

                  if (number == null || number < 0) {
                    return 'أدخل قيمة صحيحة';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _minimumController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'الحد الأدنى للطلب',
                  suffixText: 'ر.ي',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  final number = double.tryParse(value.trim());

                  if (number == null || number < 0) {
                    return 'أدخل قيمة صحيحة';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _usageLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'حد الاستخدام',
                  hintText: 'اتركه فارغًا لغير محدود',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  final number = int.tryParse(value.trim());

                  if (number == null || number < 0) {
                    return 'أدخل رقمًا صحيحًا';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              _DateSelector(
                label: 'تاريخ البداية',
                value: _dateText(_startDate),
                onTap: _pickStartDate,
                onClear: _startDate == null
                    ? null
                    : () {
                        setState(() {
                          _startDate = null;
                        });
                      },
              ),
              const SizedBox(height: 10),
              _DateSelector(
                label: 'تاريخ الانتهاء',
                value: _dateText(_endDate),
                onTap: _pickEndDate,
                onClear: _endDate == null
                    ? null
                    : () {
                        setState(() {
                          _endDate = null;
                        });
                      },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                title: const Text('الكوبون نشط'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: provider.saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: provider.saving
                      ? const AppLoading(
                          type: AppLoadingType.bars,
                          size: 22,
                          color: Colors.white,
                        )
                      : Text(_isEditing ? 'حفظ التعديلات' : 'إنشاء الكوبون'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Date selector
// ═══════════════════════════════════════════════════════════════════════════

class _DateSelector extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DateSelector({
    required this.label,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: onClear == null
              ? const Icon(Icons.calendar_today_outlined)
              : IconButton(onPressed: onClear, icon: const Icon(Icons.close)),
        ),
        child: Text(value),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Empty / Error
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.discount_outlined, size: 70, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'لا توجد كوبونات',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
