import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _controller;

  Timer? _timer;

  int _current = 0;

  bool _userDragging = false;

  final List<_BannerData> _banners = const [
    _BannerData(
        'خصومات تصل 40%',
        'اطلب الآن واستمتع بأفضل الأسعار',
        Icons.shopping_cart,
        [
          AppColors.adminGradientStart,
          AppColors.adminGradientEnd,
        ],
        iconColor: Colors.white),
    _BannerData(
      'توصيل سريع',
      'توصيل لباب البيت في أقل من ساعة',
      Icons.delivery_dining,
      [
        Color(0xFFFF6B35),
        Color(0xFFFF4081),
      ],
      iconColor: Colors.white,
    ),
    _BannerData(
      'منتجات طازجة',
      'خضار وفواكه طازجة يومياً',
      Icons.icecream,
      [
        Color(0xFF43A047),
        Color(0xFF00ACC1),
      ],
      iconColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      viewportFraction: .94,
    );

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        if (!mounted) return;

        if (_userDragging) return;

        if (!_controller.hasClients) return;

        _current++;

        if (_current >= _banners.length) {
          _current = 0;
        }

        _controller.animateToPage(
          _current,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
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
          height: 200,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _userDragging = true;
              }

              if (notification is ScrollEndNotification) {
                _userDragging = false;
              }

              return false;
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    double value = 1;

                    if (_controller.position.haveDimensions) {
                      value = _controller.page! - index;

                      value = (1 - (value.abs() * .15)).clamp(.88, 1.0);
                    }

                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: _BannerCard(
                    data: _banners[index],
                    onTap: () {
                      debugPrint(_banners[index].title);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) {
              final selected = index == _current;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: selected ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(50),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;

  final String subtitle;

  final IconData icon;

  final List<Color> colors;

  final Color iconColor;

  const _BannerData(this.title, this.subtitle, this.icon, this.colors,
      {this.iconColor = Colors.white});
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;

  final VoidCallback? onTap;

  const _BannerCard({
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: data.colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    right: -30,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    left: -35,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .18),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    'عرض حصري',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                data.title,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data.subtitle,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: .92),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton(
                                  onPressed: onTap,
                                  style: FilledButton.styleFrom(
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    backgroundColor: Colors.white,
                                    foregroundColor: data.colors.first,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'اطلب الآن',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: .95,
                            end: 1,
                          ),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutBack,
                          builder: (_, value, child) {
                            return Transform.rotate(
                              angle: sin(value * pi) * .05,
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            data.icon,
                            color: data.iconColor,
                            size: MediaQuery.sizeOf(context).width * .16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
