import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color fillColor;
  final LinearGradient activeGradient;
  final BorderRadius? borderRadius;
  final String? prefixText;
  final Widget? suffixIcon;

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const GradientTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.fillColor = Colors.white,
    required this.activeGradient,
    this.borderRadius,
    this.prefixText,
    this.suffixIcon,
    this.validator,
    this.onSaved,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
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
        color: widget.fillColor,
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
          color: widget.fillColor,
          borderRadius: widget.borderRadius
        ),

        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,

          validator: widget.validator,
          onSaved: widget.onSaved,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,

          textCapitalization: widget.textCapitalization,
          style: TextStyle(
            fontFamily: "AROneSans",
            fontSize: 13.0,
          ),

          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            errorStyle: const TextStyle(height: 0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,

            prefixText: widget.prefixText,
            prefixStyle: TextStyle(
              fontFamily: "AROneSans",
              fontSize: 13.0
            ),
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}
