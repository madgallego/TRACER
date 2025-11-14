import 'package:flutter/material.dart';

abstract class AppDesign {
  // Sizes
  static const double cameraPreviewWidth = 300.0;
  static const double cameraPreviewHeight = 400.0;
  static const double cameraPreviewborderThickness = 7.0;

  // Border Radii
  static const double cameraPreviewOuterBorderRadius = 25.0;
  static const double cameraPreviewInnerBorderRadius = cameraPreviewOuterBorderRadius - cameraPreviewborderThickness;

  // Colors
  static const Color primaryGradientStart = Color(0xff67f5fa);
  static const Color primaryGradientEnd = Color(0xffffe161);
}
