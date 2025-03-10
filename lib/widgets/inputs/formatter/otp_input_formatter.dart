import 'package:flutter/services.dart';

class OtpInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow one digit (0-9). Replace the old text with the new digit.
    if (newValue.text.isNotEmpty && newValue.text.length > 1) {
      return TextEditingValue(
        text: newValue.text.substring(
          newValue.text.length - 1,
        ), // Keep the last entered digit
        selection: const TextSelection.collapsed(
          offset: 1,
        ), // Move cursor to the end
      );
    }

    // Allow only digits and ensure the length is 1.
    if (RegExp(r'^\d$').hasMatch(newValue.text)) {
      return newValue;
    }

    // If the input is invalid, retain the old value.
    return oldValue;
  }
}
