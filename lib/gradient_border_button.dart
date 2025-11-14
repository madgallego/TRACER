import 'package:flutter/material.dart';

class GradientBorderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double borderWidth;
  final LinearGradient gradient;
  final BorderRadius? borderRadius;
  final Color innerColor;
  final List<BoxShadow>? boxShadow;

  const GradientBorderButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderWidth = 3.0,
    required this.gradient,
    this.borderRadius,
    this.innerColor = Colors.white,
    this.boxShadow,
  });

  BorderRadius _calculateInnerRadius(BorderRadius outerRadius) {
    Radius topLeft = Radius.elliptical(
      outerRadius.topLeft.x - borderWidth,
      outerRadius.topLeft.y - borderWidth
    );
    Radius bottomLeft = Radius.elliptical(
      outerRadius.bottomLeft.x - borderWidth,
      outerRadius.bottomLeft.y - borderWidth
    );
    Radius topRight = Radius.elliptical(
      outerRadius.topRight.x - borderWidth,
      outerRadius.topRight.y - borderWidth
    );
    Radius bottomRight = Radius.elliptical(
      outerRadius.bottomRight.x - borderWidth,
      outerRadius.bottomRight.y - borderWidth
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
    final outerRadius = borderRadius;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: outerRadius ?? BorderRadius.circular(10.0),
        boxShadow: boxShadow
      ),
      padding: EdgeInsets.all(borderWidth),

      // Ink well implements ripple effect on tap, as well as tap detection
      // Material allows ink well to paint this effect
      child: Material(
        color: innerColor,
        borderRadius: outerRadius != null
          ? _calculateInnerRadius(outerRadius)
          : BorderRadius.circular(10.0 - borderWidth),
        child: InkWell(
          onTap: onPressed,
          borderRadius: outerRadius != null
            ? _calculateInnerRadius(outerRadius)
            : BorderRadius.circular(10.0 - borderWidth),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: outerRadius != null
                ? _calculateInnerRadius(outerRadius)
                : BorderRadius.circular(10.0 - borderWidth),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
