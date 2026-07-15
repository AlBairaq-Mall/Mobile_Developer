import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Shimmer/Skeleton Loading - يعطي انطباعاً أن البيانات تُحمَّل بدلاً من دائرة التحميل.
/// يُستخدم بدلاً من CircularProgressIndicator في كل صفحة تجلب بيانات.
class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerWidget({
    super.key,
    this.width  = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _anim;

  @override
  void initState() {
    super.initState();
    // تأكد من dispose() لمنع Memory Leak
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose(); // إلزامي لمنع Memory Leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base   = isDark ? const Color(0xFF2D333B) : const Color(0xFFE8ECF0);
    final shine  = isDark ? const Color(0xFF3D444D) : const Color(0xFFF0F4F8);

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end:   Alignment(_anim.value,     0),
            colors: [base, shine, base],
          ),
        ),
      ),
    );
  }
}

/// Shimmer لبطاقة المنتج
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerWidget(height: 120, radius: 14),
            SizedBox(height: 10),
            ShimmerWidget(height: 14),
            SizedBox(height: 6),
            ShimmerWidget(width: 80, height: 12),
            SizedBox(height: 10),
            ShimmerWidget(height: 16, width: 60),
          ],
        ),
      ),
    );
  }
}

/// Shimmer Grid لصفحة المنتجات
class ProductGridShimmer extends StatelessWidget {
  final int count;
  const ProductGridShimmer({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}

/// Shimmer لبطاقة الطلب
class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerWidget(width: 120, height: 16),
            SizedBox(height: 8),
            ShimmerWidget(height: 12),
            SizedBox(height: 6),
            ShimmerWidget(width: 80, height: 12),
          ],
        ),
      ),
    );
  }
}
