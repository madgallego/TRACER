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
            ]
          )
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30.0
            ),
            child: Container( 
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20.0,
                children: [
                  Text(
                    'SETTINGS (wip :D)',
                    style: TextStyle(
                      fontFamily: "AROneSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
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