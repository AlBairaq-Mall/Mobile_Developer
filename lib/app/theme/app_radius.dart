import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const card = lg;
  static const button = md;
  static const sheet = xl;
  static const image = lg;
  static const chip = 100.0;

  static const double none = 0;

  static const double pill = 100;

  static BorderRadius get xsRadius => BorderRadius.circular(xs);

  static BorderRadius get smRadius => BorderRadius.circular(sm);

  static BorderRadius get mdRadius => BorderRadius.circular(md);

  static BorderRadius get lgRadius => BorderRadius.circular(lg);

  static BorderRadius get xlRadius => BorderRadius.circular(xl);

  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);

  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}
