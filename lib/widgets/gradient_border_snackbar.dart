import 'package:flutter/material.dart';
import 'package:tracer/utils/constants.dart';

class GradientBorderSnackbar extends StatelessWidget {
  const GradientBorderSnackbar({
    super.key,
    required this.e,
  });

  final Object e;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      // Gradient border for the snackbar with pop up animation
      content: TweenAnimationBuilder<double>(
        // Animation
        tween: Tween(begin: 0.0, end: 1.0), 
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut, // Pop up effect
        
        builder: (context, value, child) {
          // Apply the animation value to the scale
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
    
        // Outer container with gradient border
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [ AppDesign.primaryGradientStart,AppDesign.primaryGradientEnd],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4),
        
          // Text displaying the error message
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Login failed: $e',
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center
            ),
          )
        ),
      )
    );
  }
}