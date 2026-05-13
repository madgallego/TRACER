import 'package:flutter/material.dart';
import 'package:tracer/utils/constants.dart';
import 'package:tracer/utils/feedback_helper.dart';

class WarningSnackbar extends SnackBar {
  final String msg;
  final IconData? icon;

  static void show(BuildContext context, String message, {IconData? icon}) {
    FeedbackHelper.errorFeedback();

    ScaffoldMessenger.of(context).showSnackBar(
      WarningSnackbar(msg: message, icon: icon,)
    );
  }

  WarningSnackbar({
    super.key,
    required this.msg,
    this.icon,
  }) : super(
          // Snackbar properties
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20),
          duration: Duration(hours: 1),

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
                  color: AppDesign.warningOrange,
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
                      icon ?? Icons.warning_amber_rounded,
                      color: AppDesign.warningOrange,
                      size: 36.0,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                      child: Text(
                        msg,
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
