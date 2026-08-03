import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String image;

  final double? width;

  final double? height;

  final BoxFit fit;

  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final child = CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Container(
        color: AppColors.background,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.background,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textHint,
        ),
      ),
    );

    if (borderRadius == null) return child;

    return ClipRRect(
      borderRadius: borderRadius!,
      child: child,
    );
  }
}
