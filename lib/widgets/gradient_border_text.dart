import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:tracer/utils/constants.dart';
import 'package:tracer/utils/process_state.dart';

class GradientBorderText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final double borderWidth;
  final LinearGradient gradient;
  final BorderRadius? borderRadius;
  final Color innerColor;

  const GradientBorderText({
    super.key,
    required this.text,
    required this.textStyle,
    this.borderWidth = 3.0,
    required this.gradient,
    this.borderRadius,
    this.innerColor = Colors.white,
  });

  @override
  State<GradientBorderText> createState() => _GradientBorderTextState();
  
}