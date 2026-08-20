// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:bhm_supermarket/app/design/app_curves.dart';
// import 'package:bhm_supermarket/app/design/app_durations.dart';
// import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:bhm_supermarket/app/theme/app_radius.dart';
// import 'package:bhm_supermarket/features/ads/providers/ads_provider.dart';
// import '../../ads/widgets/network_banner_card.dart';

// class HomeBanner extends StatefulWidget {
//   const HomeBanner({super.key});

//   @override
//   State<HomeBanner> createState() => _HomeBannerState();
// }

// class _HomeBannerState extends State<HomeBanner> {
//   late final PageController _controller;

//   int _page = 0;

//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();

//     _controller = PageController(viewportFraction: .92, keepPage: true);

//     _timer = Timer.periodic(const Duration(seconds: 4), (_) => _autoScroll());
//   }

//   void _autoScroll() {
//     if (!_controller.hasClients) return;

//     final ads = context.read<AdsProvider>().ads;

//     if (ads.length <= 1) return;

//     var nextPage = _page + 1;

//     if (nextPage >= ads.length) {
//       nextPage = 0;
//     }

//     _controller.animateToPage(
//       nextPage,
//       duration: AppDurations.slow,
//       curve: AppCurves.standard,
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdsProvider>();

//     if (provider.loading) {
//       return const SizedBox(
//         height: 210,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (provider.ads.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       children: [
//         SizedBox(
//           height: 210,
//           child: PageView.builder(
//             controller: _controller,
//             itemCount: provider.ads.length,
//             onPageChanged: (value) {
//               if (!mounted) return;

//               setState(() {
//                 _page = value;
//               });
//             },
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: NetworkBannerCard(ad: provider.ads[index]),
//               );
//             },
//           ),
//         ),
//         if (provider.ads.length > 1) ...[
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(provider.ads.length, (index) {
//               final active = index == _page;

//               return AnimatedContainer(
//                 duration: AppDurations.normal,
//                 margin: const EdgeInsets.symmetric(horizontal: 3),
//                 width: active ? 24 : 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: active ? AppColors.primary : AppColors.border,
//                   borderRadius: BorderRadius.circular(AppRadius.xs),
//                 ),
//               );
//             }),
//           ),
//         ],
//       ],
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:bhm_supermarket/app/design/app_curves.dart';
// import 'package:bhm_supermarket/app/design/app_durations.dart';
// import 'package:bhm_supermarket/app/theme/app_colors.dart';
// import 'package:bhm_supermarket/app/theme/app_radius.dart';
// import 'package:bhm_supermarket/features/ads/providers/ads_provider.dart';
// import '../../ads/widgets/network_banner_card.dart';

// class HomeBanner extends StatefulWidget {
//   const HomeBanner({super.key});

//   @override
//   State<HomeBanner> createState() => _HomeBannerState();
// }

// class _HomeBannerState extends State<HomeBanner> {
//   late final PageController _controller;

//   int _page = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();

//     _controller = PageController(
//       viewportFraction: 0.92,
//       keepPage: true,
//     );

//     _timer = Timer.periodic(
//       const Duration(seconds: 4),
//       (_) => _autoScroll(),
//     );
//   }

//   void _autoScroll() {
//     if (!_controller.hasClients) return;

//     final ads = context.read<AdsProvider>().ads;

//     if (ads.length <= 1) return;

//     final nextPage = (_page + 1) % ads.length;

//     _controller.animateToPage(
//       nextPage,
//       duration: AppDurations.slow,
//       curve: AppCurves.standard,
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdsProvider>();
//     final ads = provider.ads;

//     if (provider.loading) {
//       return const SizedBox(
//         height: 188,
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (ads.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           height: 188,
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (context, _) {
//               final currentPage =
//                   _controller.hasClients && _controller.page != null
//                       ? _controller.page!
//                       : _page.toDouble();

//               return PageView.builder(
//                 controller: _controller,
//                 itemCount: ads.length,
//                 physics: const BouncingScrollPhysics(),
//                 onPageChanged: (value) {
//                   if (!mounted) return;

//                   setState(() {
//                     _page = value;
//                   });
//                 },
//                 itemBuilder: (context, index) {
//                   final distance = (currentPage - index).abs();

//                   final scale =
//                       (1 - (distance * 0.055)).clamp(0.90, 1.0).toDouble();

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 5,
//                       vertical: 5,
//                     ),
//                     child: NetworkBannerCard(
//                       ad: ads[index],
//                       scale: scale,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),

//         // ─────────────────────────────────────────────────────────────
//         // Page Indicators
//         // ─────────────────────────────────────────────────────────────
//         if (ads.length > 1) ...[
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               ads.length,
//               (index) {
//                 final active = index == _page;

//                 return AnimatedContainer(
//                   duration: AppDurations.normal,
//                   curve: Curves.easeOut,
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: active ? 22 : 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: active ? AppColors.primary : AppColors.border,
//                     borderRadius: BorderRadius.circular(
//                       AppRadius.xs,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import 'package:bhm_supermarket/app/design/app_curves.dart';
import 'package:bhm_supermarket/app/design/app_durations.dart';
import 'package:bhm_supermarket/app/theme/app_colors.dart';
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
        child: Center(child: InlineLoadingWidget()),
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
                  color: active ? AppColors.primary : AppColors.border,
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
