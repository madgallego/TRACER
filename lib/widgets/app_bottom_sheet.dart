import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/gradient_icon.dart';

class AppBottomSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const AppBottomSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  // Static helper to show the bottom sheet easily from anywhere
  static void show(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        icon: icon,
        title: title,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header row
                Row(
                  children: [
                    GradientIcon(
                      icon: icon,
                      size: 28,
                      gradient: const LinearGradient(colors: [
                        AppDesign.primaryGradientStart,
                        AppDesign.primaryGradientEnd,
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: AppDesign.subHeading1Style.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Gradient divider
                Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Flexible content
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}