import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user_model.dart';

/// Provides the singleton AuthRepository instance.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Streams the Firebase auth state.
/// Emits `null` when no user is signed in, `User` when signed in.
final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Provides the current user's full profile from Firestore.
/// Returns null if logged out or profile not yet loaded.
final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  // Re-fetch whenever auth state changes
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) async {
      if (user == null) return null;
      final repo = ref.read(authRepositoryProvider);
      return repo.fetchCurrentUserProfile();
    },
    loading: () => null,
    error: (_, __) => null,
  );
});