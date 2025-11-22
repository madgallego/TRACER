import 'package:flutter/material.dart';

class GradientTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final LinearGradient activeGradient;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const GradientTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    required this.activeGradient,
    this.borderRadius,
    this.suffixIcon,
    this.validator,
    this.onSaved,
  });

  @override
  State<GradientTextFormField> createState() => _GradientTextFormFieldState();
}

class _GradientTextFormFieldState extends State<GradientTextFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the border color/gradient based on focus state
    final currentGradient = _isFocused ? widget.activeGradient : null;
    final Color unfocusedColor = Colors.grey.shade300;
    final double borderWidth = _isFocused ? 1.0 : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,

      decoration: BoxDecoration(
        color: Colors.white,
        gradient: currentGradient,
        border: Border.all(
          // Fallback color when not focused
          color: _isFocused ? Colors.transparent : unfocusedColor,
          width: borderWidth,
        ),
        borderRadius: widget.borderRadius,
      ),

      padding: EdgeInsets.all(borderWidth),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: widget.borderRadius
        ),

        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,

          validator: widget.validator,
          onSaved: widget.onSaved,

          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            errorStyle: const TextStyle(height: 0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}
