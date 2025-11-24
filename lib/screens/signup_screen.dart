import 'package:flutter/material.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Variables for managing form state 
  final bool _passwordVisible = false;
  final bool _confirmPasswordVisible = false;

  // Auth service and controllers
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Methods for handling login logic
  Future<void> signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Check if passwords match
    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
      return;
    }

    // Attempt to sign up the user
    try {
      await authService.signUp(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful! Please verify your email and proceed to log in.')),
        );
        Navigator.pop(context);
      }
    // Handle sign up errors
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,

            // Gradient border for the snackbar with pop up animation
            content: TweenAnimationBuilder<double>(
              // Animation
              tween: Tween(begin: 0.0, end: 1.0), 
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut, // Pop up effect
              
              builder: (context, value, child) {
                // Apply the animation value to the scale
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },

              // Outer container with gradient border
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [ AppDesign.primaryGradientStart,AppDesign.primaryGradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(4),
              
                // Text displaying the error message
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Sign up failed: $e',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center
                  ),
                )
              ),
            )
          )
        );
      }
    }
  }

  // User interface
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Removes keyboard when tapping outside input fields
      child: Scaffold(
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
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
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
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 10.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 10.0),
                                ),
                              ],
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
                                      controller: _emailController,
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
                                      controller: _passwordController,
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
                                        suffixIcon: IconButton(
                                          icon: GradientIcon(
                                            icon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                            size: AppDesign.sBtnIconSize,
                                            gradient: LinearGradient(colors: [
                                              AppDesign.primaryGradientStart,
                                              AppDesign.primaryGradientEnd
                                            ]),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible = !_passwordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    // Confirm Password field
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _confirmPasswordController,
                                      style: const TextStyle(color: Colors.black),
                                      obscureText: !_confirmPasswordVisible,
                                      decoration: InputDecoration(
                                        hintText: 'Confirm Password',
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
                                        suffixIcon: IconButton(
                                          icon: GradientIcon(
                                            icon: _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                            size: AppDesign.sBtnIconSize,
                                            gradient: LinearGradient(colors: [
                                              AppDesign.primaryGradientStart,
                                              AppDesign.primaryGradientEnd
                                            ]),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _confirmPasswordVisible = !_confirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    // Sign up button
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 2000.0,
                                      height: 50.0,
                                      child: GradientBorderButton(
                                        onPressed: () async {
                                          await signup();
                                        },
                                        gradient: LinearGradient(colors: [
                                            AppDesign.primaryGradientStart,
                                            AppDesign.primaryGradientEnd
                                          ]),
                                        borderRadius: AppDesign.sBtnBorderRadius,
                                        child: const Text(
                                          'Sign Up',
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
                                          "Already have an account? ",
                                          style: TextStyle(color: Colors.black45),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          child: Text(
                                            'Log In now',
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}