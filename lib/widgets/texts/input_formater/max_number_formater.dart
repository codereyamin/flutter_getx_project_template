import 'package:flutter/services.dart';

class MaxNumberInputFormatter extends TextInputFormatter {
  final int maxNumber;

  MaxNumberInputFormatter({required this.maxNumber});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Parse the input as an integer
    final int? number = int.tryParse(newValue.text);

    // If the input is not a valid number, keep the old value
    if (number == null) {
      return oldValue;
    }

    // If the input exceeds the maximum number, keep the old value
    if (number > maxNumber) {
      return oldValue;
    }

    // Otherwise, allow the new value
    return newValue;
  }
}
