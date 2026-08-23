import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const imageBackground = Color(0xffF8F9FB);

  static const badgeSale = Color(0xffE53935);

  static const badgeBest = Color(0xffFF9800);

  static const gradientStart = Color(0xFFFFC107);

  static const gradientEnd = Color(0xFFE2A600);

  //══════════════════════════════════════════════════════
  // BRAND
  //══════════════════════════════════════════════════════

  static const brand = Color(0xffD4A017);

  static const primary = Color(0xffD4A017);

  static const primaryDark = Color(0xffB8860B);

  static const primaryLight = Color(0xffF8D568);

  static const primaryExtraLight = Color(0xffFFF7DF);

  static const secondary = Color(0xffFFB300);

  static const accent = Color(0xffF59E0B);

  static const primarySoft = Color(0xFFFFF4D6);

  //══════════════════════════════════════════════════════
  // BACKGROUND
  //══════════════════════════════════════════════════════

  static const background = Color(0xffF8F9FB);

  static const background2 = Color(0xffF4F6F8);

  static const backgroundDark = Color(0xff101317);

  //══════════════════════════════════════════════════════
  // SURFACE
  //══════════════════════════════════════════════════════

  static const surface = Colors.white;

  static const surface2 = Color(0xffFCFCFD);

  static const surfaceVariant = Color(0xffF5F5F7);

  static const surfaceDark = Color(0xff1A1D22);

  static const card = Colors.white;

  static const cardDark = Color(0xff22262C);

  //══════════════════════════════════════════════════════
  // TEXT
  //══════════════════════════════════════════════════════

  static const textPrimary = Color(0xff171717);

  static const textSecondary = Color(0xff666666);

  static const textLight = Color(0xff888888);

  static const textHint = Color(0xffA0A4AB);

  static const textWhite = Colors.white;

  static const textOnPrimary = Colors.white;

  //══════════════════════════════════════════════════════
  // BORDER
  //══════════════════════════════════════════════════════

  static const border = Color(0xffE7E8EC);

  static const borderLight = Color(0xffF1F2F4);

  static const divider = Color(0xffECECEC);

  static const outline = Color(0xffD8DCE2);

  //══════════════════════════════════════════════════════
  // STATUS
  //══════════════════════════════════════════════════════

  static const success = Color(0xff16A34A);

  static const successLight = Color(0xffDCFCE7);

  static const warning = Color(0xffF59E0B);

  static const warningLight = Color(0xffFEF3C7);

  static const error = Color(0xffEF4444);

  static const errorLight = Color(0xffFEE2E2);

  static const info = Color(0xff2563EB);

  static const infoLight = Color(0xffDBEAFE);
  //══════════════════════════════════════════════════════
  // PRODUCT
  //══════════════════════════════════════════════════════

  static const price = Color(0xff171717);

  static const oldPrice = Color(0xff9CA3AF);

  static const discount = Color(0xffE53935);

  static const rating = Color(0xffF5B301);

  static const favorite = Color(0xffFF4D6D);

  static const newBadge = Color(0xff22C55E);

  static const saleBadge = Color(0xffEF4444);

  static const outOfStock = Color(0xff9CA3AF);

  //══════════════════════════════════════════════════════
  // DELIVERY
  //══════════════════════════════════════════════════════

  static const preparing = Color(0xffF59E0B);

  static const shipping = Color(0xff2563EB);

  static const delivered = Color(0xff16A34A);

  static const cancelled = Color(0xffEF4444);

  //══════════════════════════════════════════════════════
  // EFFECTS
  //══════════════════════════════════════════════════════

  static const overlay = Color(0x55000000);

  static const shimmerBase = Color(0xffECECEC);

  static const shimmerHighlight = Color(0xffF7F7F7);

  static const shadow = Color(0x12000000);

  //══════════════════════════════════════════════════════
  // COMMON
  //══════════════════════════════════════════════════════

  static const white = Colors.white;

  static const black = Colors.black;

  static const transparent = Colors.transparent;

  //══════════════════════════════════════════════════════
  // GRADIENTS
  //══════════════════════════════════════════════════════

  static const mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffF4C430), Color(0xffC69214)],
  );

  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffFFFFFF), Color(0xffFBFBFB)],
  );

  static const offerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffF59E0B), Color(0xffD97706)],
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xff22C55E), Color(0xff16A34A)],
  );

  static const errorGradient = LinearGradient(
    colors: [Color(0xffF87171), Color(0xffDC2626)],
  );
}
