import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static error(String parameterValue, {SnackPosition? snackPosition}) {
    Get.showSnackbar(
      GetSnackBar(
        isDismissible: true,
        snackPosition: snackPosition ?? SnackPosition.top,
        backgroundColor: AppColors.instance.error.withValues(alpha: 0.9),
        animationDuration: const Duration(seconds: 2),
        duration: const Duration(seconds: 5),
        messageText: AppText(data: parameterValue, color: AppColors.instance.white50),
        borderRadius: AppSize.width(value: 5.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0), vertical: AppSize.width(value: 20)),
      ),
    );
  }

  static success(String parameterValue, {SnackPosition? snackPosition, Duration? duration}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: AppColors.instance.success,
        animationDuration: const Duration(seconds: 2),
        duration: duration ?? const Duration(seconds: 3),
        snackPosition: snackPosition ?? SnackPosition.top,
        messageText: AppText(data: parameterValue, color: AppColors.instance.white50, fontWeight: FontWeight.w500),
        borderRadius: AppSize.width(value: 5.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0), vertical: AppSize.width(value: 20)),
      ),
    );
  }

  static message(String parameterValue, {Color? backgroundColor, Color? color, SnackPosition? snackPosition}) {
    Get.showSnackbar(
      GetSnackBar(
        backgroundColor: backgroundColor ?? AppColors.instance.dark300,
        animationDuration: const Duration(seconds: 2),
        duration: const Duration(seconds: 3),
        snackPosition: snackPosition ?? SnackPosition.top,
        messageText: AppText(data: parameterValue, color: color ?? AppColors.instance.white300, fontSize: 16, fontWeight: FontWeight.w400),
        borderRadius: AppSize.width(value: 5.0),
        padding: EdgeInsets.all(AppSize.width(value: 10.0)),
        margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0), vertical: AppSize.width(value: 20)),
      ),
    );
  }
}
