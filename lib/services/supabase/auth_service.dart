import 'package:flutter/foundation.dart';
import 'package:planora/utils/globals.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  // Create a new user with email and password
  Future<AuthResponse?> signUpNewUser(String email, String password) async {
    try {
      final AuthResponse res = await Globals.supabase.auth.signUp(
        email: email,
        password: password,
      );
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Email Sign-Up: $e');
      }
      return null;
    }
  }

  // Sign with email and password
  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await Globals.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Email Sign-In: $e');
      }
      return null;
    }
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await Globals.supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      if (kDebugMode) {
        print('Error during Password Reset: $e');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await Globals.supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during Sign-Out: $e');
      }
    }
  }
}
