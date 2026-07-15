import 'package:flutter/material.dart';

/// Widget موحّد لعرض الصور.
/// في Production: يستخدم CachedNetworkImage (للـ URLs من الـ API).
/// الآن: يستخدم Image.asset للبيانات التجريبية.
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit   fit;
  final double   radius;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit    = BoxFit.cover,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        width: width, height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Center(
          child: Icon(Icons.image_outlined, size: 40, color: Colors.grey),
        ),
      );
    }

    Widget img;

    // حدّد نوع الصورة: asset أو network
    if (imageUrl.startsWith('http')) {
      // TODO: في Production استبدل بـ CachedNetworkImage من package:cached_network_image
      img = Image.network(
        imageUrl,
        width: width, height: height, fit: fit,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.grey)),
        loadingBuilder: (_, child, progress) => progress == null ? child
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else {
      img = Image.asset(
        imageUrl,
        width: width, height: height, fit: fit,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.image_outlined, color: Colors.grey)),
      );
    }

    if (radius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: img,
      );
    }
    return img;
  }
}
