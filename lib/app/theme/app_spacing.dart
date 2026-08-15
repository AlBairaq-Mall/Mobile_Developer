import 'package:flutter/widgets.dart';

class AppSpacing {
  AppSpacing._();

  //══════════════════════════════════════
  // Sizes
  //══════════════════════════════════════
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
  static const double none = 0;

  static const double huge = 40;

  static const double giant = 48;

  static const double massive = 64;

  //══════════════════════════════════════
  // Page Padding
  //══════════════════════════════════════

  static const EdgeInsets page = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(horizontal: 16);

  static const EdgeInsets pageVertical = EdgeInsets.symmetric(vertical: 16);

  //══════════════════════════════════════
  // Cards
  //══════════════════════════════════════

  static const EdgeInsets card = EdgeInsets.all(16);

  static const EdgeInsets cardSmall = EdgeInsets.all(12);

  static const EdgeInsets cardLarge = EdgeInsets.all(20);

  //══════════════════════════════════════
  // Buttons
  //══════════════════════════════════════

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 14,
  );

  //══════════════════════════════════════
  // Inputs
  //══════════════════════════════════════

  static const EdgeInsets input = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 16,
  );

  //══════════════════════════════════════
  // Lists
  //══════════════════════════════════════

  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  //══════════════════════════════════════
  // Sections
  //══════════════════════════════════════

  static const SizedBox v2 = SizedBox(height: 2);

  static const SizedBox v4 = SizedBox(height: 4);

  static const SizedBox v8 = SizedBox(height: 8);

  static const SizedBox v12 = SizedBox(height: 12);

  static const SizedBox v16 = SizedBox(height: 16);

  static const SizedBox v20 = SizedBox(height: 20);

  static const SizedBox v24 = SizedBox(height: 24);

  static const SizedBox v32 = SizedBox(height: 32);

  static const SizedBox v40 = SizedBox(height: 40);

  static const SizedBox h2 = SizedBox(width: 2);

  static const SizedBox h4 = SizedBox(width: 4);

  static const SizedBox h8 = SizedBox(width: 8);

  static const SizedBox h12 = SizedBox(width: 12);

  static const SizedBox h16 = SizedBox(width: 16);

  static const SizedBox h20 = SizedBox(width: 20);

  static const SizedBox h24 = SizedBox(width: 24);

  static const SizedBox h32 = SizedBox(width: 32);
}
