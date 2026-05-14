import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Primary action button — flame edition.
/// Used for main actions like Sign In, Submit, Start Ride.
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    const onPrimaryColor = Color(0xFF1A0A00);

    final button = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // Refined glow — less intense, more professional
        boxShadow: isDisabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primaryNeon.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label.toUpperCase(),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: onPrimaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// Outlined secondary button — use sparingly.
/// Mostly for cases where you want brand-accented emphasis without dominance.
class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.primaryNeon),
            const SizedBox(width: 10),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primaryNeon,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// Dark neutral button — for social logins and tertiary actions.
///
/// Professional, doesn't compete with the primary CTA.
/// The icon can carry a brand color (Google red, etc) for recognition,
/// while the button itself stays subtle.
class AppDarkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? iconWidget;
  final IconData? icon;
  final Color? iconColor;
  final bool fullWidth;

  const AppDarkButton({
    super.key,
    required this.label,
    this.onPressed,
    this.iconWidget,
    this.icon,
    this.iconColor,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconWidget != null) ...[
                iconWidget!,
                const SizedBox(width: 12),
              ] else if (icon != null) ...[
                Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}