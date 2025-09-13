import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  SupabaseClient get _client => SupabaseService.instance.client;

  // Compile-time flag to allow creating a user automatically on invalid credentials
  static const bool _allowAutoCreateOnLogin = bool.fromEnvironment(
    'ALLOW_AUTO_CREATE_ON_LOGIN',
    defaultValue: false,
  );

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Get current session
  Session? get currentSession => _client.auth.currentSession;

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'farmer',
    String? location,
    String? phone,
    double? farmSize,
    int? farmingExperience,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
          'location': location,
          'phone': phone,
          'farm_size': farmSize,
          'farming_experience': farmingExperience,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  // Sign in with email and password (with optional auto-create fallback)
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      // If enabled, try to create the account automatically when credentials are invalid
      final errorString = error.toString();
      final isInvalidCreds = errorString.contains('invalid_credentials');
      if (_allowAutoCreateOnLogin && isInvalidCreds) {
        // Attempt sign up, then sign in again
        try {
          await _client.auth.signUp(
            email: email,
            password: password,
            data: {
              'full_name': email.split('@').first,
              'role': 'farmer',
            },
          );
          // If email confirmations are required, this sign-in may still fail with not_confirmed
          final retry = await _client.auth.signInWithPassword(
            email: email,
            password: password,
          );
          return retry;
        } catch (signupError) {
          throw Exception(
            'Auto-create failed. Please ensure email/password auth is enabled and email confirmations are disabled or the email is confirmed. Details: $signupError',
          );
        }
      }
      throw Exception('Sign in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!isSignedIn) return null;

    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? location,
    String? phone,
    double? farmSize,
    int? farmingExperience,
  }) async {
    if (!isSignedIn) throw Exception('User not signed in');

    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (location != null) updateData['location'] = location;
      if (phone != null) updateData['phone'] = phone;
      if (farmSize != null) updateData['farm_size'] = farmSize;
      if (farmingExperience != null)
        updateData['farming_experience'] = farmingExperience;

      final response = await _client
          .from('user_profiles')
          .update(updateData)
          .eq('id', currentUser!.id)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }
}
