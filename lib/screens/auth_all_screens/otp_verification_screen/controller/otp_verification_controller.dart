import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';

class OtpVerificationController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString email = "".obs;

  void checkOtpFunction() {
    try {
      if (formKey.currentState!.validate()) {
        Get.offAndToNamed(AppRoutes.instance.loginScreen);
        AppSnackBar.success("Login with your credentials");
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
    }
  }

  void onAppInitialDataLoadFunction() {
    try {
      final argData = Get.arguments;
      if (argData is String) {
        email.value = argData;
        startTimer();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offAllNamed(AppRoutes.instance.errorScreen);
        });
      }
    } catch (e) {
      errorLog("message", e);
    }
  }

  //////////////////////// Otp timer //////////////////////////
  RxInt secondsRemaining = 60.obs;
  Timer? _timer;

  void reSendOtp() {
    try {
      secondsRemaining.value = 60;
      startTimer();
    } catch (e) {
      errorLog("reSendOtp", e);
    }
  }

  void startTimer() {
    try {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value = secondsRemaining.value - 1;
        } else {
          _timer?.cancel();
        }
      });
    } catch (e) {
      errorLog("startTimer", e);
    }
  }

  void onAppClose() {
    try {
      _timer?.cancel();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onInit() {
    onAppInitialDataLoadFunction();
    super.onInit();
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
