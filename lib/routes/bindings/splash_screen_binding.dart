import 'package:get/get.dart';
import 'package:flutter_getx_project_template/screens/error_screen/controller/error_screen_controller.dart';
import 'package:flutter_getx_project_template/screens/not_found_screen/controller/not_found_screen_controller.dart';

import 'package:flutter_getx_project_template/screens/splash_screen/controller/splash_screen_controller.dart';

class SplashScreenBinding extends BindingsInterface {
  @override
  dependencies() {
    Get.lazyPut(() => SplashScreenController());
    Get.lazyPut(() => ErrorScreenController());
    Get.lazyPut(() => NotFoundScreenController());
  }
}
