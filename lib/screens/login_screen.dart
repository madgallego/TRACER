import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables for managing form state 
  final bool _passwordVisible = false;

  // Methods for handling login logic

  // User interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Non-existent app bar lol
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientBorderText(
                        text: 'WELCOME TO',
                        strokeWidth: 8,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Affection',
                          fontWeight: FontWeight.w600,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppDesign.primaryGradientStart,
                            AppDesign.primaryGradientEnd
                          ],
                        ),
                      ),
                      GradientBorderText(
                        text: 'TRACER',
                        strokeWidth: 8,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontFamily: 'Affection',
                          fontWeight: FontWeight.w700,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppDesign.primaryGradientStart,
                            AppDesign.primaryGradientEnd
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
                // Center box with login form
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      // Container for the login form
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Email field
                              const SizedBox(height: 12),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.black45),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: GradientIcon(
                                    icon: Icons.mail,
                                    size: AppDesign.sBtnIconSize,
                                    gradient: LinearGradient(colors: [
                                      AppDesign.primaryGradientStart,
                                      AppDesign.primaryGradientEnd
                                    ]), 
                                  ),
                                ),
                              ),
                              // Password field
                              const SizedBox(height: 12),
                              TextField(
                                style: const TextStyle(color: Colors.black),
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.black45),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: GradientIcon(
                                    icon: Icons.lock,
                                    size: AppDesign.sBtnIconSize,
                                    gradient: LinearGradient(colors: [
                                      AppDesign.primaryGradientStart,
                                      AppDesign.primaryGradientEnd
                                    ]), 
                                  ),
                                  suffixIcon: GradientIcon(
                                    icon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    size: AppDesign.sBtnIconSize,
                                    gradient: LinearGradient(colors: [
                                      AppDesign.primaryGradientStart,
                                      AppDesign.primaryGradientEnd
                                    ]),
                                    // TODO: Wrap in GestureDetector to handle taps OR create a GradientIconButton widget, update _passwordVisible state
                                  ),
                                ),
                              ),
                              // Sign in button
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 2000.0,
                                height: 50.0,
                                child: GradientBorderButton(
                                  onPressed: () async {
                                    // TODO: implement login logic
                                  },
                                  gradient: LinearGradient(colors: [
                                      AppDesign.primaryGradientStart,
                                      AppDesign.primaryGradientEnd
                                    ]),
                                  borderRadius: AppDesign.sBtnBorderRadius,
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              //Sign up field
                              const SizedBox(height: 16),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Sign Up now',
                                      style: TextStyle(
                                        color: AppDesign.primaryGradientEnd,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  )
                                ]
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}