import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/constant/app_assert_image.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/forgot_screen/controller/forgot_screen_controller.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/gap.dart';
import 'package:flutter_getx_project_template/widgets/app_image/app_image.dart';
import 'package:flutter_getx_project_template/widgets/buttons/app_button.dart';
import 'package:flutter_getx_project_template/widgets/inputs/app_input_widget.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';

class ForgotEmailInputScreen extends StatelessWidget {
  const ForgotEmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ForgotScreenController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: controller.formKey1,
                  child: Column(
                    children: [
                      AppImage(path: AppAssertImage.instance.forgotEmailInput, width: AppSize.size.width * 0.6),
                      Gap(height: 10),
                      AppText(data: "Forgot password", fontSize: 25, fontWeight: FontWeight.w500),
                      Gap(height: 10),
                      AppText(data: "Enter your email to reset your \npassword.", fontSize: 16, fontWeight: FontWeight.w400, textAlign: TextAlign.center, height: 1.5),
                      Gap(height: 10),
                      AppInputWidget(
                        labelText: "Email",
                        hintText: "Enter your mail",
                        prefix: Icon(Icons.email_outlined, color: AppColors.instance.dark300),
                        keyboardType: TextInputType.emailAddress,
                        borderColor: AppColors.instance.boxBg,
                      ),
                      Gap(height: 10),
                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  AppButton(
                    title: "Get OTP",
                    onTap: () {
                      controller.checkEmailFunction();
                    },
                  ),
                  Gap(height: 50),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
