import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_project_template/constant/app_assert_image.dart';
import 'package:flutter_getx_project_template/screens/splash_screen/controller/splash_screen_controller.dart';
import 'package:flutter_getx_project_template/utils/app_size.dart';
import 'package:flutter_getx_project_template/widgets/app_image/app_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppSize.size = size;
    return GetBuilder(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: AnimatedOpacity(
                  duration: Duration(seconds: 2),
                  opacity: controller.animation2.value,
                  child: AnimatedScale(scale: controller.animation.value, duration: Duration(seconds: 2), curve: Curves.easeOutExpo, child: AppImage(path: AppAssertImage.instance.logo)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
