import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends GetxController {
  RxList<ConnectivityResult> connectionStatus = <ConnectivityResult>[].obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  Future<void> initConnectivity() async {
    try {
      List<ConnectivityResult> result = await connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      connectivitySubscription = connectivity.onConnectivityChanged.listen((event) {
        _updateConnectionStatus(event);
      });
    } on PlatformException catch (e) {
      errorLog('Couldn\'t check connectivity status', e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    try {
      connectionStatus.value = result;
      connectionStatus.refresh();
      if (result.contains(ConnectivityResult.none)) {
        Future.microtask(() {
          if (Get.isRegistered<GetMaterialApp>()) {
            Get.offAllNamed(AppRoutes.instance.errorScreen);
          }
        });
      }
    } catch (e) {
      errorLog("_updateConnectionStatus", e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
  }

  @override
  void onClose() {
    connectivitySubscription.cancel();
    super.onClose();
  }
}
