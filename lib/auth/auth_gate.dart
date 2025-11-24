// This listens to the authentication state and redirects the user to the respective screen based on their authentication status.
// Authenticated => home_screen, Unauthenticated => login_screen

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracer/screens/home_screen.dart';
import 'package:tracer/screens/login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate ({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Listen for auth state changes to handle email confirmation redirects
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        // Debug print to confirm the link worked
        print("User confirmed email and is now signed in!"); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listens to authentication state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Builds the screen based on the authentication state
      builder: (context, snapshot){
        // While waiting for the authentication state, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // Get the current session from the snapshot
        final session = snapshot.hasData ? snapshot.data!.session : null; 

        // If there's a valid session, user is authenticated
        if (session != null) {
          // TODO: Redirect to the home screen after login, made a placeholder home screen for now
          return const HomeScreen();
        } else {
          // No valid session, user is unauthenticated
          return const LoginScreen();
        }
      } 
    );
  }
}