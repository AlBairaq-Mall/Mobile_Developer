import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Brand ──────────────────────────────
  static const primary = Color.fromARGB(255, 226, 166, 0); // Emerald Green
  static const primaryDark = Color.fromARGB(255, 148, 108, 0);
  static const primaryLight = Color.fromARGB(255, 240, 193, 91);

  // ── Secondary / Accent ─────────────────────────
  static const accent = Color(0xFFFFA726); // Warm Amber
  static const accentDark = Color(0xFFE65100);

  // ── Gradient Pairs ─────────────────────────────
  static const gradientStart = Color.fromARGB(255, 255, 187, 0);
  static const gradientEnd = Color.fromARGB(255, 184, 125, 0);

  static const adminGradientStart = Color.fromARGB(255, 126, 108, 26);
  static const adminGradientEnd = Color.fromARGB(255, 189, 186, 2);

  static const deliveryGradientStart = Color(0xFF004D40);
  static const deliveryGradientEnd = Color(0xFF00695C);

  // ── Backgrounds ────────────────────────────────
  static const background = Color(0xFFF5F7FA);
  static const backgroundDark = Color(0xFF0D1117);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF161B22);
  static const cardDark = Color(0xFF21262D);

  // ── Text ───────────────────────────────────────
  static const textPrimary = Color(0xFF0D1117);
  static const textSecondary = Color(0xFF57606A);
  static const textHint = Color(0xFF8B949E);

  // ── Status ─────────────────────────────────────
  static const success = Color(0xFF00BF6F);
  static const error = Color(0xFFFF4C4C);
  static const warning = Color(0xFFFFA726);
  static const info = Color(0xFF0277BD);

  // ── Misc ───────────────────────────────────────
  static const border = Color(0xFFE8ECF0);
  static const divider = Color(0xFFEBEDF0);
  static const black = Color(0xFF0D1117);
  static const white = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFFFA726);

  // ── Gradients ──────────────────────────────────
  static const mainGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const headerGradient = LinearGradient(
    colors: [Color(0xFF00BF6F), Color(0xFF0099CC)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
