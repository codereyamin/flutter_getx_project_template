import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';

Future<void> customTimePicker({required Function(TimeOfDay?) onTimeSelected}) async {
  try {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: AppColors.instance.primary, onPrimary: AppColors.instance.primary50, onSurface: Colors.black),
              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppColors.instance.primary50, // Main background color
                hourMinuteTextColor: Colors.black, // Text color for hour and minute
                hourMinuteColor: AppColors.instance.primary50, // Background color for hour and minute
                dayPeriodColor: WidgetStateColor.resolveWith(
                  (states) =>
                      states.contains(WidgetState.selected)
                          ? AppColors
                              .instance
                              .primary50 // Selected AM/PM color
                          : AppColors.instance.primary50,
                ), // Unselected AM/PM color
                // dayPeriodTextColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected)
                //     ? Colors.white // Text color when AM/PM is selected
                //     : Colors.black),
                //// Text color when AM/PM is not selected
                dayPeriodTextColor: WidgetStateColor.resolveWith((states) => Colors.black),
                dialBackgroundColor: AppColors.instance.primary100,
                dayPeriodBorderSide: BorderSide(
                  color: AppColors.instance.primary800, // Custom border color for AM/PM selector
                  width: 2, // Border width
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  } catch (e) {
    errorLog("customTimePicker", e);
  }
}
