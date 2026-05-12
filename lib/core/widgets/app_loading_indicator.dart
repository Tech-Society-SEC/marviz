import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Branded loading indicator for MARVIZ AI.
///
/// Use this anywhere we need a spinner — keeps the look consistent.
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primaryNeon,
          ),
        ),
      ),
    );
  }
}