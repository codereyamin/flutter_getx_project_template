import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';

class AppNavigationScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    try {
      selectedIndex.value = index;
      update();
    } catch (e) {
      errorLog("changeIndex", e);
    }
  }
}
