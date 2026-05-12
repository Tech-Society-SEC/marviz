import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// MARVIZ AI logo widget — uses the brand logo image.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 120,
    this.showTagline = true,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo image with orange glow
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.22),
            boxShadow: AppColors.neonGlow(intensity: 0.9, radius: 32),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.22),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),

        if (showText) ...[
          const SizedBox(height: 20),
          Text(
            'MARVIZ',
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: size * 0.32,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(4),
              boxShadow: AppColors.neonGlow(intensity: 0.5, radius: 8),
            ),
            child: Text(
              'AI POWERED',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],

        if (showTagline) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                color: AppColors.primaryNeon.withValues(alpha: 0.6),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'RIDE SMARTER · RIDE SAFER',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryNeon,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 1,
                color: AppColors.primaryNeon.withValues(alpha: 0.6),
              ),
            ],
          ),
        ],
      ],
    );
  }
}