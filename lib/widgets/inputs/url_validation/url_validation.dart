import 'package:flutter_getx_project_template/utils/error_log.dart';

String? getUrlValidation(String? value) {
  try {
    if (value == null) return null;
    final uri = Uri.parse(value);
    bool response = uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    if (response) return null;
    return "Invalid URL";
  } catch (e) {
    errorLog("getUrlValidation", e);
    return null;
  }
}
