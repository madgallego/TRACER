import 'package:flutter/material.dart';

abstract class AppDesign {
  // --- Camera Preview Constants ---

  // Sizes
  static const double camWidth = 330.0;
  static const double camHeight = 400.0;
  static const double camBorderThickness = 7.0;
  static const double camTopPadding = 70.0;
  static const double scanButtonBottomSpacing = 40.0;


  // Border Radii
  static const double camOuterBorderRadius = 25.0;
  static const double camInnerBorderRadius = camOuterBorderRadius - camBorderThickness;

  // Colors
  static const Color primaryGradientStart = Color(0xff67f5fa);
  static const Color primaryGradientEnd = Color(0xffffe161);
}
