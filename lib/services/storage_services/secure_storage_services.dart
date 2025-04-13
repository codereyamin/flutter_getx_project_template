class SecureStorageServices {
  SecureStorageServices._privateConstructor();
  static final SecureStorageServices _instance = SecureStorageServices._privateConstructor();
  static SecureStorageServices get instance => _instance;

  ////////////// storage initial

  FlutterSecureStorage box = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.unlocked, synchronizable: true),
    aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
  );

  ////////////////  token
  Future<void> setToken(String value) async {
    try {
      await box.write(key: AppStorageKey.instance.token, value: value);
    } catch (e) {
      errorLog("set token ", e);
    }
  }

  Future<String> getToken() async {
    try {
      return await box.read(key: AppStorageKey.instance.token) ?? "";
    } catch (e) {
      errorLog("get token", e);
      return "";
    }
  }

  ////////////////  refresh Token
  Future<void> setRefreshToken(String value) async {
    try {
      await box.write(key: AppStorageKey.instance.refreshToken, value: value);
    } catch (e) {
      errorLog("set refreshToken ", e);
    }
  }

  Future<String> getRefreshToken() async {
    try {
      return await box.read(key: AppStorageKey.instance.refreshToken) ?? "";
    } catch (e) {
      errorLog("get refreshToken", e);
      return "";
    }
  }

  ////////////////  user role
  Future<void> setRole(String value) async {
    try {
      await box.write(key: AppStorageKey.instance.userRole, value: value);
    } catch (e) {
      errorLog("set role ", e);
    }
  }

  Future<String> getRole() async {
    try {
      return await box.read(key: AppStorageKey.instance.userRole) ?? "";
    } catch (e) {
      errorLog("get role", e);
      return "";
    }
  }

  ////////////////  user data
  Future<void> setUser(AppUserData value) async {
    try {
      await box.write(key: AppStorageKey.instance.userData, value: jsonEncode(value.toJson()));
    } catch (e) {
      errorLog("set role ", e);
    }
  }

  Future<AppUserData?> getUser() async {
    try {
      var response = await box.read(key: AppStorageKey.instance.userData) ?? "";
      if (response.isNotEmpty) {
        var jData = jsonDecode(response);
        return AppUserData.fromJson(jData);
      }
    } catch (e) {
      errorLog("getUser", e);
    }
    return null;
  }

  ////////////////  agency data
  Future<void> setAgency(AppAgencyData value) async {
    try {
      await box.write(key: AppStorageKey.instance.userData, value: jsonEncode(value.toJson()));
    } catch (e) {
      errorLog("set role ", e);
    }
  }

  Future<AppAgencyData?> getAgency() async {
    try {
      var response = await box.read(key: AppStorageKey.instance.userData) ?? "";
      if (response.isNotEmpty) {
        var jData = jsonDecode(response);
        return AppAgencyData.fromJson(jData);
      }
    } catch (e) {
      errorLog("getUser", e);
    }
    return null;
  }

  ///////////////////////  on board screen

  Future<void> setOnboardScreen() async {
    try {
      await box.write(key: AppStorageKey.instance.onboard, value: "on board screen");
    } catch (e) {
      errorLog("setOnboardScreen", e);
    }
  }

  Future<String> getOnboardScreen() async {
    try {
      return await box.read(key: AppStorageKey.instance.onboard) ?? "";
    } catch (e) {
      errorLog("getOnboardScreen", e);
      return "";
    }
  }

  /////////////////////  user role
  // Future<void> setUserRole(String value) async {
  //   try {
  //     await box.write(AppStorageKey.instance.userRole, value);
  //   } catch (e) {
  //     errorLog("set user role", e);
  //   }
  // }

  // String? getUserRole() {
  //   try {
  //     return box.read(AppStorageKey.instance.userRole);
  //   } catch (e) {
  //     errorLog("get user role", e);
  //     return "";
  //   }
  // }

  ///logout
  Future<void> storageClear() async {
    try {
      await box.deleteAll();
      await box.write(key: AppStorageKey.instance.onboard, value: "on board screen");
    } catch (e) {
      errorLog("logout", e);
    }
  }
}
