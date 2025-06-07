import 'package:planora/services/supabase/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseAuthService _supabaseAuthService;

  AuthRepository({
    SupabaseAuthService? supabaseAuthService,
  })
    : _supabaseAuthService = supabaseAuthService ?? SupabaseAuthService();

  Future<AuthResponse?> signUpNewUser(String email, String password) async {
    return _supabaseAuthService.signUpNewUser(email, password);
  }

  Future<AuthResponse?> signInWithEmail(String email, String password) async {
    return _supabaseAuthService.signInWithEmail(email, password);
  }

  Future<void> resetPassword(String email) async {
    return _supabaseAuthService.resetPassword(email);
  }

  Future<void> signOut() async {
    return _supabaseAuthService.signOut();
  }
}
