import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../widgets/signup_progress_bar.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/auth_state_provider.dart';

/// Signup screen — 2-step form for new rider registration.
///
/// Step 1: Personal info (name, age, email, phone, password)
/// Step 2: Bike info (bike name, mileage, fuel tank capacity)
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Step 1 controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 2 controllers
  final _bikeNameController = TextEditingController();
  final _mileageController = TextEditingController();
  final _fuelTankController = TextEditingController();

  int _currentStep = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bikeNameController.dispose();
    _mileageController.dispose();
    _fuelTankController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (!_step1FormKey.currentState!.validate()) return;
    setState(() => _currentStep = 2);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToStep1() {
    setState(() => _currentStep = 1);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSignup() async {
  if (!_step2FormKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final authRepo = ref.read(authRepositoryProvider);

    await authRepo.signUpWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      phone: _phoneController.text,
      bikeName: _bikeNameController.text,
      bikeMileage: double.parse(_mileageController.text),
      fuelTankCapacity: double.parse(_fuelTankController.text),
    );

    if (!mounted) return;

    // Success — show confirmation and navigate to home
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Welcome to MARVIZ AI! Your account is ready.'),
        backgroundColor: Color(0xFF00E676),
      ),
    );

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

  // ---- Validators ----

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'Please enter your $fieldName';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your age';
    final age = int.tryParse(value);
    if (age == null) return 'Age must be a number';
    if (age < 16) return 'Must be at least 16 to ride';
    if (age > 100) return 'Please enter a valid age';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your phone number';
    if (value.length < 10) return 'Enter a valid 10-digit number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validateMileage(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your bike mileage';
    final mileage = double.tryParse(value);
    if (mileage == null) return 'Must be a number';
    if (mileage < 5 || mileage > 200) return 'Enter a realistic value (5–200 km/L)';
    return null;
  }

  String? _validateFuelTank(String? value) {
    if (value == null || value.isEmpty) return 'Please enter fuel tank capacity';
    final tank = double.tryParse(value);
    if (tank == null) return 'Must be a number';
    if (tank < 1 || tank > 50) return 'Enter a realistic value (1–50 L)';
    return null;
  }

  void _handleBackPress() {
    if (_currentStep == 2) {
      _goToStep1();
    } else {
      // Step 1 — go back to login
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.login);
      }
    }
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

              // Top bar — back button + small logo
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: AppColors.textPrimary,
                    onPressed: _handleBackPress,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Spacer(),
                  const AppLogo(
                    size: 36,
                    showText: false,
                    showTagline: false,
                  ),
                  const Spacer(),
                  // Invisible widget to balance the back button
                  const SizedBox(width: 36),
                ],
              ),

              const SizedBox(height: 24),

              // Progress bar
              SignupProgressBar(
                currentStep: _currentStep,
                totalSteps: 2,
                stepLabel: _currentStep == 1 ? 'PERSONAL' : 'BIKE INFO',
              ),

              const SizedBox(height: 28),

              // Step content — animated page transition
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                  ],
                ),
              ),

              // Sign in link at bottom (only on step 1)
              if (_currentStep == 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Step 1: Personal Info ----

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CREATE ACCOUNT',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us about yourself',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),

            AppTextField(
              label: 'Full Name',
              hint: 'John Rider',
              controller: _nameController,
              prefixIcon: Icons.person_outline,
              validator: (v) => _validateRequired(v, 'name'),
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Age',
              hint: '25',
              controller: _ageController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.calendar_today_outlined,
              validator: _validateAge,
              maxLength: 3,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            AppTextField(
              label: 'Phone Number',
              hint: '9876543210',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              validator: _validatePhone,
              maxLength: 10,
              autofillHints: const [AutofillHints.telephoneNumberNational],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Password',
              hint: 'At least 6 characters',
              controller: _passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: _validatePassword,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Confirm Password',
              hint: 'Re-enter password',
              controller: _confirmPasswordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              validator: _validateConfirmPassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _goToStep2(),
            ),
            const SizedBox(height: 32),

            AppPrimaryButton(
              label: 'Continue',
              icon: Icons.arrow_forward,
              onPressed: _goToStep2,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ---- Step 2: Bike Info ----

  Widget _buildStep2() {
    return Form(
      key: _step2FormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bike icon banner
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
                  Icons.motorcycle_rounded,
                  size: 44,
                  color: AppColors.primaryNeon,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'YOUR RIDE',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us about your motorcycle',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            AppTextField(
              label: 'Bike Name',
              hint: 'KTM Duke 390',
              controller: _bikeNameController,
              prefixIcon: Icons.motorcycle_outlined,
              validator: (v) => _validateRequired(v, 'bike name'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Mileage (km/L)',
              hint: '35',
              controller: _mileageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.local_gas_station_outlined,
              validator: _validateMileage,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Fuel Tank Capacity (L)',
              hint: '13.5',
              controller: _fuelTankController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.water_drop_outlined,
              validator: _validateFuelTank,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleSignup(),
            ),
            const SizedBox(height: 32),

            // Action row — back + submit
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _goToStep1,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: AppPrimaryButton(
                    label: 'Create Account',
                    isLoading: _isLoading,
                    onPressed: _handleSignup,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}