import 'package:flutter/material.dart';

/// MARVIZ AI Color Palette
///
/// Design inspiration: Modern motorcycle dashboard
/// - Dark theme as primary (better for night riding)
/// - Neon green accent (high visibility, sporty)
/// - Orange accent (warnings, important actions)
class AppColors {
  // Prevent instantiation
  AppColors._();

  // Brand colors
  static const Color primaryNeon = Color(0xFF00FF88);
  static const Color primaryNeonDark = Color(0xFF00CC6E);
  static const Color accentOrange = Color(0xFFFF6B00);
  static const Color accentOrangeDark = Color(0xFFE55F00);

  // Backgrounds (dark theme)
  static const Color backgroundPrimary = Color(0xFF0A0E1A);
  static const Color backgroundSecondary = Color(0xFF12172A);
  static const Color backgroundCard = Color(0xFF1A2138);
  static const Color backgroundElevated = Color(0xFF232B47);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8BCC8);
  static const Color textTertiary = Color(0xFF6C7293);
  static const Color textDisabled = Color(0xFF3F4663);

  // Status colors
  static const Color success = Color(0xFF00FF88);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF3D5A);
  static const Color info = Color(0xFF00B4FF);

  // Borders & dividers
  static const Color border = Color(0xFF2A3252);
  static const Color divider = Color(0xFF1F2640);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryNeon, primaryNeonDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [accentOrange, accentOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [backgroundCard, backgroundSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}