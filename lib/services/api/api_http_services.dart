// import 'dart:convert';
// import 'dart:io';
// import 'dart:async';
// import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';
// import 'package:http/http.dart' as http;

// class HttpService {
//   final String baseUrl = "https://your-api.com"; // Change to your API base URL
//   String? authToken; // Store authentication token

//   /// ✅ Set Authorization Token
//   void setAuthToken(String token) {
//     authToken = token;
//   }

//   /// ✅ Common Headers (includes auth token if available)
//   Map<String, String> getHeaders({Map<String, String>? extraHeaders}) {
//     Map<String, String> headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
//     if (authToken != null) {
//       headers['Authorization'] = 'Bearer $authToken';
//     }
//     if (extraHeaders != null) {
//       headers.addAll(extraHeaders);
//     }
//     return headers;
//   }

//   /// ✅ **GET Request with Query Parameters**
//   Future<dynamic> getRequest(String endpoint, {Map<String, String>? params, Map<String, String>? headers}) async {
//     Uri url = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
//     try {
//       final response = await http.get(url, headers: getHeaders(extraHeaders: headers));
//       return _handleResponse(response);
//     } catch (e) {
//       return _handleException(e);
//     }
//   }

//   /// ✅ **POST Request (JSON) with Authentication**
//   Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     try {
//       final response = await http.post(url, headers: getHeaders(extraHeaders: headers), body: jsonEncode(data));
//       return _handleResponse(response);
//     } catch (e) {
//       return _handleException(e);
//     }
//   }

//   /// ✅ **PATCH Request (JSON)**
//   Future<dynamic> patchRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     try {
//       final response = await http.patch(url, headers: getHeaders(extraHeaders: headers), body: jsonEncode(data));
//       return _handleResponse(response);
//     } catch (e) {
//       return _handleException(e);
//     }
//   }

//   /// ✅ **POST File Upload (Image/Video) + Data**
//   Future<dynamic> uploadFile(String endpoint, File file, String fieldName, Map<String, dynamic> data, {Map<String, String>? headers}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     try {
//       var request = http.MultipartRequest('POST', url);
//       request.headers.addAll(getHeaders(extraHeaders: headers));

//       // Add file
//       request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

//       // Add other form fields
//       data.forEach((key, value) {
//         request.fields[key] = value.toString();
//       });

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       return _handleResponse(response);
//     } catch (e) {
//       return _handleException(e);
//     }
//   }

//   /// ✅ **Handles Response**
//   dynamic _handleResponse(http.Response response) {
//     try {
//       final jsonResponse = jsonDecode(response.body);
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return jsonResponse['success'] == true ? jsonResponse : null;
//       } else {
//         throw HttpException('${jsonResponse['message'] ?? 'Unknown error'}');
//       }
//     } catch (e) {
//       return _handleException(e);
//     }
//   }

//   /// ✅ **Handles Exceptions**
//   dynamic _handleException(dynamic e) {
//     if (e is SocketException) {
//       // return {'error': 'No Internet Connection'};
//       //  if (e.message.runtimeType != Null) {
//       //   AppSnackBar.error("${e.response?.data["message"]}");
//       // }
//       AppSnackBar.error("No Internet Connection");
//       return null;
//     } else if (e is TimeoutException) {
//       if (e.message.runtimeType != Null) {
//         AppSnackBar.error("${e.message}");
//       }
//       return null;
//     } else if (e is HttpException) {
//       if (e.message.runtimeType != Null) {
//         AppSnackBar.error(e.message);
//       }
//       return null;
//     } else {
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_getx_project_template/widgets/app_snack_bar/app_snack_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = "https://your-api.com"; // Change to your API base URL
  String? authToken;
  String? refreshToken;

  /// ✅ Set Authorization Tokens
  void setAuthToken(String token, {String? refresh}) {
    authToken = token;
    if (refresh != null) {
      refreshToken = refresh;
    }
  }

  /// ✅ Common Headers (includes auth token if available)
  Map<String, String> getHeaders({Map<String, String>? extraHeaders}) {
    Map<String, String> headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  /// ✅ **Handles API Calls with Token Refresh**
  Future<dynamic> _requestWithRetry(Future<http.Response> Function() requestFunction) async {
    http.Response response;
    try {
      response = await requestFunction();
      if (response.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          response = await requestFunction(); // Retry request with new token
        } else {
          _redirectToLogin();
          return null;
        }
      }
      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// ✅ **GET Request with Query Parameters**
  Future<dynamic> getRequest(String endpoint, {Map<String, String>? params, Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    return _requestWithRetry(() => http.get(url, headers: getHeaders(extraHeaders: headers)));
  }

  /// ✅ **POST Request (JSON)**
  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');
    return _requestWithRetry(() => http.post(url, headers: getHeaders(extraHeaders: headers), body: jsonEncode(data)));
  }

  /// ✅ **PATCH Request (JSON)**
  Future<dynamic> patchRequest(String endpoint, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');
    return _requestWithRetry(() => http.patch(url, headers: getHeaders(extraHeaders: headers), body: jsonEncode(data)));
  }

  /// ✅ **POST File Upload (Image/Video) + Data**
  Future<dynamic> uploadFile(String endpoint, File file, String fieldName, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(getHeaders(extraHeaders: headers));

      // Add file
      request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

      // Add other form fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          return uploadFile(endpoint, file, fieldName, data, headers: headers); // Retry after refresh
        } else {
          _redirectToLogin();
          return null;
        }
      }

      return _handleResponse(response);
    } catch (e) {
      return _handleException(e);
    }
  }

  /// ✅ **Handles Response**
  dynamic _handleResponse(http.Response response) {
    try {
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse['success'] == true ? jsonResponse : null;
      } else {
        throw HttpException('${jsonResponse['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      return _handleException(e);
    }
  }

  /// ✅ **Handles Token Refresh**
  Future<bool> _refreshToken() async {
    if (refreshToken == null) return false;
    try {
      Uri url = Uri.parse('$baseUrl/auth/refresh');
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'refresh_token': refreshToken}));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        authToken = data['access_token'];
        refreshToken = data['refresh_token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// ✅ **Redirects to Login on Expired Token**
  void _redirectToLogin() {
    AppSnackBar.error("Session expired. Please log in again.");
    Future.delayed(Duration(seconds: 1), () {
      Get.offAllNamed('/login'); // Replace with your login route
    });
  }

  /// ✅ **Handles Exceptions**
  dynamic _handleException(dynamic e) {
    if (e is SocketException) {
      AppSnackBar.error("No Internet Connection");
      return null;
    } else if (e is TimeoutException) {
      AppSnackBar.error("Request Timed Out");
      return null;
    } else if (e is HttpException) {
      AppSnackBar.error(e.message);
      return null;
    } else {
      AppSnackBar.error("Something went wrong");
      return null;
    }
  }
}
