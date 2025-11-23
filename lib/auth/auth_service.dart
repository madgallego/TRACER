import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign up a new user with email and password
  Future<AuthResponse> signIn(String email, String password) async{
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Log in an existing user with email and password 
  Future<AuthResponse> signUp(String email, String password) async{
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'io.supabase.tracer://login-callback',
    );
  }
  
  // Sign out the current user
  Future<void> logOut() async {
    await _supabase.auth.signOut();
  }

  // Get the current user
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}