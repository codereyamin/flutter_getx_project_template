class AppStorageKey {
  AppStorageKey._privateConstructor();
  static final AppStorageKey _instance = AppStorageKey._privateConstructor();
  static AppStorageKey get instance => _instance;
  String token = "token";
  String onboard = "onboard";
  String suggestion = "suggestion";
  String refreshToken = "refreshToken";
  String userData = "userData";
  String userRole = "userRole";
  String language = "language";
  String country = "country";
}
