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
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          
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
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(3.5), // border width

              // Inner container with the message
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message, 
                  style: const TextStyle(
                    color: AppDesign.appOffblack,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}