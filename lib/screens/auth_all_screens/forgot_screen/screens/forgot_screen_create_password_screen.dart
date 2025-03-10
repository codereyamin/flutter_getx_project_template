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

class ForgotScreenCreatePasswordScreen extends StatelessWidget {
  const ForgotScreenCreatePasswordScreen({super.key});

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
                  key: controller.formKey3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppImage(path: AppAssertImage.instance.forgotCreatePassword, width: AppSize.size.width * 0.6),

                      Column(
                        children: [
                          Gap(height: 10),
                          AppText(data: "Create new password", fontSize: 25, fontWeight: FontWeight.w500),
                          Gap(height: 5),
                          AppText(data: "Password must have 8 characters", color: AppColors.instance.subTextColor),
                          Gap(height: 50),
                        ],
                      ),
                      AppInputWidget(
                        controller: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "New password",
                        hintText: "Enter your new password",
                        isPassWord: true,
                        maxLines: 1,
                        prefix: Icon(Icons.lock_outline, color: AppColors.instance.dark200),
                      ),
                      Gap(height: AppSize.height(value: 20)),
                      AppInputWidget(
                        controller: controller.confirmPasswordTextEditingController,
                        isPassWordSecondValidation: true,
                        isPassWordSecondValidationController: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Confirm new Password",
                        hintText: "Enter new confirm password",
                        isPassWord: true,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        prefix: Icon(Icons.lock_outline, color: AppColors.instance.dark200),
                      ),
                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  AppButton(
                    title: "Update Password",
                    onTap: () {
                      controller.checkCreateFunction();
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
