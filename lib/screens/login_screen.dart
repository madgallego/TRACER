import 'package:flutter/material.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';
import '../widgets/gradient_border_snackbar.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables for managing form state
  bool _passwordVisible = false;

  // Auth service and controllers instances
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Log in function
  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Attempt to log in the user
    try {
      await authService.logIn(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Log in successful!')
        );
      }
    // Handle login errors
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Log in failed: $e.')
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GradientBorderText(
                              text: 'WELCOME TO',
                              strokeWidth: 8,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontFamily: 'Iceland',
                                fontWeight: FontWeight.bold,
                                height: 0.1,
                                letterSpacing: 0,
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
                                  color: Colors.black.withOpacity(0.4),
                                  offset: Offset(0, 8.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GradientBorderText(
                              text: 'TRACER',
                              strokeWidth: 8,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 110,
                                fontFamily: 'Iceland',
                                fontWeight: FontWeight.bold,
                                height: .8,
                                letterSpacing: -3,
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
                                  color: Colors.black.withOpacity(0.7),
                                  offset: Offset(0, 10.0),
                                ),
                              ],
                            ),
                          ]
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Center box with login form
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                // Sign in button
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: 2000.0,
                                  height: 50.0,
                                  child: GradientBorderButton(
                                    onPressed: () async {
                                      await login();
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
