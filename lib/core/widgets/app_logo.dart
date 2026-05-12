import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// MARVIZ AI logo widget — reusable across splash, login, signup.
///
/// For now this is text-based with a gradient. Later we'll swap in
/// an SVG/PNG logo from assets/images/.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon — placeholder shield with motorcycle vibe
        Container(
          width: size * 1.4,
          height: size * 1.4,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNeon.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.motorcycle_rounded,
            size: size * 0.8,
            color: const Color(0xFF003920),
          ),
        ),
        const SizedBox(height: 16),
        // App name with gradient text
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'MARVIZ AI',
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            'Ride Smarter. Ride Safer.',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ],
    );
  }
}