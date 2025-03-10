import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/forgot_screen/controller/forgot_screen_controller.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/forgot_screen/screens/forgot_email_input_screen.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/forgot_screen/screens/forgot_otp_input_screen.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/forgot_screen/screens/forgot_screen_create_password_screen.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder(
        init: ForgotScreenController(),
        builder: (controller) {
          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: [ForgotEmailInputScreen(), ForgotOtpInputScreen(), ForgotScreenCreatePasswordScreen()],
          );
        },
      ),
    );
  }
}
