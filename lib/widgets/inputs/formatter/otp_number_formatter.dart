import 'package:flutter/services.dart';

class OtpNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove spaces and keep only digits
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 6) {
      digitsOnly = digitsOnly.substring(0, 6);
    }

    // Insert spaces between digits
    String formattedText = digitsOnly.split('').join('-');

    // Adjust cursor position
    int cursorPosition = formattedText.length;

    return TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: cursorPosition));
  }
}
