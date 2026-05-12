/// MARVIZ AI App-wide Constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'MARVIZ AI';
  static const String appTagline = 'Ride Smarter. Ride Safer.';
  static const String appVersion = '1.0.0';

  // Animation durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Storage keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingComplete = 'onboarding_complete';
}