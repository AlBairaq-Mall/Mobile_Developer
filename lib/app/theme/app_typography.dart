import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Cairo';

  static const productName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static const productBrand = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const currentPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const oldPrice = TextStyle(
    fontSize: 11,
    decoration: TextDecoration.lineThrough,
  );

  static const badge = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 10,
  );

  //══════════════════════════════════════
  // DISPLAY
  //══════════════════════════════════════

  static const displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static const displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  //══════════════════════════════════════
  // HEADLINES
  //══════════════════════════════════════

  static const headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  //══════════════════════════════════════
  // TITLES
  //══════════════════════════════════════

  static const titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  //══════════════════════════════════════
  // BODY
  //══════════════════════════════════════

  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  //══════════════════════════════════════
  // LABELS
  //══════════════════════════════════════

  static const labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textHint,
  );

  //══════════════════════════════════════
  // BUTTON
  //══════════════════════════════════════

  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  //══════════════════════════════════════
  // PRICE
  //══════════════════════════════════════

  static const priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.price,
  );

  static const priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.price,
  );

  static const priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.price,
  );

  static const discount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.discount,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    color: AppColors.textHint,
  );
}
