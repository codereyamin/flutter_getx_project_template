import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_getx_project_template/constant/app_api_end_point.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NonAuthApi {
  final Dio _dio = Dio();
  NonAuthApi() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 60);
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.followRedirects = false;
    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.contentType = 'application/json';
          options.headers["Accept"] = "application/json";
          return handler.next(options); // Continue request
        },
        onError: (error, handler) async {
          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode) PrettyDioLogger(requestHeader: true, request: true, compact: true, error: true, requestBody: true, responseHeader: true, responseBody: true),
    });
  }
  Dio get sendRequest => _dio;
}
