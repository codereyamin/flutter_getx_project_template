import 'package:get/get.dart';
import 'package:flutter_getx_project_template/screens/about_us_screen/controller/about_us_screen_controller.dart';
import 'package:flutter_getx_project_template/screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import 'package:flutter_getx_project_template/screens/privacy_policy_screen/controller/privacy_policy_screen_controller.dart';
import 'package:flutter_getx_project_template/screens/terms_and_conditions_screen/controller/terms_and_conditions_screen_controller.dart';

class NavigationScreenBinding extends BindingsInterface {
  @override
  dependencies() {
    Get.lazyPut(() => AppNavigationScreenController());
    Get.lazyPut(() => TermsAndConditionsScreenController());
    Get.lazyPut(() => PrivacyPolicyScreenController());
    Get.lazyPut(() => AboutUsScreenController());
  }
}
