import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/app_all_enum/app_login_status.dart';
import 'package:flutter_getx_project_template/screens/app_navigation_screen/controller/app_navigation_screen_controller.dart';
import 'package:get/get.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AppNavigationScreenController(),
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: controller.selectedIndex.value, children: selectedAppUserType == AppUserType.user ? [] : []),

          bottomNavigationBar: BottomNavigationBar(onTap: controller.changeIndex, items: selectedAppUserType == AppUserType.user ? [] : []),
        );
      },
    );
  }
}
