import 'package:flutter/material.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/routes/app_routes_file.dart';
import 'package:flutter_getx_project_template/screens/error_screen/error_screen.dart';
import 'package:flutter_getx_project_template/utils/app_theme.dart';
import 'package:get/get.dart';

GlobalKey<NavigatorState>? appNavigatorStateKey = GlobalKey<NavigatorState>();

class MainEntryApp extends StatelessWidget {
  const MainEntryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      initialRoute: AppRoutes.instance.initial,
      getPages: appRootRoutesFile,
      theme: appThemeData,
      themeMode: ThemeMode.light,
      enableLog: true,
      defaultGlobalState: true,
      transitionDuration: const Duration(microseconds: 100),
      navigatorKey: appNavigatorStateKey,
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return const ErrorScreen();
        };
        if (child != null) {
          return child;
        }
        return const SizedBox();
      },
    );
  }
}
