import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  // Sign up a new user with email and password
  Future<AuthResponse> logIn(String email, String password) async{
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  // Log in an existing user with email and password 
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String middleInitial,
    required String lastName,
    required String orgId,
    required String studentId,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'io.supabase.tracer://login-callback',
    );

    final userId = response.user?.id;
    if (userId != null) {
      await _supabase.from('finance_officers').insert({
        'user_id': userId,
        'email': email,
        'first_name': firstName,
        'middle_initial': middleInitial.isNotEmpty ? middleInitial : null,
        'last_name': lastName,
        'organization_id': orgId,
        'student_id': studentId,
      });
    }

    return response;
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

  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final response = await _supabase
        .from('organizations')
        .select('id, name, abbrv')
        .order('name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> changePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.tracer://login-callback',
    );
  }
}