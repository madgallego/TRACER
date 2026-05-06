import 'package:flutter/material.dart';
import 'package:tracer/utils/constants.dart';

class GradientBorderSnackbar extends SnackBar {
  final String message;

  GradientBorderSnackbar({
    super.key,
    required this.message,
  }) : super(
          // Snackbar properties
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20),
          
          // Animation of the snackbar
          content: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0), 
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut, 
            
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },

            // Outer container with gradient border
            child: Container(
              padding: const EdgeInsets.all(2), // Border width
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppDesign.primaryGradientStart,
                    AppDesign.primaryGradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppDesign.appPaleCyan,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  message, 
                  style: AppDesign.buttonTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}