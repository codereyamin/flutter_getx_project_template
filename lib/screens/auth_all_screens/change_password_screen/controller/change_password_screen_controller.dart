import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';

class ChangePasswordScreenController extends GetxController {
  ///////////////////  object
  TextEditingController oldPasswordTextEditingController = TextEditingController();
  TextEditingController newPasswordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void checkData() {
    try {
      if (formKey.currentState!.validate()) {
        Get.offAllNamed(AppRoutes.instance.loginScreen);
      }
    } catch (e) {
      errorLog('checkData', e);
    }
  }

  void onAppClose() {
    try {
      oldPasswordTextEditingController.dispose();
      newPasswordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
    } catch (e) {
      errorLog('onAppClose', e);
    }
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
