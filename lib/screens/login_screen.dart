import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';
import '../widgets/gradient_border_snackbar.dart';
import '../widgets/gradient_border_text_form_field.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/app_bottom_sheet.dart';
import 'change_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables for managing form state
  bool _passwordVisible = false;

  // Auth service and controllers instances
  final authService = AuthService(Supabase.instance.client);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Stream subscription for auth state changes
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Log in function
  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ErrorSnackbar.show(context, 'Please fill in all fields.');
      return;
    }

    try {
      await authService.logIn(email, password);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Log in successful!')
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        String message;
        switch (e.message) {
          case 'Invalid login credentials':
            message = 'Incorrect email or password. Please try again.';
            break;
          case 'Email not confirmed':
            message = 'Please verify your email before logging in.';
            break;
          case 'Too many requests':
            message = 'Too many attempts. Please wait a moment and try again.';
            break;
          default:
            message = 'Log in failed. Please try again.';
        }
        ErrorSnackbar.show(context, message);
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Something went wrong. Please try again.');
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
                                  AppDesign.primaryGradientEnd,
                                  AppDesign.primaryGradientStart
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
                                  AppDesign.primaryGradientEnd,
                                  AppDesign.primaryGradientStart
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
                                GradientBorderTextFormField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: GradientIcon(
                                    icon: Icons.mail,
                                    size: AppDesign.sIconSize,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                  ],
                                ),
                                // Password field
                                const SizedBox(height: 12),
                                GradientBorderTextFormField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  obscureText: !_passwordVisible,
                                  prefixIcon: GradientIcon(
                                    icon: Icons.lock,
                                    size: AppDesign.sIconSize,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: GradientIcon(
                                      icon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                      size: AppDesign.sIconSize,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      AppBottomSheet.show(
                                        context,
                                        icon: Icons.lock_reset,
                                        title: 'Reset Password',
                                        child: _ForgotPasswordForm(authService: authService),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: AppDesign.bodyStyle.copyWith(
                                        color: AppDesign.primaryGradientEnd,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),

                                // Sign in button
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: 2000.0,
                                  height: 50.0,
                                  child: GradientBorderButton(
                                    isInternetRequired: true,
                                    onPressed: () async {
                                      await login();
                                    },
                                    child: Text(
                                      'Log In',
                                      style: AppDesign.buttonTextStyle,
                                    ),
                                  ),
                                ),
                                //Sign up field
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: AppDesign.bodyStyle.copyWith(color: Colors.black45),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed('/signup');
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Sign Up now',
                                        style: AppDesign.bodyStyle.copyWith(
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

class _ForgotPasswordForm extends StatefulWidget {
  final AuthService authService;

  const _ForgotPasswordForm({required this.authService});

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Please enter your email.');
      return;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _isSending = true);

    try {
      await widget.authService.sendPasswordResetEmail(email);

      if (mounted) {
        final parentContext = context;
        _emailController.clear();
        Navigator.pop(context);

        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              GradientBorderSnackbar(message: 'Password reset link sent! Check your inbox.'),
            );
          }
        });
      }
    } catch (e) {
      _showError('Failed to send password reset link. Please try again.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _showError(String message) {
    final parentContext = context;
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 100), () {
      ErrorSnackbar.show(parentContext, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter your email address and we will send a secure link to reset your password. If you do not receive an email within a few minutes, please coordinate with the TRACER administrators.',
          style: AppDesign.bodyStyle,
        ),

        const SizedBox(height: 20),

        Text('Email Address', style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientBorderTextFormField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: GradientIcon(
            icon: Icons.mail,
            size: AppDesign.sIconSize,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        ),

        const SizedBox(height: 20),

        GradientBorderButton(
          onPressed: _isSending ? () async {} : _sendResetLink,
          child: _isSending
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Link', style: AppDesign.buttonTextStyle),
        ),
      ],
    );
  }
}
