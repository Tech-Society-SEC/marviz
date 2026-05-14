/// All route paths in MARVIZ AI.
///
/// Centralizing routes here means:
/// - No typos when navigating (autocomplete catches errors)
/// - Easy to refactor when paths change
/// - Single source of truth for the team
class AppRoutes {
  AppRoutes._();

  // Auth flow
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';

  // Main app
  static const String home = '/home';
  static const String trips = '/trips';
  static const String community = '/community';
  static const String rewards = '/rewards';
  static const String profile = '/profile';
}