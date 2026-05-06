import 'package:flutter/material.dart';
import 'package:tracer/auth/auth_service.dart';
import 'package:tracer/widgets/gradient_border_button.dart';
import 'package:tracer/widgets/gradient_icon.dart';
import 'package:tracer/widgets/labeled_widgets.dart';
import 'package:tracer/widgets/titled_card.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_snackbar.dart';
import '../widgets/gradient_border_text_form_field.dart';
import '../widgets/app_bottom_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService(Supabase.instance.client);
  final double mainColumnSpacing = 20.0;
  final double sectionSpacing = 60.0;

  void logout() async {
    await authService.logOut();

    if (mounted) {
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      ScaffoldMessenger.of(context).showSnackBar(
        GradientBorderSnackbar(message: 'Log out successful!')
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: AppDesign.appLightGray,
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  spacing: mainColumnSpacing,
                  children: [
                    Center(
                      child: GradientIcon(
                        icon: Icons.account_circle,
                        size: 96.0,
                        gradient: LinearGradient(
                          colors: [
                            AppDesign.primaryGradientStart,
                            AppDesign.primaryGradientEnd,
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: sectionSpacing,
                        children: [
                          TitledCard(
                            title: 'Profile Details',
                            icon: GradientIcon(
                              icon: Icons.account_circle,
                              size: 28.0,
                              gradient: LinearGradient(
                                colors: [
                                  AppDesign.primaryGradientStart,
                                  AppDesign.primaryGradientEnd,
                                ],
                              ),
                            ),
                            children: [
                              _LabeledText(
                                label: 'Full Name',
                                value: '',
                              ),
                              _LabeledText(
                                label: 'Email',
                                value: '',
                              ),
                              _LabeledText(
                                label: 'Student Number',
                                value: '',
                              ),
                              _LabeledText(
                                label: 'Year and Bloc',
                                value: '',
                              ),
                              _LabeledText(
                                label: 'Organization',
                                value: '',
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                                child: GradientBorderButton(
                                  onPressed: () async {
                                    // Edit logic here
                                  },
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppDesign.primaryGradientStart,
                                      AppDesign.primaryGradientEnd
                                    ]
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                              )
                            ]
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              spacing: mainColumnSpacing,
                              children: [
                                GradientBorderButton(
                                  onPressed: () async {
                                    AppBottomSheet.show(
                                      context,
                                      icon: Icons.lock,
                                      title: 'Change Password',
                                      child: _ChangePasswordForm(authService: authService),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppDesign.dangerRed,
                                      AppDesign.dangerRed,
                                    ]
                                  ),
                                  child: Text(
                                    'Change Password',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                                GradientBorderButton(
                                  onPressed: () async {
                                    logout();
                                  },
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                    ]
                                  ),
                                  child: Text(
                                    'Log Out',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                                Text(
                                  'TRACER v2',
                                  style: AppDesign.bodyStyle,
                                ),
                                SizedBox(height: sectionSpacing-30.0)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

class _LabeledText extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledText({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesign.bodyStyle,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppDesign.appLightGray,
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Text(
            value,
            style: AppDesign.bodyStyle,
          ),
        ),
      ],
    );
  }
}

class _ChangePasswordForm extends StatefulWidget {
  final AuthService authService;

  const _ChangePasswordForm({required this.authService});

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isChangingPassword = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }

    if (newPassword.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    if (newPassword == currentPassword) {
      _showError('New password must be different from current password.');
      return;
    }

    setState(() => _isChangingPassword = true);

    try {
      final email = widget.authService.getCurrentUserEmail();
      if (email == null) {
        _showError('Unable to get user email.');
        return;
      }

      await widget.authService.logIn(email, currentPassword);
      await widget.authService.changePassword(newPassword);

      if (mounted) {
        final parentContext = context;
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ScaffoldMessenger.of(parentContext).showSnackBar(
              GradientBorderSnackbar(message: 'Password changed successfully!'),
            );
          }
        });
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
    }
  }

  void _showError(String message) {
    final parentContext = context;
    Navigator.pop(context);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        ScaffoldMessenger.of(parentContext).hideCurrentSnackBar();
        ScaffoldMessenger.of(parentContext).showSnackBar(
          GradientBorderSnackbar(message: message),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Current password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientTextFormField(
          controller: _currentPasswordController,
          obscureText: !_currentPasswordVisible,
          fillColor: AppDesign.appLightGray,
          borderRadius: BorderRadius.circular(30),
          activeGradient: const LinearGradient(
            colors: [
              AppDesign.primaryGradientStart,
              AppDesign.primaryGradientEnd,
            ],
          ),
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _currentPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sBtnIconSize,
              gradient: const LinearGradient(
                colors: [
                  AppDesign.primaryGradientStart,
                  AppDesign.primaryGradientEnd,
                ],
              ),
            ),
            onPressed: () =>
                setState(() => _currentPasswordVisible = !_currentPasswordVisible),
          ),
        ),
        const SizedBox(height: 12),
        Text('New password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientTextFormField(
          controller: _newPasswordController,
          obscureText: !_newPasswordVisible,
          fillColor: AppDesign.appLightGray,
          borderRadius: BorderRadius.circular(30),
          activeGradient: const LinearGradient(
            colors: [
              AppDesign.primaryGradientStart,
              AppDesign.primaryGradientEnd,
            ],
          ),
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _newPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sBtnIconSize,
              gradient: const LinearGradient(
                colors: [
                  AppDesign.primaryGradientStart,
                  AppDesign.primaryGradientEnd,
                ],
              ),
            ),
            onPressed: () =>
                setState(() => _newPasswordVisible = !_newPasswordVisible),
          ),
        ),
        const SizedBox(height: 12),
        Text('Confirm new password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientTextFormField(
          controller: _confirmPasswordController,
          obscureText: !_confirmPasswordVisible,
          fillColor: AppDesign.appLightGray,
          borderRadius: BorderRadius.circular(30),
          activeGradient: const LinearGradient(
            colors: [
              AppDesign.primaryGradientStart,
              AppDesign.primaryGradientEnd,
            ],
          ),
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sBtnIconSize,
              gradient: const LinearGradient(
                colors: [
                  AppDesign.primaryGradientStart,
                  AppDesign.primaryGradientEnd,
                ],
              ),
            ),
            onPressed: () =>
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
          ),
        ),
        const SizedBox(height: 24),
        GradientBorderButton(
          onPressed: _isChangingPassword ? () async {} : _changePassword,
          gradient: const LinearGradient(
            colors: [
              AppDesign.primaryGradientStart,
              AppDesign.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          child: _isChangingPassword
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Save', style: AppDesign.buttonTextStyle),
        ),
      ],
    );
  }
}
