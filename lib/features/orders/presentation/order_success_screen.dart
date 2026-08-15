import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderNumber;
  const OrderSuccessScreen({super.key, required this.orderNumber});
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl, _slideCtrl;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _slide = Tween(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _scaleCtrl.forward().then((_) => _slideCtrl.forward());
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8F8F0), Color(0xFFE3F4FB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Success animation
                  ScaleTransition(
                    scale: _scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.brand],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Text content
                  SlideTransition(
                    position: _slide,
                    child: Column(
                      children: [
                        const Text(
                          'تم استلام طلبك! 🎉',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.receipt_long_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'رقم الطلب: #${widget.orderNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'سيتم التواصل معك لتأكيد طلبك وتحديد موعد التوصيل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Steps indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ماذا يحدث الآن؟',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _Step(
                          '1',
                          'المتجر يستلم طلبك',
                          Icons.storefront_outlined,
                        ),
                        _Step(
                          '2',
                          'يتم تجهيز المنتجات',
                          Icons.inventory_2_outlined,
                        ),
                        _Step(
                          '3',
                          'التوصيل لباب بيتك',
                          Icons.delivery_dining_outlined,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.orders),
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text('تتبع الطلب'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('العودة للرئيسية'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number, label;
  final IconData icon;
  const _Step(this.number, this.label, this.icon);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}
