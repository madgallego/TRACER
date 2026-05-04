import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracer/utils/constants.dart';
import 'package:tracer/widgets/gradient_border_text_form_field.dart';
import 'package:tracer/widgets/gradient_icon.dart';

class LabeledFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final VoidCallback? onTap;
  final dynamic Function(String)? onChanged;
  final bool readOnly;
  final String? prefixText;
  final IconData suffixIcon;
  final LinearGradient? iconGradient;
  final Color? textColor;
  final Color? fillColor;
  final bool optional;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.controller,
    this.formatters,
    this.keyboardType,
    this.textCapitalization,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.prefixText,
    this.suffixIcon = Icons.edit_outlined,
    this.iconGradient,
    this.textColor,
    this.fillColor,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 5.0,
          children: [
            Text(label, style: AppDesign.bodyStyle),
            if (!optional)
              Text(
                '*',
                style: AppDesign.bodyStyle.copyWith(color: AppDesign.dangerRed),
              )
          ],
        ),
        GradientTextFormField(
          controller: controller,
          inputFormatters: formatters,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          prefixText: prefixText,

          // Shared design properties
          textColor: textColor,
          fillColor: fillColor,
          activeGradient: const LinearGradient(
            colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd]
          ),
          borderRadius: BorderRadius.circular(30.0),
          suffixIcon: GradientIcon(
            icon: suffixIcon,
            size: 24.0,
            gradient: iconGradient ?? const LinearGradient(
              colors: [AppDesign.primaryGradientStart, AppDesign.primaryGradientEnd],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )
          ),
        ),
      ],
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDesign.defaultBoxShadows,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            side: BorderSide(color: AppDesign.appOffblack, width: 1.5),
          ),
          Text(label, style: AppDesign.bodyStyle),
        ],
      ),
    );
  }
}
