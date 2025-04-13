import 'package:flutter_getx_project_template/constant/app_storage_key.dart';
import 'package:flutter_getx_project_template/utils/error_log.dart';
import 'package:get_storage/get_storage.dart';

class GetStorageServices {
  GetStorageServices._privateConstructor();
  static final GetStorageServices _instance = GetStorageServices._privateConstructor();
  static GetStorageServices get instance => _instance;

  ////////////// storage initial
  GetStorage box = GetStorage();

  ////////////////  token
  Future<void> setToken(String value) async {
    try {
      await box.write(AppStorageKey.instance.token, value);
      await box.save();
    } catch (e) {
      errorLog("set token ", e);
    }
  }

  String getToken() {
    try {
      return box.read(AppStorageKey.instance.token) ?? "";
    } catch (e) {
      errorLog("get token", e);
      return "";
    }
  }

  ///////////////////////  on board screen

  Future<void> setOnboardScreen() async {
    try {
      await box.write(AppStorageKey.instance.onboard, true);
      await box.save();
    } catch (e) {
      errorLog("setOnboardScreen", e);
    }
  }

  bool getOnboardScreen() {
    try {
      return box.read(AppStorageKey.instance.onboard) ?? false;
    } catch (e) {
      errorLog("getOnboardScreen", e);
      return false;
    }
  }

  /////////////////////  user role
  Future<void> setUserRole(String value) async {
    try {
      await box.write(AppStorageKey.instance.userRole, value);
    } catch (e) {
      errorLog("set user role", e);
    }
  }

  String? getUserRole() {
    try {
      return box.read(AppStorageKey.instance.userRole);
    } catch (e) {
      errorLog("get user role", e);
      return "";
    }
  }

  ////////////  get language
  String? getLanguage() {
    return box.read(AppStorageKey.instance.language);
  }

  ////////////  set language
  Future<void> setLanguage(String value) async {
    await box.write(AppStorageKey.instance.language, value);
  }

  ////////////  get country
  String getCountry() {
    return box.read(AppStorageKey.instance.country) ?? "";
  }

  ////////////  set country
  Future<void> setCountry(String value) async {
    await box.write(AppStorageKey.instance.country, value);
  }

  ///logout
  Future<void> storageClear() async {
    try {
      await box.write(AppStorageKey.instance.token, "");
      await setLanguage("en_US");
    } catch (e) {
      errorLog("logout", e);
    }
  }
}
