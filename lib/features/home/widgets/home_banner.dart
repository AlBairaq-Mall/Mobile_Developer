import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_typography.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _controller;

  int _page = 0;

  Timer? _timer;

  final banners = const [
    _BannerItem(
      title: 'خصومات حتى 40%',
      subtitle: 'أفضل العروض على آلاف المنتجات',
      button: 'تسوق الآن',
      icon: Icons.local_offer_rounded,
      colors: [
        AppColors.gradientStart,
        AppColors.gradientEnd,
      ],
    ),
    _BannerItem(
      title: 'توصيل سريع',
      subtitle: 'يصلك طلبك خلال أقل وقت ممكن',
      button: 'ابدأ الطلب',
      icon: Icons.delivery_dining_rounded,
      colors: [
        Color(0xff0EA5E9),
        Color(0xff2563EB),
      ],
    ),
    _BannerItem(
      title: 'منتجات طازجة',
      subtitle: 'خضار وفواكه يومية بجودة عالية',
      button: 'اكتشف',
      icon: Icons.eco_rounded,
      colors: [
        Color(0xff22C55E),
        Color(0xff16A34A),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: .93);

    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!_controller.hasClients) return;

        _page++;

        if (_page == banners.length) {
          _page = 0;
        }

        _controller.animateToPage(
          _page,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (v) {
              setState(() {
                _page = v;
              });
            },
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _BannerCard(item: banners[i]),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) {
              final active = i == _page;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final _BannerItem item;

  const _BannerCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: item.colors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppShadows.card,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -25,
              top: -25,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(
                              AppRadius.xl,
                            ),
                          ),
                          child: Text(
                            'عرض مميز',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          item.title,
                          style: AppTypography.headlineLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          item.subtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          onPressed: () {},
                          child: Text(item.button),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerItem {
  final String title;
  final String subtitle;
  final String button;
  final IconData icon;
  final List<Color> colors;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.button,
    required this.icon,
    required this.colors,
  });
}
