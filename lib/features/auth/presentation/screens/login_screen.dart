import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/routing/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_state_provider.dart';

/// Login screen — entry point for returning users.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final authRepo = ref.read(authRepositoryProvider);

    await authRepo.signInWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    // Success — navigate to home
    context.go(AppRoutes.home);
  } on AuthFailure catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
        backgroundColor: const Color(0xFFFF1744),
      ),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _showPlaceholder(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Center(
                  child: AppLogo(
                    size: 80,
                    showTagline: false,
                    showText: false,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'WELCOME BACK',
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue your journey',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Form fields
                AppTextField(
                  label: 'Email',
                  hint: 'rider@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: _validateEmail,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _validatePassword,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 12),

                // Forgot password — subtle, not orange
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.forgotPassword),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Primary CTA
                AppPrimaryButton(
                  label: 'Sign In',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 32),

                // Divider with "OR"
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Social logins — neutral dark, brand-colored icons only
                AppDarkButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  iconColor: const Color(0xFFEA4335), // Google red
                  onPressed: () => _showPlaceholder('Google sign-in screen coming soon'),
                ),
                const SizedBox(height: 12),
                AppDarkButton(
                  label: 'Continue with Phone',
                  icon: Icons.phone_outlined,
                  iconColor: AppColors.primaryNeon,
                  onPressed: () => context.go(AppRoutes.otpVerification),
                ),
                const SizedBox(height: 32),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.signup),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryNeon,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}