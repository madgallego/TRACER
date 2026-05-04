import 'package:flutter/material.dart';
import 'package:tracer/utils/constants.dart';
import 'package:tracer/utils/feedback_helper.dart';

class ErrorSnackbar extends SnackBar {
  final String errorMsg;

  static void show (BuildContext context, String message) {
    FeedbackHelper.errorFeedback();

    ScaffoldMessenger.of(context).showSnackBar(
      ErrorSnackbar(errorMsg: message)
    );
  }

  ErrorSnackbar({
    super.key,
    required this.errorMsg,
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

            // Container with red border
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: BoxBorder.all(
                  color: AppDesign.dangerRed,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),

              // Icon and message
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: AppDesign.dangerRed,
                      size: 36.0,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                      child: Text(
                        errorMsg,
                        style: AppDesign.buttonTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
