import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracer/utils/connectivity_state.dart';
import 'dart:math' as math;

import 'package:tracer/utils/constants.dart';
import 'package:tracer/utils/process_state.dart';

class GradientBorderButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;
  final double borderWidth;
  final LinearGradient? borderGradient;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color innerColor;
  final bool isInternetRequired;

  const GradientBorderButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderWidth = 2.0,
    this.borderGradient,
    this.borderColor,
    this.borderRadius,
    this.innerColor = Colors.white,
    this.isInternetRequired = false,
  }) : assert(
    borderColor == null || borderGradient == null,
    'Cannot provide both a color and a gradient'
  );

  @override
  State<GradientBorderButton> createState() => _GradientBorderButtonState();
}

class _GradientBorderButtonState extends State<GradientBorderButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  late AnimationController _rotationController;
  late Animation<double> _animation;

  BorderRadius _calculateInnerRadius(BorderRadius outerRadius) {
    Radius topLeft = Radius.elliptical(
      outerRadius.topLeft.x - widget.borderWidth,
      outerRadius.topLeft.y - widget.borderWidth
    );
    Radius bottomLeft = Radius.elliptical(
      outerRadius.bottomLeft.x - widget.borderWidth,
      outerRadius.bottomLeft.y - widget.borderWidth
    );
    Radius topRight = Radius.elliptical(
      outerRadius.topRight.x - widget.borderWidth,
      outerRadius.topRight.y - widget.borderWidth
    );
    Radius bottomRight = Radius.elliptical(
      outerRadius.bottomRight.x - widget.borderWidth,
      outerRadius.bottomRight.y - widget.borderWidth
    );

    return BorderRadius.only(
      topLeft: topLeft,
      bottomLeft: bottomLeft,
      topRight: topRight,
      bottomRight: bottomRight
    );
  }

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: AppDesign.loadingRotationDuration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: AppDesign.loadingRotationEasing
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
    final outerRadius = widget.borderRadius ?? AppDesign.defaultCircularBorderRadius;

    // Dynamic shadows for depressed effect when pressed
    final double targetBlur = _isPressed ? 5.0 : 2.0;
    final double targetOffset = _isPressed ? 1.0 : 2.0;

    // If no color or gradient supplied, use default app gradient
    final effectiveGradient = (widget.borderColor == null && widget.borderGradient == null)
      ? AppDesign.primaryGradient
      : widget.borderGradient;

    final bool isBtnEnabled = widget.isInternetRequired
      ? context.watch<ConnectivityState>().isOnline
      : true;

    // Apply grayscale filter on whole button when it is disabled
    final ColorFilter colorFilter = isBtnEnabled
      ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
      : ColorFilter.mode(Colors.grey, BlendMode.saturation);

    return ChangeNotifierProvider(
      create: (context) => ProcessState(),
      builder: (context, child) {
        final processState = context.watch<ProcessState>();

        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {

            // An issue with Flutter makes ColorFiltered apply outside of the child's boundaries
            // Wrapping the color filter with a Clip widget fixes this issue
            // We use ClipRRect instead of ClipRect due to the rounded corners of the button
            // Shadows have to be applied outside the ClipRRect
            // More information: https://github.com/flutter/flutter/issues/98809
            return Container(
              decoration: BoxDecoration(
                borderRadius: outerRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    offset: Offset(0, targetOffset),
                    blurRadius: targetBlur,
                    spreadRadius: 0
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 1),
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  )
                ]
              ),
              child: ClipRRect(
                borderRadius: outerRadius,

                child: ColorFiltered(
                  colorFilter: colorFilter,

                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.borderColor,
                      gradient: effectiveGradient?.withTransform(
                        GradientRotation(_animation.value)
                      ),
                      borderRadius: outerRadius,
                    ),
                    padding: EdgeInsets.all(widget.borderWidth),
                    child: child,
                  ),
                ),
              ),
            );
          },
          // Ink well implements ripple effect on tap, as well as tap detection
          // Material allows ink well to paint this effect
          child: Material(
            color: widget.innerColor,
            borderRadius: _calculateInnerRadius(outerRadius),
            child: InkWell(
              onTap: isBtnEnabled ? () async {
                if (processState.isLoading) return;

                processState.setLoading(true);
                _rotationController.repeat();

                try {
                  await widget.onPressed();
                } catch (e) {
                  debugPrint("Process failed: $e");
                } finally {
                  processState.setLoading(false);
                  _rotationController.reset();
                }
              } : null,

              onHighlightChanged: (isHighlighting) {
                setState(() {
                  _isPressed = isHighlighting;
                });
              },

              borderRadius: _calculateInnerRadius(outerRadius),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _calculateInnerRadius(outerRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Center(child: widget.child),
              ),
            ),
          ),
        );
      }
    );
  }
}
