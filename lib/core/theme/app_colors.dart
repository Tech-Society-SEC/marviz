import 'package:flutter/material.dart';

/// MARVIZ AI Color Palette — Flame Edition
/// Matches the brand logo: fiery orange on deep black.
class AppColors {
  AppColors._();

  // Brand — Fiery Orange (logo flames)
  static const Color primaryNeon = Color(0xFFFF6B1A);
  static const Color primaryNeonDark = Color(0xFFE54A00);
  static const Color primaryNeonLight = Color(0xFFFFA060);
  static const Color primaryGlow = Color(0xFFFFB347);

  // Secondary — Golden flame
  static const Color accentAmber = Color(0xFFFFC107);
  static const Color accentAmberDark = Color(0xFFE5A300);

  // Danger — Hot red for SOS
  static const Color danger = Color(0xFFFF1744);
  static const Color dangerDark = Color(0xFFD50000);

  // Backgrounds — Pure black with warm undertones
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0F0A08);
  static const Color backgroundCard = Color(0xFF1A130F);
  static const Color backgroundElevated = Color(0xFF241B14);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8AFA8);
  static const Color textTertiary = Color(0xFF7A6E66);
  static const Color textDisabled = Color(0xFF3D362F);

  // Status
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFFFF8A50);

  // Borders
  static const Color border = Color(0xFF2E2218);
  static const Color borderActive = Color(0xFFFF6B1A);
  static const Color divider = Color(0xFF1E1813);

  static List<BoxShadow> neonGlow({double intensity = 1.0, double radius = 20}) => [
        BoxShadow(
          color: primaryNeon.withValues(alpha: 0.45 * intensity),
          blurRadius: radius,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: primaryNeon.withValues(alpha: 0.2 * intensity),
          blurRadius: radius * 2,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> dangerGlow({double intensity = 1.0}) => [
        BoxShadow(
          color: danger.withValues(alpha: 0.4 * intensity),
          blurRadius: 20,
          spreadRadius: 1,
        ),
      ];

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryNeonLight, primaryNeon, primaryNeonDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient flameGradient = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFF6B1A), Color(0xFFE54A00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundPrimary, backgroundSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [backgroundCard, backgroundElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [danger, dangerDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}