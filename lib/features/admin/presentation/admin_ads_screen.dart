// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// import '../../../app/theme/app_colors.dart';
// import '../../../app/theme/app_radius.dart';
// import '../../../app/widgets/app_cached_image.dart';
// import '../../../core/widgets/app_page_header.dart';
// import '../../../core/widgets/empty_state.dart';
// import '../../ads/models/ad_model.dart';
// import '../../ads/providers/ads_provider.dart';

// /// إدارة الإعلانات - بانرات الصفحة الرئيسية.
// class AdminAdsScreen extends StatefulWidget {
//   const AdminAdsScreen({super.key});

//   @override
//   State<AdminAdsScreen> createState() => _AdminAdsScreenState();
// }

// class _AdminAdsScreenState extends State<AdminAdsScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   String _statusFilter = 'all';

//   @override
//   void initState() {
//     super.initState();

//     // AdsProvider يقوم بالتحميل عند الإنشاء.
//     // لا نحتاج لاستدعاء load() هنا.
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   bool? get _isActiveFilter {
//     switch (_statusFilter) {
//       case 'active':
//         return true;
//       case 'inactive':
//         return false;
//       default:
//         return null;
//     }
//   }

//   Future<void> _search() async {
//     await context.read<AdsProvider>().load(
//           search: _searchController.text.trim(),
//           isActive: _isActiveFilter,
//         );
//   }

//   Future<void> _refresh() async {
//     await context.read<AdsProvider>().load(
//           search: _searchController.text.trim(),
//           isActive: _isActiveFilter,
//         );
//   }

//   void _changeFilter(String value) {
//     setState(() {
//       _statusFilter = value;
//     });

//     context.read<AdsProvider>().load(
//           search: _searchController.text.trim(),
//           isActive: _isActiveFilter,
//         );
//   }

//   Future<void> _showAdDialog([AdModel? ad]) async {
//     await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       useSafeArea: true,
//       builder: (_) => _AdFormSheet(ad: ad),
//     );
//   }

//   Future<void> _deleteAd(AdModel ad) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('حذف الإعلان'),
//           content: Text(
//             'هل أنت متأكد من حذف إعلان "${ad.title}"؟',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext, false),
//               child: const Text('إلغاء'),
//             ),
//             FilledButton(
//               style: FilledButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () => Navigator.pop(dialogContext, true),
//               child: const Text('حذف'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmed != true || !mounted) return;

//     final provider = context.read<AdsProvider>();

//     final success = await provider.deleteAd(ad.id);

//     if (!mounted) return;

//     if (success) {
//       _showMessage('تم حذف الإعلان بنجاح');
//     } else {
//       _showMessage(
//         provider.error ?? 'تعذر حذف الإعلان',
//         error: true,
//       );
//     }
//   }

//   Future<void> _toggleAd(AdModel ad, bool value) async {
//     final provider = context.read<AdsProvider>();

//     final success = await provider.updateAd(
//       id: ad.id,
//       isActive: value,
//     );

//     if (!mounted) return;

//     if (success) {
//       _showMessage(
//         value ? 'تم تفعيل الإعلان' : 'تم تعطيل الإعلان',
//       );
//     } else {
//       _showMessage(
//         provider.error ?? 'تعذر تحديث حالة الإعلان',
//         error: true,
//       );
//     }
//   }

//   void _showMessage(
//     String message, {
//     bool error = false,
//   }) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: error ? Colors.red : null,
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdsProvider>();

//     return Scaffold(
//       appBar: const AppPageHeader(
//         title: 'إدارة الإعلانات',
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: provider.saving ? null : () => _showAdDialog(),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         icon: const Icon(Icons.add),
//         label: const Text('إعلان جديد'),
//       ),
//       body: Column(
//         children: [
//           _buildSearchAndFilters(),
//           Expanded(
//             child: _buildBody(provider),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchAndFilters() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         14,
//         14,
//         14,
//         8,
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: _searchController,
//             textInputAction: TextInputAction.search,
//             onSubmitted: (_) => _search(),
//             decoration: InputDecoration(
//               hintText: 'ابحث عن إعلان...',
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: _searchController.text.isNotEmpty
//                   ? IconButton(
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {});
//                         _search();
//                       },
//                       icon: const Icon(Icons.clear),
//                     )
//                   : null,
//               filled: true,
//               fillColor: Colors.grey.withValues(
//                 alpha: .07,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(
//                   AppRadius.md,
//                 ),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             onChanged: (_) {
//               setState(() {});
//             },
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: 42,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: [
//                 _FilterChip(
//                   label: 'الكل',
//                   selected: _statusFilter == 'all',
//                   onTap: () => _changeFilter('all'),
//                 ),
//                 const SizedBox(width: 8),
//                 _FilterChip(
//                   label: 'النشطة',
//                   selected: _statusFilter == 'active',
//                   onTap: () => _changeFilter('active'),
//                 ),
//                 const SizedBox(width: 8),
//                 _FilterChip(
//                   label: 'غير النشطة',
//                   selected: _statusFilter == 'inactive',
//                   onTap: () => _changeFilter('inactive'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody(AdsProvider provider) {
//     if (provider.loading && provider.ads.isEmpty) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (provider.error != null && provider.ads.isEmpty) {
//       return _buildError(provider);
//     }

//     if (provider.ads.isEmpty) {
//       return _buildEmpty();
//     }

//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: ListView.separated(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.fromLTRB(
//           14,
//           8,
//           14,
//           100,
//         ),
//         itemCount: provider.ads.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 10),
//         itemBuilder: (_, index) {
//           final ad = provider.ads[index];

//           return _AdCard(
//             ad: ad,
//             onEdit: () => _showAdDialog(ad),
//             onDelete: () => _deleteAd(ad),
//             onToggle: (value) => _toggleAd(
//               ad,
//               value,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildError(AdsProvider provider) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 60,
//               color: Colors.redAccent,
//             ),
//             const SizedBox(height: 14),
//             Text(
//               provider.error ?? 'حدث خطأ',
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 18),
//             ElevatedButton.icon(
//               onPressed: _refresh,
//               icon: const Icon(Icons.refresh),
//               label: const Text('إعادة المحاولة'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmpty() {
//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           const SizedBox(height: 100),
//           EmptyState(
//             emoji: '📢',
//             title: 'لا توجد إعلانات',
//             subtitle: 'أضف أول إعلان ليظهر هنا.',
//             actionLabel: 'إضافة إعلان',
//             onAction: () => _showAdDialog(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Widget _buildError(AdsProvider provider) {
// //   return ErrorState(
// //     message: provider.error ?? 'حدث خطأ أثناء تحميل الإعلانات',
// //     onRetry: _refresh,
// //   );
// // }
// // ═════════════════════════════════════════════════════════════
// // Ad Card
// // ═════════════════════════════════════════════════════════════

// class _AdCard extends StatelessWidget {
//   final AdModel ad;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final ValueChanged<bool> onToggle;

//   const _AdCard({
//     required this.ad,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: [
//           _buildImage(),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         ad.title.isEmpty ? 'بدون عنوان' : ad.title,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     _StatusBadge(
//                       active: ad.isActive,
//                     ),
//                   ],
//                 ),
//                 if (ad.description.isNotEmpty) ...[
//                   const SizedBox(height: 6),
//                   Text(
//                     ad.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.swap_vert,
//                       size: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'الترتيب: ${ad.sortOrder}',
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const Spacer(),
//                     if (ad.url.isNotEmpty) ...[
//                       const Icon(
//                         Icons.link,
//                         size: 16,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 4),
//                       const Text(
//                         'رابط',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 const Divider(height: 24),
//                 Row(
//                   children: [
//                     const Text(
//                       'نشط',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Switch(
//                       value: ad.isActive,
//                       activeThumbColor: AppColors.primary,
//                       onChanged: onToggle,
//                     ),
//                     const Spacer(),
//                     IconButton(
//                       tooltip: 'تعديل',
//                       onPressed: onEdit,
//                       icon: const Icon(
//                         Icons.edit_outlined,
//                       ),
//                     ),
//                     IconButton(
//                       tooltip: 'حذف',
//                       onPressed: onDelete,
//                       color: Colors.red,
//                       icon: const Icon(
//                         Icons.delete_outline,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImage() {
//     if (ad.image.isEmpty) {
//       return Container(
//         height: 160,
//         width: double.infinity,
//         color: Colors.grey.withValues(
//           alpha: .08,
//         ),
//         child: const Center(
//           child: Icon(
//             Icons.image_outlined,
//             size: 55,
//             color: Colors.grey,
//           ),
//         ),
//       );
//     }

//     return SizedBox(
//       height: 160,
//       width: double.infinity,
//       child: AppCachedImage(
//         imageUrl: ad.image,
//         fit: BoxFit.cover,
//         radius: 0,
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Status Badge
// // ═════════════════════════════════════════════════════════════

// class _StatusBadge extends StatelessWidget {
//   final bool active;

//   const _StatusBadge({
//     required this.active,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = active ? AppColors.primary : Colors.grey;

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 5,
//       ),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: .1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         active ? 'نشط' : 'غير نشط',
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Filter Chip
// // ═════════════════════════════════════════════════════════════

// class _FilterChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _FilterChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(
//           milliseconds: 180,
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 18,
//           vertical: 9,
//         ),
//         decoration: BoxDecoration(
//           color: selected
//               ? AppColors.primary
//               : Colors.grey.withValues(
//                   alpha: .08,
//                 ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : null,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // Ad Form
// // ═════════════════════════════════════════════════════════════

// class _AdFormSheet extends StatefulWidget {
//   final AdModel? ad;

//   const _AdFormSheet({
//     this.ad,
//   });

//   @override
//   State<_AdFormSheet> createState() => _AdFormSheetState();
// }

// class _AdFormSheetState extends State<_AdFormSheet> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _titleArController;
//   late final TextEditingController _titleEnController;

//   late final TextEditingController _descriptionArController;

//   late final TextEditingController _descriptionEnController;

//   late final TextEditingController _urlController;

//   late final TextEditingController _sortOrderController;

//   final ImagePicker _imagePicker = ImagePicker();

//   XFile? _selectedImage;

//   late bool _isActive;

//   bool get _isEditing => widget.ad != null;

//   @override
//   void initState() {
//     super.initState();

//     final ad = widget.ad;

//     _titleArController = TextEditingController(
//       text: ad?.titleAr ?? '',
//     );

//     _titleEnController = TextEditingController(
//       text: ad?.titleEn ?? '',
//     );

//     _descriptionArController = TextEditingController(
//       text: ad?.descriptionAr ?? '',
//     );

//     _descriptionEnController = TextEditingController(
//       text: ad?.descriptionEn ?? '',
//     );

//     _urlController = TextEditingController(
//       text: ad?.url ?? '',
//     );

//     _sortOrderController = TextEditingController(
//       text: ad?.sortOrder.toString() ?? '0',
//     );

//     _isActive = ad?.isActive ?? true;
//   }

//   @override
//   void dispose() {
//     _titleArController.dispose();
//     _titleEnController.dispose();
//     _descriptionArController.dispose();
//     _descriptionEnController.dispose();
//     _urlController.dispose();
//     _sortOrderController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final image = await _imagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );

//     if (image == null || !mounted) return;

//     setState(() {
//       _selectedImage = image;
//     });
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     if (!_isEditing && _selectedImage == null) {
//       _showError(
//         'صورة الإعلان مطلوبة',
//       );
//       return;
//     }

//     final provider = context.read<AdsProvider>();

//     final sortOrder = int.tryParse(
//           _sortOrderController.text.trim(),
//         ) ??
//         0;

//     bool success;

//     if (_isEditing) {
//       success = await provider.updateAd(
//         id: widget.ad!.id,
//         titleAr: _titleArController.text.trim(),
//         titleEn: _titleEnController.text.trim(),
//         descriptionAr: _descriptionArController.text.trim(),
//         descriptionEn: _descriptionEnController.text.trim(),
//         imagePath: _selectedImage?.path,
//         url: _urlController.text.trim(),
//         isActive: _isActive,
//         sortOrder: sortOrder,
//       );
//     } else {
//       success = await provider.createAd(
//         titleAr: _titleArController.text.trim(),
//         titleEn: _titleEnController.text.trim(),
//         descriptionAr: _descriptionArController.text.trim(),
//         descriptionEn: _descriptionEnController.text.trim(),
//         imagePath: _selectedImage!.path,
//         url: _urlController.text.trim(),
//         isActive: _isActive,
//         sortOrder: sortOrder,
//       );
//     }

//     if (!mounted) return;

//     if (success) {
//       Navigator.of(context).pop(true);

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           SnackBar(
//             content: Text(
//               _isEditing ? 'تم تعديل الإعلان بنجاح' : 'تم إنشاء الإعلان بنجاح',
//             ),
//           ),
//         );
//     } else {
//       _showError(
//         provider.error ?? 'تعذر حفظ الإعلان',
//       );
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//         ),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdsProvider>();

//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         height: MediaQuery.sizeOf(context).height * .92,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: const BorderRadius.vertical(
//             top: Radius.circular(28),
//           ),
//         ),
//         child: Column(
//           children: [
//             _buildHandle(),
//             _buildHeader(),
//             Expanded(
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(
//                     20,
//                     0,
//                     20,
//                     30,
//                   ),
//                   children: [
//                     _buildImagePicker(),
//                     const SizedBox(height: 20),
//                     _buildSectionTitle(
//                       'العنوان',
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _titleArController,
//                       textDirection: TextDirection.rtl,
//                       decoration: const InputDecoration(
//                         labelText: 'العنوان بالعربي',
//                         prefixIcon: Icon(Icons.title),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _titleEnController,
//                       decoration: const InputDecoration(
//                         labelText: 'Title in English',
//                         prefixIcon: Icon(Icons.title),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildSectionTitle(
//                       'الوصف',
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _descriptionArController,
//                       maxLines: 3,
//                       textDirection: TextDirection.rtl,
//                       decoration: const InputDecoration(
//                         labelText: 'الوصف بالعربي',
//                         prefixIcon: Icon(
//                           Icons.description_outlined,
//                         ),
//                         alignLabelWithHint: true,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _descriptionEnController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: 'Description in English',
//                         prefixIcon: Icon(
//                           Icons.description_outlined,
//                         ),
//                         alignLabelWithHint: true,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildSectionTitle(
//                       'الرابط والترتيب',
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: _urlController,
//                       keyboardType: TextInputType.url,
//                       decoration: const InputDecoration(
//                         labelText: 'رابط الإعلان (اختياري)',
//                         hintText: 'https://example.com',
//                         prefixIcon: Icon(Icons.link),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _sortOrderController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'ترتيب الإعلان',
//                         hintText: '0',
//                         prefixIcon: Icon(Icons.sort),
//                       ),
//                       validator: (value) {
//                         final number = int.tryParse(
//                           value?.trim() ?? '',
//                         );

//                         if (number == null || number < 0) {
//                           return 'أدخل رقمًا صحيحًا أكبر من أو يساوي 0';
//                         }

//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 18),
//                     _buildActiveSwitch(),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       height: 52,
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: provider.saving ? null : _submit,
//                         icon: provider.saving
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Icon(
//                                 Icons.save_outlined,
//                               ),
//                         label: Text(
//                           provider.saving
//                               ? 'جاري الحفظ...'
//                               : _isEditing
//                                   ? 'حفظ التعديلات'
//                                   : 'إنشاء الإعلان',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHandle() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Container(
//         width: 44,
//         height: 5,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade400,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         18,
//         12,
//         10,
//         12,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               _isEditing ? 'تعديل الإعلان' : 'إضافة إعلان جديد',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () => Navigator.of(context).pop(),
//             icon: const Icon(Icons.close),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(
//     String title,
//   ) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 15,
//       ),
//     );
//   }

//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle(
//           'صورة الإعلان',
//         ),
//         const SizedBox(height: 10),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Container(
//             width: double.infinity,
//             height: 190,
//             decoration: BoxDecoration(
//               color: Colors.grey.withValues(
//                 alpha: .06,
//               ),
//               borderRadius: BorderRadius.circular(
//                 18,
//               ),
//               border: Border.all(
//                 color: Colors.grey.withValues(alpha: .18),
//               ),
//             ),
//             clipBehavior: Clip.antiAlias,
//             child: _buildImagePreview(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: _pickImage,
//             icon: const Icon(
//               Icons.image_outlined,
//             ),
//             label: Text(
//               _selectedImage != null ? 'تغيير الصورة' : 'اختيار صورة',
//             ),
//           ),
//         ),
//         if (!_isEditing) ...[
//           const SizedBox(height: 4),
//           const Text(
//             'الصورة مطلوبة — JPG, JPEG, PNG أو WEBP، بحد أقصى 2MB.',
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildImagePreview() {
//     // صورة جديدة مختارة من الجهاز.
//     if (_selectedImage != null) {
//       return Image.file(
//         File(_selectedImage!.path),
//         width: double.infinity,
//         height: double.infinity,
//         fit: BoxFit.cover,
//       );
//     }

//     // الصورة الحالية عند تعديل إعلان.
//     if (_isEditing && widget.ad!.image.isNotEmpty) {
//       return AppCachedImage(
//         imageUrl: widget.ad!.image,
//         fit: BoxFit.cover,
//         radius: 0,
//       );
//     }

//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.add_photo_alternate_outlined,
//           size: 55,
//           color: Colors.grey,
//         ),
//         SizedBox(height: 10),
//         Text(
//           'اضغط لاختيار صورة الإعلان',
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActiveSwitch() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 14,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.grey.withValues(
//           alpha: .06,
//         ),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withValues(alpha: .1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               _isActive
//                   ? Icons.visibility_outlined
//                   : Icons.visibility_off_outlined,
//               color: AppColors.primary,
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'الإعلان نشط',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'سيظهر الإعلان للزبائن عند تفعيله',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch(
//             value: _isActive,
//             activeThumbColor: AppColors.primary,
//             onChanged: (value) {
//               setState(() {
//                 _isActive = value;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
