import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
