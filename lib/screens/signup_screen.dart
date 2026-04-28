import 'package:flutter/material.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_text.dart';
import '../widgets/gradient_border_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _firstNameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentIdController = TextEditingController();

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
    _firstNameController.dispose();
    _middleInitialController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  // Sign up function
  Future<void> signup() async {
    final firstName = _firstNameController.text.trim();
    final middleInitial = _middleInitialController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Please enter your first and last name.')
        );
      }
      return;
    }

    if (_selectedOrgId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Please select your organization.')
        );
      }
      return;
    }

    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Passwords do not match. Please try again.')
        );
      }
      return;
    }
    
    if (_studentIdController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Please enter your student ID.')
        );
      }
      return;
    }

    try {
      await authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        middleInitial: middleInitial,
        lastName: lastName,
        orgId: _selectedOrgId!,
        studentId: _studentIdController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Sign up successful! Please check your email to verify your account and proceed to log in.')
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Sign up failed: $e.')
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

                                // First name field
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _firstNameController,
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: GradientIcon(
                                      icon: Icons.person,
                                      size: AppDesign.sBtnIconSize,
                                      gradient: LinearGradient(colors: [
                                        AppDesign.primaryGradientStart,
                                        AppDesign.primaryGradientEnd
                                      ]),
                                    ),
                                  ),
                                ),

                                // Middle name field
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _middleInitialController,
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  decoration: InputDecoration(
                                    hintText: 'Middle Initial (Optional)',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: GradientIcon(
                                      icon: Icons.person_outline,
                                      size: AppDesign.sBtnIconSize,
                                      gradient: LinearGradient(colors: [
                                        AppDesign.primaryGradientStart,
                                        AppDesign.primaryGradientEnd
                                      ]),
                                    ),
                                  ),
                                ),

                                // Last name field
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _lastNameController,
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: GradientIcon(
                                      icon: Icons.person,
                                      size: AppDesign.sBtnIconSize,
                                      gradient: LinearGradient(colors: [
                                        AppDesign.primaryGradientStart,
                                        AppDesign.primaryGradientEnd
                                      ]),
                                    ),
                                  ),
                                ),

                                // Student ID field
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _studentIdController,
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Student ID',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: GradientIcon(
                                      icon: Icons.badge,
                                      size: AppDesign.sBtnIconSize,
                                      gradient: LinearGradient(colors: [
                                        AppDesign.primaryGradientStart,
                                        AppDesign.primaryGradientEnd
                                      ]),
                                    ),
                                  ),
                                ),

                                // Organization dropdown
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      GradientIcon(
                                        icon: Icons.groups,
                                        size: AppDesign.sBtnIconSize,
                                        gradient: LinearGradient(colors: [
                                          AppDesign.primaryGradientStart,
                                          AppDesign.primaryGradientEnd,
                                        ]),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: _isLoadingOrgs
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16),
                                                child: Text(
                                                  'Loading organizations...',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontFamily: "AROneSans",
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            : DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedOrgId,
                                                  isExpanded: true,
                                                  borderRadius: BorderRadius.circular(16),
                                                  dropdownColor: Colors.white,
                                                  icon: GradientIcon(
                                                    icon: Icons.arrow_drop_down,
                                                    size: AppDesign.sBtnIconSize,
                                                    gradient: LinearGradient(colors: [
                                                      AppDesign.primaryGradientStart,
                                                      AppDesign.primaryGradientEnd,
                                                    ]),
                                                  ),
                                                  hint: const Text(
                                                    'Select Organization',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontFamily: "AROneSans",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "AROneSans",
                                                    fontSize: 16,
                                                  ),
                                                  items: _organizations.map((org) {
                                                    return DropdownMenuItem<String>(
                                                      value: org['id'] as String,
                                                      child: Text(
                                                        '${org['abbrv']} - ${org['name']}',
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() => _selectedOrgId = value);
                                                  },
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Email field
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
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
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
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
                                  style: const TextStyle(color: Colors.black, fontFamily: "AROneSans"),
                                  obscureText: !_confirmPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
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
                                        fontFamily: "AROneSans"
                                      ),
                                    ),
                                  ),
                                ),

                                //Question field
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Already have an account? ",
                                      style: TextStyle(color: Colors.black45, fontFamily: "AROneSans"),
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
                                        style: TextStyle(
                                          color: AppDesign.primaryGradientEnd,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "AROneSans"
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
