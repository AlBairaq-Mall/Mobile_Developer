import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String image;

  const AppImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return const Icon(Icons.image);
    }

    return Image.network(image, fit: BoxFit.cover);
  }
}
