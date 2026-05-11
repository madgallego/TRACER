import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'gradient_icon.dart';

class GradientDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String hintText;
  final IconData prefixIcon;
  final bool isLoading;
  final String loadingText;

  const GradientDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.prefixIcon,
    this.isLoading = false,
    this.loadingText = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppDesign.appLightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          GradientIcon(
            icon: prefixIcon,
            size: AppDesign.sIconSize,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      loadingText,
                      style: AppDesign.bodyStyle.copyWith(color: Colors.black38),
                    ),
                  )
                : DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: value,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: Colors.white,
                      icon: GradientIcon(
                        icon: Icons.arrow_drop_down,
                        size: AppDesign.sIconSize,
                      ),
                      hint: Text(
                        hintText,
                        style: AppDesign.bodyStyle.copyWith(color: Colors.black38),
                      ),
                      style: AppDesign.bodyStyle,
                      items: items,
                      onChanged: onChanged,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
