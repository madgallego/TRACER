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
  static const Color appYellow = Color(0xff67f5fa);
  static const Color appPaleCyan = Color(0xff67f5fa);
  static const Color appOffblack = Color(0xff302e34);
  // static const Color white = Color(0xffffffff); just use Colors.white

  // Gradient Colors
  static const Color primaryGradientStart = Color(0xff67f5fa);
  static const Color primaryGradientEnd = Color(0xffffe161);

  static final BorderRadius bottomBarBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0)
  );

  static final BorderRadius sBtnBorderRadius = BorderRadius.circular(30.0);
  static final BorderRadius mBtnBorderRadius = BorderRadius.circular(60.0); // currently unused and might change
  static final BorderRadius lBtnBorderRadius = BorderRadius.circular(90.0); // currently unused and might change

  static final double sBtnIconSize = 24.0;
  static final double mBtnIconSize = 36.0; // currently unused and might change
  static final double lBtnIconSize = 48.0; // currently unused and might change

  // Gradient widgets loading animations
  static final Duration loadingRotationDuration = Duration(milliseconds: 700);
  static final Curve loadingRotationEasing = Curves.easeOutQuart;

}
