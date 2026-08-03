import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const none = <BoxShadow>[];

  static const subtle = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const card = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x16000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  /// بطاقات صغيرة
  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// بطاقات عادية (الأكثر استخداماً)
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 3),
    ),
  ];

  /// بطاقات الصفحة الرئيسية
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 14,
      offset: Offset(0, 5),
    ),
  ];

  /// نافذة أو عنصر مرتفع
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  /// شريط البحث
  static const List<BoxShadow> search = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  /// بطاقة منتج
  static const List<BoxShadow> product = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 5),
    ),
  ];

  /// بطاقة قسم
  static const List<BoxShadow> category = [
    BoxShadow(
      color: Color(0x10000000),
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
  ];

  /// بانر الصفحة الرئيسية
  static const List<BoxShadow> banner = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 22,
      offset: Offset(0, 8),
    ),
  ];

  /// نافذة منبثقة
  static const List<BoxShadow> dialog = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];
}
