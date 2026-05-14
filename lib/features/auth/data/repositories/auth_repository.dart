import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_model.dart';

/// Auth repository — wraps Firebase Auth + Firestore.
///
/// All UI code talks to this class (not Firebase directly). This way:
/// - Easier to swap backends later if needed
/// - Centralized error handling
/// - Clean separation of concerns
class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream of authentication state changes.
  /// Emits `null` when logged out, `User` when logged in.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  // ============================================================
  // SIGN UP
  // ============================================================

  /// Creates a new Firebase Auth user + writes their profile to Firestore.
  ///
  /// Throws [AuthFailure] on any error (use friendly error message in UI).
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required int age,
    required String phone,
    required String bikeName,
    required double bikeMileage,
    required double fuelTankCapacity,
  }) async {
    try {
      // 1. Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Signup failed: user is null after creation');
      }

      // 2. Build the user profile
      final userModel = UserModel(
        uid: user.uid,
        email: email.trim(),
        name: name.trim(),
        age: age,
        phone: phone.trim(),
        bikeName: bikeName.trim(),
        bikeMileage: bikeMileage,
        fuelTankCapacity: fuelTankCapacity,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // 3. Save profile to Firestore at users/{uid}
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyError(e));
    } catch (e) {
      throw AuthFailure('An unexpected error occurred. Please try again.');
    }
  }

  // ============================================================
  // SIGN IN
  // ============================================================

  /// Signs in with email + password.
  /// Returns the user's profile from Firestore.
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Login failed: user is null');
      }

      // Update last-login timestamp
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'lastLoginAt': Timestamp.now()});

      // Fetch full profile from Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw const AuthFailure(
          'User profile not found. Please sign up first.',
        );
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyError(e));
    } catch (e) {
      throw AuthFailure('An unexpected error occurred. Please try again.');
    }
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ============================================================
  // PASSWORD RESET
  // ============================================================

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_friendlyError(e));
    } catch (e) {
      throw AuthFailure('Failed to send reset email. Please try again.');
    }
  }

  // ============================================================
  // FETCH USER PROFILE
  // ============================================================

  /// Loads the current user's profile from Firestore.
  Future<UserModel?> fetchCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  // ============================================================
  // ERROR MAPPING (Firebase codes → user-friendly messages)
  // ============================================================

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account with this email already exists. Sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Contact support.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

/// Custom exception for auth errors with user-friendly messages.
class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);

  @override
  String toString() => message;
}