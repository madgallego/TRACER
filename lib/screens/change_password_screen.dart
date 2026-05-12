import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_button.dart';
import '../widgets/gradient_border_text_form_field.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/gradient_border_snackbar.dart';
import '../widgets/error_snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isUpdating = false;
  bool _passwordVisible = false;
  bool _confirmVisible = false;

  Future<void> _changePassword() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      ErrorSnackbar.show(context, 'Please fill in all fields.');
      return;
    }
    if (password.length < 6) {
      ErrorSnackbar.show(context, 'Password must be at least 6 characters.');
      return;
    }
    if (password != confirm) {
      ErrorSnackbar.show(context, 'Passwords do not match.');
      return;
    }

    setState(() => _isUpdating = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      if (mounted) {
        await Supabase.instance.client.auth.signOut();
        
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          GradientBorderSnackbar(message: 'Password changed successfully!'),
        );
      }
    } catch (e) {
      if (mounted) ErrorSnackbar.show(context, 'Failed to update password. Try again.');
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _handleCancel() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleCancel();
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(), 
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                  ),
                ),
              ),

              // Main Content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              
                              Text(
                                'Create New Password',
                                style: AppDesign.headingStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please enter your new password below. Try not to forget it this time!',
                                style: AppDesign.bodyStyle.copyWith(color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              
                              // Password Field
                              GradientBorderTextFormField(
                                controller: _passwordController,
                                hintText: 'New Password',
                                obscureText: !_passwordVisible,
                                prefixIcon: GradientIcon(icon: Icons.lock, size: AppDesign.sIconSize),
                                suffixIcon: IconButton(
                                  icon: GradientIcon(
                                    icon: _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    size: AppDesign.sIconSize,
                                  ),
                                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Confirm Password Field
                              GradientBorderTextFormField(
                                controller: _confirmController,
                                hintText: 'Confirm New Password',
                                obscureText: !_confirmVisible,
                                prefixIcon: GradientIcon(icon: Icons.lock_outline, size: AppDesign.sIconSize),
                                suffixIcon: IconButton(
                                  icon: GradientIcon(
                                    icon: _confirmVisible ? Icons.visibility : Icons.visibility_off,
                                    size: AppDesign.sIconSize,
                                  ),
                                  onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              // Change Password Button
                              SizedBox(
                                height: 50.0,
                                child: GradientBorderButton(
                                  onPressed: _isUpdating ? () async {} : _changePassword,
                                  child: _isUpdating
                                      ? const SizedBox(
                                          height: 20, 
                                          width: 20, 
                                          child: CircularProgressIndicator(strokeWidth: 2)
                                        )
                                      : const Text('Change Password', style: AppDesign.buttonTextStyle),
                                ),
                              ),

                              const SizedBox(height: 12),

                              SizedBox(
                                height: 50.0,
                                child: GradientBorderButton(
                                  borderColor: AppDesign.dangerRed,
                                  onPressed: _handleCancel,
                                  child: Text(
                                    'Cancel and return to Login',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}