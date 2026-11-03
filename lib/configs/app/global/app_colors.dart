import 'package:flutter/material.dart';

/// BLOB style-guide tokens — see docs/style-guide.md.
abstract final class AppColors {
  const AppColors._();

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color foregroundLight = Color(0xFF000000);
  static const Color foregroundDark = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFF595959);
  static const Color secondaryDark = Color(0xB3FFFFFF);
  static const Color inactiveLight = Color(0xFF6B6B6B);
  static const Color inactiveDark = Color(0x8CFFFFFF);

  static const Color accentPink = Color(0xFFF10EA0);
  static const Color accentOrange = Color(0xFFE95214);
  static const Color metroPink = Color(0xFFE8117F);
  static const Color metroOrange = Color(0xFFF26D21);

  static const Color success = Color(0xFF2E9B4A);
  static const Color error = Color(0xFFC62828);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPink, accentOrange],
  );
}
