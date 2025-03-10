import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/constant/app_assert_image.dart';
import 'package:flutter_getx_project_template/constant/app_colors.dart';
import 'package:flutter_getx_project_template/constant/app_constant.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/screens/auth_all_screens/sign_up_screen/controller/sign_up_controller.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/utils/gap.dart';
import 'package:flutter_getx_project_template/widgets/app_image/app_image.dart';
import 'package:flutter_getx_project_template/widgets/buttons/app_button.dart';
import 'package:flutter_getx_project_template/widgets/inputs/app_input_widget.dart';
import 'package:flutter_getx_project_template/widgets/texts/app_text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: SignUpController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(title: AppText(data: "Create New Account", fontSize: 18), centerTitle: true, surfaceTintColor: AppColors.instance.white50),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      AppImage(path: AppAssertImage.instance.logo, width: AppSize.size.width * 0.6),
                      Gap(height: AppSize.height(value: 10)),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Gap(width: 30),
                                Radio(
                                  value: true,
                                  groupValue: controller.userTypes.value,
                                  activeColor: AppColors.instance.primary300,
                                  onChanged: (value) {
                                    controller.changeUserType(true);
                                  },
                                ),

                                AppText(data: "User", fontWeight: FontWeight.bold, fontSize: 20),
                              ],
                            ),

                            Row(
                              children: [
                                Radio(
                                  value: false,
                                  groupValue: controller.userTypes.value,
                                  activeColor: AppColors.instance.primary300,
                                  onChanged: (value) {
                                    controller.changeUserType(false);
                                  },
                                ),

                                AppText(data: "Agency", fontWeight: FontWeight.bold, fontSize: 20),
                                Gap(width: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(height: AppSize.height(value: 10)),
                      AppInputWidget(
                        controller: controller.fullNameTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Full Name",
                        hintText: "Enter full name",
                        prefix: Icon(Icons.person_outlined, color: AppColors.instance.dark200),
                      ),
                      Gap(height: AppSize.height(value: 20)),
                      AppInputWidget(
                        controller: controller.emailTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Email",
                        hintText: "Enter your e-mail",
                        keyboardType: TextInputType.emailAddress,
                        isEmail: true,
                        prefix: Icon(Icons.email_outlined, color: AppColors.instance.dark200),
                      ),
                      Gap(height: AppSize.height(value: 20)),
                      AppInputWidget(
                        controller: controller.locationTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Location",
                        hintText: "Enter your location",
                        prefix: Icon(Icons.location_on_outlined, color: AppColors.instance.dark200),
                      ),
                      Gap(height: AppSize.height(value: 20)),
                      AppInputWidget(
                        controller: controller.passwordTextEditingController,
                        borderColor: AppColors.instance.boxBg,
                        labelText: "Password",
                        hintText: "Enter your password",
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
                        labelText: "Confirm Password",
                        hintText: "Enter your confirm password",

                        isPassWord: true,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        prefix: Icon(Icons.lock_outline, color: AppColors.instance.dark200),
                      ),
                      Gap(height: AppSize.height(value: 20)),

                      Obx(
                        () => Row(
                          children: [
                            Theme(
                              data: ThemeData(unselectedWidgetColor: AppColors.instance.primary200),
                              child: Checkbox(
                                activeColor: AppColors.instance.white50,

                                side: WidgetStateBorderSide.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return BorderSide(color: AppColors.instance.primary200);
                                  } else {
                                    return BorderSide(color: AppColors.instance.dark300);
                                  }
                                }),
                                value: controller.termsAndConditions.value,
                                checkColor: AppColors.instance.primary200,
                                fillColor: WidgetStatePropertyAll(AppColors.instance.white50),
                                shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.instance.primary200), borderRadius: BorderRadius.circular(AppSize.width(value: 5.0))),
                                onChanged: (value) {
                                  controller.changeTermsAndConditions(value ?? false);
                                },
                              ),
                            ),

                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text: "By creating an account, I agree to the ",
                                  style: TextStyle(color: AppColors.instance.dark400, fontFamily: AppConstant.instance.font, height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(color: AppColors.instance.primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(AppRoutes.instance.termsAndConditions);
                                            },
                                    ),
                                    TextSpan(text: " & ", style: TextStyle(color: AppColors.instance.dark400)),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(color: AppColors.instance.primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(AppRoutes.instance.privacyPolicy);
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(height: AppSize.height(value: 30)),
                      Obx(
                        () => AppButton(
                          backgroundColor: controller.termsAndConditions.value ? AppColors.instance.primary : AppColors.instance.dark100,
                          borderColor: controller.termsAndConditions.value ? AppColors.instance.primary : AppColors.instance.dark100,
                          loaderColor: AppColors.instance.white50,
                          title: "Next",
                          onTap:
                              controller.termsAndConditions.value
                                  ? () {
                                    controller.checkValidation();
                                  }
                                  : null,
                        ),
                      ),
                      Gap(height: AppSize.height(value: 30)),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: AppColors.instance.dark400, fontFamily: AppConstant.instance.font, height: 1.5),
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(color: AppColors.instance.primary, decoration: TextDecoration.underline, decorationColor: AppColors.instance.primary),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
