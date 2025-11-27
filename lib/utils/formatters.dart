import 'package:flutter/services.dart';

class NameFormatter extends TextInputFormatter {
  const NameFormatter();

  String _formatText(TextEditingValue newValue) {
    List<String> names = newValue.text.split(' ');

    for (final (index, name) in names.indexed) {
      names[index] = "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
    }

    return names.join(" ");
  }

  // This adjusts the cursor
  int _adjustOffset(TextEditingValue oldValue, TextEditingValue newValue, String newText) {
    int newOffset = newValue.selection.end;

    if (newOffset < 1 && newText.length > oldValue.text.length) {
      newOffset += 1;
    } else if (newOffset >= 1 && newValue.text.length > newText.length) {
      newOffset -= 1;
    }

    return newOffset.clamp(0, newText.length);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = _formatText(newValue);
    int newOffset = _adjustOffset(oldValue, newValue, newText);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }
}

class MIFormatter extends TextInputFormatter {

  String _formatText(TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      return newValue.text[0].toUpperCase();
    }

    return '';
  }

  // This adjusts the cursor
  int _adjustOffset(TextEditingValue oldValue, TextEditingValue newValue, String newText) {
    int newOffset = newValue.selection.end;

    if (newOffset < 1 && newText.length > oldValue.text.length) {
      newOffset += 1;
    } else if (newOffset >= 1 && newValue.text.length > newText.length) {
      newOffset -= 1;
    }

    return newOffset.clamp(0, newText.length);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = _formatText(newValue);
    int newOffset = _adjustOffset(oldValue, newValue, newText);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }
}
