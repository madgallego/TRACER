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
import '../widgets/error_snackbar.dart';
import '../utils/formatters.dart';
import 'package:flutter/services.dart';
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
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = true;
  String _fullName = '';
  String _email = '';
  String _studentNumber = '';
  String _yearAndBloc = '';
  String _organization = '';

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = Supabase.instance.client.auth.currentSession?.user.id;
      if (userId == null) return;
      debugPrint('Current user ID: $userId'); // Debug print to check the user ID

      // Fetch finance officer details
      final foResponse = await Supabase.instance.client
          .from('finance_officers')
          .select('''
            email,
            student_id,
            organization_id,
            students_for_functions(stud_fn, stud_mi, stud_ln, yearlevel, bloc)
          ''')
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();

      if (foResponse == null) {
        debugPrint('No finance officer record found for this user ID.');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      debugPrint('FO Response: $foResponse'); // Debug print to check the response data

      // Extract student data from the joined table
      final studentData = foResponse['students_for_functions'] as Map<String, dynamic>?;

      // Fetch organization name
      final orgResponse = await Supabase.instance.client
          .from('organizations')
          .select('name')
          .eq('id', foResponse!['organization_id'].toString())
          .limit(1)
          .maybeSingle();

      debugPrint('Org ID being queried: ${foResponse['organization_id']}'); // Debug print to check the organization ID

      // Format full name
      final mi = (studentData?['stud_mi'] != null && studentData?['stud_mi'].toString().isNotEmpty == true)
          ? "${studentData!['stud_mi']}. "
          : "";
      final fullName = "${studentData?['stud_fn'] ?? ''} $mi${studentData?['stud_ln'] ?? ''}".trim();

      // Format year and bloc
      final year = studentData?['yearlevel']?.toString() ?? '';
      final bloc = studentData?['bloc']?.toString() ?? '';
      final yearAndBloc = year.isNotEmpty && bloc.isNotEmpty ? "$year - $bloc" : year.isNotEmpty ? year : bloc;

      // Format student number
      final studentID = foResponse['student_id']?.toString() ?? '';
      String studentNumber = studentID;
      if (studentID.length >= 13) {
        studentNumber = '${studentID.substring(0, 4)}-${studentID.substring(4, 8)}-${studentID.substring(8, 13)}';
      } else if (studentID.length == 12) {
        studentNumber = '${studentID.substring(0, 4)}-${studentID.substring(4, 8)}-${studentID.substring(8, 12)}';
      }

      debugPrint('FO Response: $foResponse'); // Debug print to check the response data

      if (mounted) {
        setState(() {
          _fullName = fullName;
          _email = foResponse['email'] ?? '';
          _studentNumber = studentNumber;
          _yearAndBloc = yearAndBloc;
          _organization = orgResponse?['name'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                        size: AppDesign.lIconSize,
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
                          _isLoading
                            ? const Center (child: CircularProgressIndicator())
                            : TitledCard(
                              title: 'Profile Details',
                              icon: GradientIcon(
                                icon: Icons.account_circle,
                                size: AppDesign.sIconSize,
                              ),
                              children: [
                                _LabeledText(
                                  label: 'Full Name',
                                  value: _fullName,
                                ),
                                _LabeledText(
                                  label: 'Email',
                                  value: _email,
                                ),
                                _LabeledText(
                                  label: 'Student Number',
                                  value: _studentNumber,
                                ),
                                _LabeledText(
                                  label: 'Year and Bloc',
                                  value: _yearAndBloc,
                                ),
                                _LabeledText(
                                  label: 'Organization',
                                  value: _organization,
                                ),
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
                                      child: _ChangePasswordForm(
                                        authService: authService,
                                        currentPasswordController: _currentPasswordController,
                                        newPasswordController: _newPasswordController,
                                        confirmPasswordController: _confirmPasswordController,
                                      ),
                                    );
                                  },
                                  borderColor: AppDesign.dangerRed,
                                  child: Text(
                                    'Change Password',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                                GradientBorderButton(
                                  onPressed: () async {
                                    logout();
                                  },
                                  borderColor: Colors.white,
                                  child: Text(
                                    'Log Out',
                                    style: AppDesign.buttonTextStyle,
                                  ),
                                ),
                                Text(
                                  'TRACER v2.0.0',
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
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const _ChangePasswordForm({
    required this.authService,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isChangingPassword = false;

  Future<void> _changePassword() async {
    final currentPassword = widget.currentPasswordController.text.trim();
    final newPassword = widget.newPasswordController.text.trim();
    final confirmPassword = widget.confirmPasswordController.text.trim();

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
        widget.currentPasswordController.clear();
        widget.newPasswordController.clear();
        widget.confirmPasswordController.clear();
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
      if (mounted) {
        final parentContext = context;
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 100), () {
          ErrorSnackbar.show(parentContext, 'Incorrect current password.');
        });
      }
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
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
        Text('Current password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientBorderTextFormField(
          controller: widget.currentPasswordController,
          obscureText: !_currentPasswordVisible,
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _currentPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sIconSize,
            ),
            onPressed: () =>
                setState(() => _currentPasswordVisible = !_currentPasswordVisible),
          ),
        ),
        const SizedBox(height: 10),
        Text('New password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientBorderTextFormField(
          controller: widget.newPasswordController,
          obscureText: !_newPasswordVisible,
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _newPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sIconSize,
            ),
            onPressed: () =>
                setState(() => _newPasswordVisible = !_newPasswordVisible),
          ),
        ),
        const SizedBox(height: 10),
        Text('Confirm new password',
            style: AppDesign.bodyStyle),
        const SizedBox(height: 5),
        GradientBorderTextFormField(
          controller: widget.confirmPasswordController,
          obscureText: !_confirmPasswordVisible,
          suffixIcon: IconButton(
            icon: GradientIcon(
              icon: _confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: AppDesign.sIconSize,
            ),
            onPressed: () =>
                setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
          ),
        ),
        const SizedBox(height: 20),
        GradientBorderButton(
          onPressed: _isChangingPassword ? () async {} : _changePassword,
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
