import 'package:flutter/material.dart';
import 'package:tracer/utils/constants.dart';
import 'dart:math' as math;

class GradientBorderText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final LinearGradient gradient;
  final double strokeWidth;
  final List<Shadow>? shadows;

  const GradientBorderText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.gradient,
    this.strokeWidth = 2.0,
    this.shadows,
  });

  @override
  State<GradientBorderText> createState() => _GradientBorderTextState();
}

class _GradientBorderTextState extends State<GradientBorderText>
    with SingleTickerProviderStateMixin {

  late final AnimationController _rotationController;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _rotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // Always rotate
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, _) {
        final rotatedGradient = LinearGradient(
          colors: widget.gradient.colors,
          stops: widget.gradient.stops,
          begin: widget.gradient.begin,
          end: widget.gradient.end,
          transform: GradientRotation(_rotation.value),
        );

        return Stack(
          children: [
            Text(
              widget.text,
              style: widget.textStyle.copyWith(
                shadows: widget.shadows,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.strokeWidth
                  ..strokeJoin = StrokeJoin.round
                  ..strokeCap = StrokeCap.round
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5)
                  ..shader = rotatedGradient.createShader(_shaderRect()),
              ),
            ),

            Text(
              widget.text,
              style: widget.textStyle,
            ),
          ],
        );
      },
    );
  }

  Rect _shaderRect() {
    final fontSize = widget.textStyle.fontSize ?? 20;
    return Rect.fromLTWH(
      0,
      0,
      fontSize * widget.text.length * 0.60,
      fontSize * 1.2,
    );
  }
}
