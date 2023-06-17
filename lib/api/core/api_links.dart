class ApiLinks {
  // commonly used shared variable

  static String get norenWSURL =>
      // "wss://ws2.aliceblueonline.com/NorenWS/";
      "wss://ch1.aliceblueonline.com/NorenWS/";
  static const String fcmServerKey =
      "AAAAI9bMeLU:APA91bGcusqK-gdb7x_3KNs0yXJlu66VYNPty7xYYElY1kfiexpaPeTQoAeLWzA5qzBfrq9jr4HYu3RwbjGz8xloiMN7bWPGhMDPH1KFFcbDY4N7GwWPJXz3pgU809CNLuMtx9b50qzb";
  static const String version = "1.0.0";
  static const String loginType = "MOB";

  static String get mainBase =>
      // "https://v3uat.aliceblueonline.com";
      "https://abaws.aliceblueonline.com";

  String get amogaPythonBase => "https://v2api.aliceblueonline.com/restpy";
  String get brokerageMainBase => "https://abbrk.aliceblueonline.com/rest";

  // sub domain

  String get commonBaseSub => "$mainBase/cu";
  String get authBaseSecondary => "$mainBase/auth";
  String get clientCommonBase => "$mainBase/client-rest";
  String get ordersBase => "$mainBase/od-rest";
  String get positionsBase => "$mainBase/po-rest/";
  String get holdingsBase => "$mainBase/ho-rest/";
  String get mwRest => "$mainBase/mw-rest";
  String get scripRest => "$mainBase/scrips-rest/";

  // login

  String get getVersionCheck => '$commonBaseSub/version/';
  String get checkUser => "$authBaseSecondary/access/client/verify";
  String get validatePass => "$authBaseSecondary/access/pwd/validate";
  String get unblockUser => "$authBaseSecondary/access/client/unblock";
  String get forgotPassword => "$authBaseSecondary/access/pwd/forget";
  String get sendOTP => "$authBaseSecondary/access/otp/send";
  String get verifyTotp => '$authBaseSecondary/access/topt/verify';
  String get generateScanner => "$authBaseSecondary/access/scanner/generate";
  String get verifyOTPTotp => '$authBaseSecondary/access/scanner/get';
  String get enableTotp => '$authBaseSecondary/access/topt/enable';
  String get unblockUserVerifyOTP =>
      "$authBaseSecondary/access/client/unblock/verify";
  String get validateOTP => "$authBaseSecondary/access/otp/validate";
  String get forgotPasswordVerifyOTP =>
      "$authBaseSecondary/access/pwd/forget/verify";
  String get resetpass => "$authBaseSecondary/access/pwd/reset";

  // WebScokets

  String get createSessionWS => '$clientCommonBase/profile/createWsSess';
  String get invalidateSessionWS =>
      '$clientCommonBase/profile/invalidateWsSess';

  // Portfolio

  String get getPositions => '$positionsBase/positions';
  String get getHoldings => '$holdingsBase/holdings/';
  String get mtfHoldings => '$holdingsBase/holdings/mtf';
  String get positionConvert => "$positionsBase/positions/conversion";
  String get positionSquareOff => "$ordersBase/orders/positions/sqroff";

  // Marketwatch

  String get getAllMW => "$mwRest/marketWatch/getAllMwScrips/mob";
  String get fetchMWScrips => '$mwRest/marketWatch/getMWScrips/mob';
  String get createMw => '$mwRest/marketWatch/createMW';
  String get deleteMWScrips => '$mwRest/marketWatch/deletescrip';
  String get addScripMW => '$mwRest/marketWatch/addscrip';
  String get getContractInfo => "$scripRest/scrip/contract/info";
  String get getSecurityInfo => '$scripRest/scrip/security/info';
  String get renameMW => '$mwRest/marketWatch/renameMW';
  String get sortMWOrder => '$mwRest/marketWatch/sortMwScrips';
  String get searchScripList => '$scripRest/scrip/search';

  // Profile

  String get getProfile => "$clientCommonBase/profile/getclientdetails";

  // User preference

  String get updatePreference => '$clientCommonBase/preferences/mob/update';
  String get getUserPref => "$clientCommonBase/preferences/mob";
}
