import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

/// Placeholder home screen.
/// Real dashboard is being designed in Stitch by teammate.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.danger,
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 48, showTagline: false, showText: false),
              const SizedBox(height: 32),
              userAsync.when(
                data: (user) {
                  if (user == null) {
                    return Text(
                      'Loading...',
                      style: AppTextStyles.bodyLarge,
                    );
                  }
                  return Column(
                    children: [
                      Text(
                        'WELCOME, ${user.name.toUpperCase()}',
                        style: AppTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.bikeName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryNeon,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.bikeMileage} km/L · ${user.fuelTankCapacity} L tank',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(
                  color: AppColors.primaryNeon,
                ),
                error: (e, _) => Text(
                  'Error loading profile: $e',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Dashboard coming soon',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: 'Log Out',
                icon: Icons.logout_rounded,
                onPressed: () async {
                  await ref.read(authRepositoryProvider).signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}