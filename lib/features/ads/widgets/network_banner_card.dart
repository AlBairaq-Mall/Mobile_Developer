// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../app/theme/app_radius.dart';
// import '../../../app/widgets/app_cached_image.dart';
// import '../models/ad_model.dart';

// class NetworkBannerCard extends StatelessWidget {
//   final AdModel ad;

//   const NetworkBannerCard({super.key, required this.ad});

//   Future<void> _openUrl() async {
//     if (ad.url.isEmpty) return;

//     final uri = Uri.tryParse(ad.url);

//     if (uri == null) return;

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: ad.url.isEmpty ? null : _openUrl,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(AppRadius.xl),
//         child: SizedBox.expand(
//           child: AppCachedImage(imageUrl: ad.image, fit: BoxFit.cover),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../app/theme/app_radius.dart';
// import '../../../app/widgets/app_cached_image.dart';
// import '../models/ad_model.dart';

// class NetworkBannerCard extends StatelessWidget {
//   final AdModel ad;

//   /// قيمة من 0 إلى 1:
//   /// 1 = الإعلان الحالي
//   /// أقل = إعلان جانبي
//   final double scale;

//   const NetworkBannerCard({
//     super.key,
//     required this.ad,
//     this.scale = 1,
//   });

//   Future<void> _openUrl() async {
//     if (ad.url.isEmpty) return;

//     final uri = Uri.tryParse(ad.url);
//     if (uri == null) return;

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.externalApplication,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final radius = BorderRadius.circular(AppRadius.xl);

//     return Transform.scale(
//       scale: scale,
//       child: GestureDetector(
//         onTap: ad.url.isEmpty ? null : _openUrl,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: radius,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.10),
//                 blurRadius: 18,
//                 offset: const Offset(0, 7),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: radius,
//             child: SizedBox.expand(
//               child: AppCachedImage(
//                 imageUrl: ad.image,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/widgets/app_cached_image.dart';
import '../models/ad_model.dart';

class NetworkBannerCard extends StatelessWidget {
  final AdModel ad;

  const NetworkBannerCard({super.key, required this.ad});

  Future<void> _openUrl() async {
    if (ad.url.isEmpty) return;

    final uri = Uri.tryParse(ad.url);
    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: ad.url.isEmpty ? null : _openUrl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ─────────────────────────────────────────────────────────
            // Background Image
            // ─────────────────────────────────────────────────────────
            AppCachedImage(imageUrl: ad.image, fit: BoxFit.cover),

            // ─────────────────────────────────────────────────────────
            // Dark Gradient
            // يحافظ على وضوح النص بدون تغطية الصورة بالكامل
            // ─────────────────────────────────────────────────────────
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: rtl ? Alignment.centerRight : Alignment.centerLeft,
                  end: rtl ? Alignment.centerLeft : Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.62),
                    Colors.black.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.48, 1.0],
                ),
              ),
            ),

            // ─────────────────────────────────────────────────────────
            // Content
            // ─────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Align(
                alignment: rtl ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 230),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: rtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ad.title.isNotEmpty)
                        Text(
                          ad.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: rtl ? TextAlign.right : TextAlign.left,
                          style: AppTypography.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      if (ad.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          ad.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: rtl ? TextAlign.right : TextAlign.left,
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (ad.url.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _BannerAction(rtl: rtl, onTap: _openUrl),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  final bool rtl;
  final VoidCallback onTap;

  const _BannerAction({required this.rtl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اكتشف العرض',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                rtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
