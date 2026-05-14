import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_state_provider.dart';

/// Forgot Password screen — sends a password reset link to the user's email.
///
/// Two states:
/// 1. Initial — email input + "Send Reset Link" button
/// 2. Success — confirmation message with "Back to Login" button
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.sendPasswordResetEmail(_emailController.text);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  } on AuthFailure catch (e) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
        backgroundColor: const Color(0xFFFF1744),
      ),
    );
  }
}

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
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
              // Back button row
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _isSuccess ? _buildSuccessState() : _buildFormState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      child: Form(
        key: _formKey,
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
                  Icons.lock_reset_rounded,
                  size: 40,
                  color: AppColors.primaryNeon,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'FORGOT PASSWORD?',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email and we\'ll send you a link to reset your password',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            AppTextField(
              label: 'Email',
              hint: 'rider@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: _validateEmail,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleSendResetLink(),
            ),
            const SizedBox(height: 32),
            AppPrimaryButton(
              label: 'Send Reset Link',
              icon: Icons.send_rounded,
              isLoading: _isLoading,
              onPressed: _handleSendResetLink,
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => context.go(AppRoutes.login),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium,
                    children: [
                      const TextSpan(text: 'Remember your password? '),
                      TextSpan(
                        text: 'Sign In',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryNeon,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return SingleChildScrollView(
      key: const ValueKey('success'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                size: 50,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'CHECK YOUR EMAIL',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodyMedium,
                children: [
                  const TextSpan(
                    text: 'We sent a password reset link to\n',
                  ),
                  TextSpan(
                    text: _emailController.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          AppPrimaryButton(
            label: 'Back to Login',
            icon: Icons.login_rounded,
            onPressed: () => context.go(AppRoutes.login),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() => _isSuccess = false);
            },
            child: Text(
              'Didn\'t receive it? Try again',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryNeon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}