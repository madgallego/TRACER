import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracer/utils/constants.dart';

class GradientBorderTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Color? textColor;
  final Color? fillColor;
  final LinearGradient? activeGradient;
  final BorderRadius? borderRadius;
  final String? prefixText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool readOnly;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const GradientBorderTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.textColor,
    this.fillColor = AppDesign.appLightGray,
    this.activeGradient,
    this.borderRadius,
    this.prefixText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<GradientBorderTextFormField> createState() => _GradientBorderTextFormFieldState();
}

class _GradientBorderTextFormFieldState extends State<GradientBorderTextFormField> {
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
    // Provide defaults
    final effectiveGradient = widget.activeGradient ?? AppDesign.primaryGradient;
    final effectiveBorderRadius = widget.borderRadius ?? AppDesign.defaultCircularBorderRadius;

    // Define the border color/gradient based on focus state
    final currentGradient = _isFocused ? effectiveGradient : null;
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
        borderRadius: effectiveBorderRadius,
      ),

      padding: EdgeInsets.all(borderWidth),

      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: effectiveBorderRadius
        ),

        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,

          textCapitalization: widget.textCapitalization,
          style: AppDesign.bodyStyle.copyWith(color: widget.textColor),

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppDesign.bodyStyle.copyWith(color: Colors.black38),
            border: InputBorder.none,
            errorStyle: const TextStyle(height: 0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,

            prefixText: widget.prefixText,
            prefixStyle: AppDesign.bodyStyle,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ),
    );
  }
}
