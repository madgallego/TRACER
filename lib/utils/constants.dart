import 'package:flutter/material.dart';

abstract class AppDesign {
  // --- Camera Preview Constants ---

  // Sizes
  static const double camMaxWidth = 400.0;
  static const double camMaxHeight = 700.0;
  static const double camBorderThickness = 7.0;
  static const double camTopPadding = 70.0;

  // Border Radii
  static const double camOuterBorderRadius = 25.0;
  static const double camInnerBorderRadius = camOuterBorderRadius - camBorderThickness;

  // Button Bar
  static const double camBtnWidth = 60.0;
  static const double camBtnHeight = 50.0;

  // --- General Design Constants ---

  // Text Styles

  // Use for Screen Titles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: appOffblack,
    letterSpacing: -0.5,
  );

  // Use for Section Headers or Card Titles, normal weight
  static const TextStyle subHeading1Style = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: appOffblack,
  );

  // Slightly larger than body text, in normal weight
  static const TextStyle subHeading2Style = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: appOffblack,
  );

  // Standard body text for descriptions and messages
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'IBMPlexSans', // Needed for _Popup
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: appOffblack,
    height: 1.4,
  );

  /// Specific style for Button labels
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: appOffblack,
  );

  // Box Shadows
  static final defaultBoxShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.14),
      offset: const Offset(0, 2),
      blurRadius: 2.0,
      spreadRadius: 0.0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      offset: const Offset(0, 1),
      blurRadius: 5.0,
      spreadRadius: 0.0,
    )
  ];

  // Color pallete
  static const Color appBlue = Color(0xff67f5fa);
  static const Color appYellow = Color(0xffffe161);
  static const Color appPaleCyan = Color(0xffe2fff8);
  static const Color appOffblack = Color(0xff302e34);
  static const Color appLightGray = Color(0xfff1f1f1);
  static const Color disabledGray = Color(0xffc4c4c4);
  static const Color dangerRed = Color(0xfff44336);
  static const Color warningOrange = Color(0xffffcb59);
  // static const Color white = Color(0xffffffff); just use Colors.white

  // Gradient related
  static const Color primaryGradientStart = Color(0xff67f5fa);
  static const Color primaryGradientEnd = Color(0xffffe161);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primaryGradientStart,
      primaryGradientEnd,
    ]
  );

  static final BorderRadius bottomBarBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0)
  );

  static final BorderRadius defaultCircularBorderRadius = BorderRadius.circular(30.0);

  static final double xsIconSize = 18.0;
  static final double sIconSize = 24.0;
  static final double mIconSize = 48.0;
  static final double lIconSize = 96.0;

  // Gradient widgets loading animations
  static final Duration loadingRotationDuration = Duration(milliseconds: 700);
  static final Curve loadingRotationEasing = Curves.easeOutQuart;
}

extension GradientCopy on LinearGradient {
  LinearGradient withTransform(GradientTransform dynamicTransform) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
      tileMode: tileMode,
      transform: dynamicTransform,
    );
  }
}
