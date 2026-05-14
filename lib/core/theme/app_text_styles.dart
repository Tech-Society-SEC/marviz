import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// MARVIZ AI Typography — Biker Edition
///
/// Two font families:
/// - Audiowide: For brand, big headings, speedometer numbers (racing aesthetic)
/// - Inter: For body text, UI labels, anything that needs to be readable
///
/// Audiowide has only one weight (regular), so we use letterSpacing
/// and font size to create hierarchy instead of weight variation.
class AppTextStyles {
  AppTextStyles._();

  // Display - Brand name, splash screen, hero text
  // Audiowide naturally looks bold, so smaller sizes work
  static TextStyle displayLarge = GoogleFonts.audiowide(
    fontSize: 48,
    letterSpacing: 4,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static TextStyle displayMedium = GoogleFonts.audiowide(
    fontSize: 36,
    letterSpacing: 5,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  // Headlines - Page titles, big numbers (speedometer)
  static TextStyle headlineLarge = GoogleFonts.audiowide(
    fontSize: 28,
    letterSpacing: 2,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.audiowide(
    fontSize: 22,
    letterSpacing: 2,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.audiowide(
    fontSize: 18,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  // Titles - Section headers (Inter — readability matters here)
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  // Body text (Inter — built for readability)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  // Labels (BUTTONS — uppercase, wide spacing)
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  // Special — Speedometer/instrument numbers
  static TextStyle speedometer = GoogleFonts.audiowide(
    fontSize: 64,
    letterSpacing: 0,
    color: AppColors.primaryNeon,
    height: 1,
  );
}