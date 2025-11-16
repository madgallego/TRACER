import 'package:flutter/material.dart';

class GradientBorderButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double borderWidth;
  final LinearGradient gradient;
  final BorderRadius? borderRadius;
  final Color innerColor;

  const GradientBorderButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderWidth = 3.0,
    required this.gradient,
    this.borderRadius,
    this.innerColor = Colors.white,
  });

  @override
  State<GradientBorderButton> createState() => _GradientBorderButtonState();
}

class _GradientBorderButtonState extends State<GradientBorderButton> {
  bool _isPressed = false;

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
  Widget build(BuildContext context) {
    final outerRadius = widget.borderRadius;

    // Dynamic shadows for depressed effect when pressed
    final double targetBlur = _isPressed ? 5.0 : 2.0;
    final double targetOffset = _isPressed ? 1.0 : 2.0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: outerRadius ?? BorderRadius.circular(10.0),
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
      padding: EdgeInsets.all(widget.borderWidth),

      // Ink well implements ripple effect on tap, as well as tap detection
      // Material allows ink well to paint this effect
      child: Material(
        color: widget.innerColor,
        borderRadius: outerRadius != null
          ? _calculateInnerRadius(outerRadius)
          : BorderRadius.circular(10.0 - widget.borderWidth),
        child: InkWell(
          onTap: widget.onPressed,

          onHighlightChanged: (isHighlighting) {
            setState(() {
              _isPressed = isHighlighting;
            });
          },

          borderRadius: outerRadius != null
            ? _calculateInnerRadius(outerRadius)
            : BorderRadius.circular(10.0 - widget.borderWidth),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: outerRadius != null
                ? _calculateInnerRadius(outerRadius)
                : BorderRadius.circular(10.0 - widget.borderWidth),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
