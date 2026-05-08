import 'package:flutter/services.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

// Text Input Formatters
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

// Formatters that take in a String and output a String
abstract class Formatters {
  static String name(String name) {
    if (name.isEmpty) return "";

    List<String> nameList = name.split(' ');

    for (final (index, name) in nameList.indexed) {
      nameList[index] = "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
    }

    return nameList.join(" ");
  }

  static String middleInitial(String mi) {
    if (mi.isNotEmpty) {
      return mi[0].toUpperCase();
    }

    return '';
  }

  static String digits(String number, {int limit = -1}) {
    List<String> chars = number.split('');
    StringBuffer buf = StringBuffer('');

    for (final char in chars) {
      if (char.isValidNumberString()) {
        buf.write(char);
      }
    }

    String res = buf.toString();

    if (limit != -1) {
      res = res.substring(0, limit);
    }

    return res;
  }

  static String currency(String? rawAmount) {
    if (rawAmount == null || rawAmount.isEmpty) return '';

    double? value = double.tryParse(rawAmount);
    if (value == null || value == 0) return '';

    String formatted = value.toStringAsFixed(2);

    if (formatted.endsWith('.00')) {
      return formatted.substring(0, formatted.length - 3);
    }

    return formatted;
  }

  static String amountToWords(String amt) {
    if (amt.isEmpty) return '';

    double? value = double.tryParse(amt);
    if (value == null || value == 0) return '';

    int pesos = value.truncate();
    int centavos = ((value - pesos) * 100).round();

    String formatTitleCase(String text) {
      return text.split(' ').map((word) {
      if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

    String pesosWords = formatTitleCase(pesos.toWords());
    String result = "$pesosWords Pesos";

    if (centavos > 0) {
      String centavosWords = formatTitleCase(centavos.toWords());
      result += " and $centavosWords Centavos";
    }

    return result;
  }

  static bool isFutureDate(String month, String day, String year) {
    try {
      final date = DateTime(
        int.parse(year),
        int.parse(month),
        int.parse(day),
      );
      return date.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
