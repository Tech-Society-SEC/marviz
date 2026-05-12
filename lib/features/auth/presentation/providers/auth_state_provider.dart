import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Possible auth states the app can be in.
///
/// Will be expanded in Step 4 when Firebase is integrated:
/// - [unknown]: Initial state, checking persistent storage
/// - [unauthenticated]: No user logged in
/// - [authenticated]: User is logged in
enum AuthStatus {
  unknown,
  unauthenticated,
  authenticated,
}

/// Holds the current authentication state.
///
/// In Step 4, this will:
/// - Read from secure storage on startup
/// - Listen to Firebase auth state changes
/// - Update on login/logout/signup
///
/// For now (Step 3), it just starts as [unknown] and the splash screen
/// will simulate a check by waiting 2 seconds, then routing to login.
class AuthStateNotifier extends StateNotifier<AuthStatus> {
  AuthStateNotifier() : super(AuthStatus.unknown);

  /// Simulates checking if user is logged in.
  /// Replaced with real Firebase check in Step 4.
  Future<void> checkAuthStatus() async {
    // Simulate a brief check (will be real auth check later)
    await Future.delayed(const Duration(milliseconds: 500));

    // For now, always unauthenticated
    state = AuthStatus.unauthenticated;
  }

  /// Sign out (clears auth state).
  /// Will clear Firebase auth + secure storage in Step 4.
  Future<void> signOut() async {
    state = AuthStatus.unauthenticated;
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthStatus>((ref) {
  return AuthStateNotifier();
});