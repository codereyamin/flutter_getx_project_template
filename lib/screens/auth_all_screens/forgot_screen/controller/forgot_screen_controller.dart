import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';

class ForgotScreenController extends GetxController {
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();

  void checkEmailFunction() {
    try {
      if (formKey1.currentState!.validate()) {
        pageController.nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
        startTimer();
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
    }
  }

  void checkOtpFunction() {
    try {
      if (formKey2.currentState!.validate()) {
        pageController.nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
    }
  }

  void checkCreateFunction() {
    try {
      if (formKey3.currentState!.validate()) {
        AppSnackBar.success("Login with your credentials");
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      }
    } catch (e) {
      errorLog("checkOtpFunction", e);
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
      emailController.dispose();
      otpController.dispose();
      passwordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
      pageController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
