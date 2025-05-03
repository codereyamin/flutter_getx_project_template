import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:flutter_getx_project_template/routes/app_routes.dart';
import 'package:flutter_getx_project_template/services/storage_services/get_storage_services.dart';
import 'package:flutter_getx_project_template/utils/app_log.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get/get.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppApi {
  final Dio _dio = Dio();
  AppApi._privateConstructor();
  static final AppApi _instance = AppApi._privateConstructor();
  static AppApi get instance => _instance;
  var storageServices = GetStorageServices.instance;
  AppApi() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 120);
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers["Accept"] = "application/json";

          String token = storageServices.getToken();
          if (token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options); // Continue request
        },
        onError: (error, handler) async {
          appLog("API error occurred:");
          appLog("Status code: ${error.response?.statusCode}");
          appLog("Error message: ${error.message}");

          try {
            if (error.response?.statusCode == 401) {
              storageServices.storageClear();
              Get.offAllNamed(AppRoutes.instance.loginScreen);
              return handler.next(error);
            }
          } catch (e) {
            errorLog("error form api try and catch bloc", e);
            return handler.next(error);
          }

          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(requestHeader: true, request: true, compact: true, error: true, requestBody: true, responseHeader: true, responseBody: true),
    });
  }
  Dio get sendRequest => _dio;
}
