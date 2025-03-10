class AppRoutes {
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  /////////////  initial or splash screen
  final String initial = "/";
  final String wellCome = "/wellCome";
  final String errorScreen = '/errorScreen';
  final String notFoundScreen = "/notFoundScreen";
  /////////////////////// auth related all  screen
  final String loginScreen = "/loginScreen";
  final String otpVerificationScreen = "/otp-verification";
  final String forgotScreen = "/forgot-screen";
  final String signUpScreen = "/signup-screen";
  final String changePasswordScreen = "/change-password-screen";
  //////////////////////  app  navigation
  final String appNavigationScreen = "/app-navigation-screen";
  ////////////////////// base
  final String termsAndConditions = "/terms-and-conditions";
  final String privacyPolicy = "/privacy-policy";
  final String aboutUs = "/about-us";
}
