import 'package:flutter_getx_project_template/main.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

class AppDateTimeFormate {
  AppDateTimeFormate._privateConstructor();
  static final AppDateTimeFormate _instance = AppDateTimeFormate._privateConstructor();
  static AppDateTimeFormate get instance => _instance;

  String onlyTime(String? inputDateTime) {
    try {
      tz.initializeTimeZones();
      if (inputDateTime == null) return "";
      DateTime? dateTime = DateTime.tryParse(inputDateTime);
      if (dateTime == null) return "";
      DateTime utcTime = dateTime.toUtc();
      tz.Location location = tz.getLocation(userTimezone ?? 'America/Detroit');
      tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);
      String formattedTime = DateFormat('hh:mm a').format(localTime);
      return formattedTime;
    } catch (e) {
      errorLog("onlyTime", e);
      return "";
    }
  }

  String timeFormateTextMonthYear(String? inputDateTime) {
    try {
      if (inputDateTime == null) return "";
      DateTime? dateTime = DateTime.tryParse(inputDateTime);
      if (dateTime == null) return "";
      tz.initializeTimeZones();
      DateTime utcTime = dateTime.toUtc();
      tz.Location location = tz.getLocation(userTimezone ?? 'America/Detroit');
      tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);
      const List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

      String month = monthNames[localTime.month - 1];
      int year = localTime.year;
      return "$month $year";
    } catch (e) {
      errorLog("timeFormateTextMonthYear", e);
      return "";
    }
  }

  String timeFormateTextDayMonthYear(String? inputDateTime) {
    try {
      if (inputDateTime == null) return "";
      DateTime? dateTime = DateTime.tryParse(inputDateTime);
      if (dateTime == null) return "";
      tz.initializeTimeZones();
      DateTime utcTime = dateTime.toUtc();
      tz.Location location = tz.getLocation(userTimezone ?? 'America/Detroit');
      tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);
      const List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

      String month = monthNames[localTime.month - 1];
      int year = localTime.year;
      int day = localTime.day;
      return "$day-$month-$year";
    } catch (e) {
      errorLog("timeFormateTextMonthYear", e);
      return "";
    }
  }

  String fullDateAndTimeConsultationFormateFunction(String? inputDateTime) {
    try {
      if (inputDateTime == null) return "";
      if (inputDateTime.isEmpty) return "";
      // Parse the input string to DateTime
      DateTime? tryDate = DateTime.tryParse(inputDateTime);

      if (tryDate == null) return "";
      // Initialize timezone database
      tz.initializeTimeZones();

      // Parse the ISO UTC time
      DateTime utcTime = DateTime.parse(inputDateTime).toUtc();

      // Get the location for the user's timezone
      tz.Location location = tz.getLocation(userTimezone ?? 'America/Detroit');

      // Convert UTC to the user's local time
      tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);
      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      // Extract month, day, year, hour, and minute
      String month = months[localTime.month - 1];

      int day = localTime.day;
      int year = localTime.year;
      int hour = localTime.hour;
      int minute = localTime.minute;

      // Determine AM or PM
      String period = hour >= 12 ? "PM" : "AM";

      // Convert hour to 12-hour format
      hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      // Format minute to always show 2 digits
      String minuteStr = minute.toString().padLeft(2, '0');

      // Build the formatted string
      return "$month $day, $year  $hour:$minuteStr $period";
    } catch (e) {
      errorLog("fullDateAndTimeFormateFunction", e);
      return "";
    }
  }

  String timePeriod(String? inputDateTime) {
    try {
      if (inputDateTime == null) return "";
      DateTime? tryDate = DateTime.tryParse(inputDateTime);

      if (tryDate == null) return "";
      tz.initializeTimeZones();
      DateTime utcTime = DateTime.parse(inputDateTime).toUtc();
      tz.Location location = tz.getLocation(userTimezone ?? 'America/Detroit');
      tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);

      final DateTime now = DateTime.now();
      final Duration difference = now.difference(localTime);

      if (difference.inDays == 0) {
        // If the date is today, return the time in hh:mm a format
        int hour = localTime.hour;
        int minute = localTime.minute;
        String period = hour >= 12 ? 'pm' : 'am';

        if (hour > 12) {
          hour -= 12;
        } else if (hour == 0) {
          hour = 12;
        }

        final String minuteStr = minute < 10 ? '0$minute' : '$minute';
        return '$hour:$minuteStr $period';
      } else if (difference.inDays == 1) {
        return '1 day';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days';
      } else if (difference.inDays < 30) {
        return '${difference.inDays ~/ 7} week${difference.inDays ~/ 7 > 1 ? 's' : ''}';
      } else if (difference.inDays < 365) {
        return '${difference.inDays ~/ 30} month${difference.inDays ~/ 30 > 1 ? 's' : ''}';
      } else {
        return '${difference.inDays ~/ 365} year${difference.inDays ~/ 365 > 1 ? 's' : ''} ';
      }
    } catch (e) {
      errorLog("timePeriod", e);
      return "";
    }
  }
}
