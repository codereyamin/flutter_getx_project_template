import 'package:flutter/services.dart';

class LeadingZeroRemoverFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove leading zero only if followed by other digits
    String newText = newValue.text;
    if (newText.startsWith('0')) {
      newText = newText.replaceFirst(RegExp(r'^0+'), '');
    }
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
