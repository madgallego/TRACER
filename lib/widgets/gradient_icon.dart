import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:tracer/utils/constants.dart';
import 'package:tracer/utils/process_state.dart';

class GradientIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.gradient,
  });

  @override
  State<GradientIcon> createState() => _GradientIconState();
}

class _GradientIconState extends State<GradientIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: AppDesign.loadingRotationDuration,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: AppDesign.loadingEasing
      )
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isProcessStateAvailable = true;

    // Since gradient icons can also exist outside of a GradientBorderButton,
    // we need to check if the ProcessState provider exists first
    try {
      Provider.of<ProcessState>(context, listen: false);
    } on ProviderNotFoundException {
      isProcessStateAvailable = false;
    }

    final bool isLoading = isProcessStateAvailable
    ? context.watch<ProcessState>().isLoading
    : false;

    if (isLoading) {
      _rotationController.repeat();
    } else {
      _rotationController.reset();
    }

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: widget.gradient.colors,
              transform: GradientRotation(_animation.value),
            ).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            );
          },
          // Use source image as mask for the gradient
          blendMode: BlendMode.srcIn,

          child: child
        );
      },
      child: Icon(
            widget.icon,
            size: widget.size,
            color: Colors.white, // White is best for masking
      ),
    );
  }
}
