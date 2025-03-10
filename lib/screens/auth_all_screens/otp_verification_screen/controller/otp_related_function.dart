import 'package:flutter_getx_project_template/utils/error_log.dart';

class OtpRelatedFunction {
  ///////////////////////  timer function start
  String formatSecondFunction(int seconds) {
    try {
      // Calculate the remaining minutes
      int minutes = (seconds % 3600) ~/ 60;

      // Calculate the remaining seconds
      int secs = seconds % 60;

      // Format minutes, and seconds to be 2 digits
      String formattedMinutes = minutes.toString().padLeft(2, '0');
      String formattedSeconds = secs.toString().padLeft(2, '0');

      return "$formattedMinutes:$formattedSeconds";
    } catch (e) {
      errorLog("formatSecondFunction", e);
      return "00:00";
    }
  }

  String maskEmail(String email) {
    try {
      List<String> parts = email.split('@');
      if (parts.length == 2) {
        return "****@${parts[1]}";
      }
    } catch (e) {
      errorLog("maskEmail", e);
    }
    return email;
  }
}
