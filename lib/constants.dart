import 'package:flutter/material.dart';

abstract class AppDesign {
  // --- Camera Preview Constants ---

  // Sizes
  static const double camWidth = 330.0;
  static const double camHeight = 500.0;
  static const double camBorderThickness = 7.0;
  static const double camTopPadding = 70.0;
  static const double scanButtonBottomSpacing = 40.0;


  // Border Radii
  static const double camOuterBorderRadius = 25.0;
  static const double camInnerBorderRadius = camOuterBorderRadius - camBorderThickness;

  // Colors
  static const Color primaryGradientStart = Color(0xff67f5fa);
  static const Color primaryGradientEnd = Color(0xffffe161);


  // --- General Design Constants ---
  static final defaultBoxShadow = BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      offset: Offset(4, 4),
      blurRadius: 10.0,
      spreadRadius: 2.0,
  );

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
}
