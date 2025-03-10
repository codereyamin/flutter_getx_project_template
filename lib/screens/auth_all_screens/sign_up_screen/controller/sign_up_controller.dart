import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';

class SignUpController extends GetxController {
  ///////////object
  TextEditingController fullNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void checkValidation() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(AppRoutes.instance.otpVerificationScreen, arguments: emailTextEditingController.text);
    }
  }

  //////////. user types
  RxBool userTypes = true.obs;
  void changeUserType(bool value) {
    try {
      userTypes.value = value;
    } catch (e) {
      errorLog("changeUserType", e);
    }
  }

  //////////// terms and conditions
  RxBool termsAndConditions = false.obs;
  void changeTermsAndConditions(bool value) {
    termsAndConditions.value = value;
  }

  void onAppClose() {
    try {
      fullNameTextEditingController.dispose();
      emailTextEditingController.dispose();
      locationTextEditingController.dispose();
      passwordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
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
