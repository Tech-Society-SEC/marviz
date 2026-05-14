import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../widgets/otp_input_field.dart';

/// OTP Verification screen — for phone-based signup or password reset.
///
/// Features:
/// - 6-digit input with auto-focus jumps
/// - 30-second resend timer
/// - Animated verification button
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? phoneNumber;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _otp = '';
  bool _isLoading = false;
  int _resendCountdown = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _resendCountdown = 30);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _resendCountdown--);
    });
  }

  Future<void> _handleVerify() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP verified! (Backend not part of UI scope)')),
    );
  }

  void _handleResend() {
    if (_resendCountdown > 0) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New code sent to your phone')),
    );
  }

  String _maskedPhone() {
    final phone = widget.phoneNumber ?? '+91 ••••• ••567';
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // Back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: AppColors.textPrimary,
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.login),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryNeon.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: AppColors.neonGlow(intensity: 0.5, radius: 16),
                          ),
                          child: const Icon(
                            Icons.sms_outlined,
                            size: 40,
                            color: AppColors.primaryNeon,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'VERIFICATION CODE',
                        style: AppTextStyles.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium,
                          children: [
                            const TextSpan(text: 'Enter the 6-digit code sent to\n'),
                            TextSpan(
                              text: _maskedPhone(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // OTP input
                      OtpInputField(
                        onCompleted: (otp) {
                          setState(() => _otp = otp);
                          // Auto-verify on completion
                          _handleVerify();
                        },
                        onChanged: (otp) {
                          setState(() => _otp = otp);
                        },
                      ),
                      const SizedBox(height: 32),

                      AppPrimaryButton(
                        label: 'Verify',
                        icon: Icons.check_circle_outline_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleVerify,
                      ),
                      const SizedBox(height: 28),

                      // Resend section
                      Center(
                        child: _resendCountdown > 0
                            ? RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyMedium,
                                  children: [
                                    const TextSpan(text: 'Resend code in '),
                                    TextSpan(
                                      text: '${_resendCountdown}s',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.primaryNeon,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: _handleResend,
                                child: Text(
                                  'Resend Code',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primaryNeon,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: Text(
                            'Change phone number',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}