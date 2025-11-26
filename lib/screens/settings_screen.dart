import 'package:flutter/material.dart';
import 'package:tracer/auth/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_border_snackbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Auth service instance
  final authService = AuthService();

  // Log out function
  void logout() async {
    await authService.logOut();

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        GradientBorderSnackbar(message: 'Log out successful!')
      );
    }
  }

  // Settings UI
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppDesign.primaryGradientStart,
              AppDesign.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
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
                spacing: 20.0,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: "AROneSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),

                  SizedBox(height: 10.00),

                  Placeholder(fallbackHeight: 300.00),

                  ElevatedButton(
                    onPressed: () {
                      logout();
                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),

                    child: Text(
                      'Log Out',
                      style: TextStyle(
                      fontFamily: "AROneSans",
                      color: AppDesign.appOffblack,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
