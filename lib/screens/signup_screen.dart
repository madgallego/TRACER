import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';
import '../widgets/gradient_border_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/gradient_border_text_form_field.dart';
import '../widgets/gradient_dropdown.dart';
import '../widgets/error_snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Variables for managing form state
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoadingOrgs = true;
  List<Map<String, dynamic>> _organizations = [];
  String? _selectedOrgId;

  // Auth service and controllers instances
  final authService = AuthService(Supabase.instance.client);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _studentNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    try {
      final orgs = await authService.getOrganizations();
      debugPrint('Organizations loaded: $orgs');
      if (mounted) {
        setState(() {
          _organizations = orgs;
          _isLoadingOrgs = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading orgs: $e');
      if (mounted) setState(() => _isLoadingOrgs = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentNumberController.dispose();
    super.dispose();
  }

  // Sign up function
  Future<void> signup() async {
    final studentNumber = _studentNumberController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (studentNumber.isEmpty) {
      ErrorSnackbar.show(context, 'Please enter your student number.');
      return;
    }

    if (email.isEmpty) {
      ErrorSnackbar.show(context, 'Please enter your email address.');
      return;
    }

    if (_selectedOrgId == null) {
      ErrorSnackbar.show(context, 'Please select your organization.');
      return;
    }

    if (password.isEmpty) {
      ErrorSnackbar.show(context, 'Please enter a password.');
      return;
    }

    if (password.length < 6) {
      ErrorSnackbar.show(context, 'Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      ErrorSnackbar.show(context, 'Passwords do not match. Please try again.');
      return;
    }

    setState(() => _isLoadingOrgs = true);

    final studentExists = await authService.checkStudentExists(studentNumber);
    
    if (!studentExists) {
      if (mounted) {
        setState(() => _isLoadingOrgs = false);
        ErrorSnackbar.show(context, "Student number doesn't exist.");
      }
      return; 
    }

    final isAlreadyRegistered = await authService.isStudentAlreadyRegistered(studentNumber);
    
    if (isAlreadyRegistered) {
      if (mounted) {
        setState(() => _isLoadingOrgs = false);
        ErrorSnackbar.show(context, 'An account with this student number already exists.');
      }
      return;
    }

    try {
      await authService.signUp(
        email: email,
        password: password,
        studentNumber: studentNumber,
        orgId: _selectedOrgId!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Sign up successful!') // Please check your email to verify your account and proceed to log in.
        );
        Navigator.of(context).pop();
      }
    } on AuthException catch (e) {
        debugPrint('SUPABASE AUTH ERROR: ${e.message} | Status Code: ${e.statusCode}'); // Debug to print error message and status code 

        if (mounted) {
        String message;
        switch (e.message) {
          case 'User already registered':
            message = 'An account with this email already exists.';
            break;
          case 'Password should be at least 6 characters':
            message = 'Password must be at least 6 characters.';
            break;
          case 'Unable to validate email address: invalid format':
            message = 'Please enter a valid email address.';
            break;
          default:
            message = 'Sign up failed. Please try again.';
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

                                // Student number field
                                const SizedBox(height: 12),
                                GradientBorderTextFormField(
                                  controller: _studentNumberController,
                                  hintText: 'Student Number',
                                  prefixIcon: GradientIcon(
                                    icon: Icons.badge,
                                    size: AppDesign.sIconSize,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  keyboardType: TextInputType.number,
                                ),

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

                                // Organization dropdown
                                const SizedBox(height: 12),
                                GradientDropdown<String>(
                                  value: _selectedOrgId,
                                  hintText: '   Select Organization',
                                  prefixIcon: Icons.groups,
                                  isLoading: _isLoadingOrgs,
                                  loadingText: 'Loading organizations...',
                                  items: _organizations.map((org) {
                                    return DropdownMenuItem<String>(
                                      value: org['id'] as String,
                                      child: Text(
                                        '${org['abbrv']} - ${org['name']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppDesign.bodyStyle,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(() => _selectedOrgId = value),
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
                                    onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                  ),
                                ),

                                // Confirm Password field
                                const SizedBox(height: 12),
                                GradientBorderTextFormField(
                                  controller: _confirmPasswordController,
                                  hintText: 'Confirm Password',
                                  obscureText: !_confirmPasswordVisible,
                                  prefixIcon: GradientIcon(
                                    icon: Icons.lock,
                                    size: AppDesign.sIconSize,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: GradientIcon(
                                      icon: _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      size: AppDesign.sIconSize,
                                    ),
                                    onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
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
                                    child: Text(
                                      'Sign Up',
                                      style: AppDesign.buttonTextStyle,
                                    ),
                                  ),
                                ),

                                //Question field
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: AppDesign.bodyStyle.copyWith(color: Colors.black45)
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        'Log In now',
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
