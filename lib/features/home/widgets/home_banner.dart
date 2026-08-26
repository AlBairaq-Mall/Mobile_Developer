
import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/design_system/components/feedback/app_loading.dart';
import 'package:provider/provider.dart';

import 'package:bhm_supermarket/app/design/app_curves.dart';
import 'package:bhm_supermarket/app/design/app_durations.dart';
import 'package:bhm_supermarket/features/ads/providers/ads_provider.dart';

import '../../ads/widgets/network_banner_card.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  late final PageController _controller;

  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: 0.94);

    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _autoScroll());
  }

  void _autoScroll() {
    if (!_controller.hasClients) return;

    final ads = context.read<AdsProvider>().ads;

    if (ads.length <= 1) return;

    final nextPage = (_page + 1) % ads.length;

    _controller.animateToPage(
      nextPage,
      duration: AppDurations.slow,
      curve: AppCurves.standard,
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
    final provider = context.watch<AdsProvider>();
    final ads = provider.ads;

    if (provider.loading) {
      return const SizedBox(
        height: 178,
        child: Center(child: AppLoading(type: AppLoadingType.dots, size: 18)),
      );
    }

    if (ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 178,
          child: PageView.builder(
            controller: _controller,
            itemCount: ads.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              if (!mounted) return;

              setState(() {
                _page = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: NetworkBannerCard(ad: ads[index]),
              );
            },
          ),
        ),

        // ─────────────────────────────────────────────────────────────
        // Indicators
        // ─────────────────────────────────────────────────────────────
        if (ads.length > 1) ...[
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(ads.length, (index) {
              final active = index == _page;

              return AnimatedContainer(
                duration: AppDurations.normal,
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: active ? 20 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
