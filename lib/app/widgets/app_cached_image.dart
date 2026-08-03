import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;

  final double? width;

  final double? height;

  final BoxFit fit;

  final double radius;

  final Widget? placeholder;

  final Widget? errorWidget;

  final Color? backgroundColor;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = AppRadius.md,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  String get _url {
    if (imageUrl.isEmpty) {
      return '';
    }

    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }

    return 'https://backend-albarqy.onrender.com/storage/$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    if (_url.isEmpty) {
      return _error();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: _url,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 250),
        fadeOutDuration: const Duration(milliseconds: 150),
        placeholder: (_, __) =>
            placeholder ??
            Container(
              color: backgroundColor ?? AppColors.background,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        errorWidget: (_, __, ___) => errorWidget ?? _error(),
      ),
    );
  }

  Widget _error() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? AppColors.background,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 42,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
