import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _prefInstance;

  Future<void> init() async {
    _prefInstance = await SharedPreferences.getInstance();
  }

  Future clearLocalPref() async {
    await _prefInstance?.clear();
  }

  // Setter

  // Firebase FCM Token

  Future setFCMToken(String token) async =>
      _prefInstance?.setString(_fcmKey, token);

  Future setMobileName({required String mobileName}) async {
    _prefInstance?.setString(_mobileNameKey, mobileName);
  }

  Future setMobileId({required String mobileId}) async {
    _prefInstance?.setString(_mobileIdKey, mobileId);
  }

  Future setDeviceId({required String deviceId}) async {
    _prefInstance?.setString(_deviceIdKey, deviceId);
  }

  Future setUserId(String index) async => _prefInstance?.setString(
        _userIdKeyKey,
        index,
      );

  Future setUserName({required String userName}) async {
    _prefInstance?.setString(_userNameKey, userName);
  }

  Future setSessionId(String sessionId) async {
    log("session:: $sessionId");
    _prefInstance?.setString(_sessionKey, sessionId);
  }

  Future setLocalSessionId(String localSessionId) async {
    log("localSessionId:: $localSessionId");
    _prefInstance?.setString(_localSessionIdKey, localSessionId);
  }

  Future setActiveScreen({required String screen}) async =>
      _prefInstance?.setString(_activeScreenKey, screen);

  Future setUserThemeMode(String themeMode) async =>
      _prefInstance?.setString(_userThemeModeKey, themeMode);

  Future setUserLanguage(String userLanguage) async =>
      _prefInstance?.setString(_userLanguageKey, userLanguage);

  Future setSessionLogoutStatus(bool sessionLogoutStatus) async =>
      _prefInstance?.setBool(_sessionLogoutKey, sessionLogoutStatus);

  Future setBiometricEnableStatus({required bool isBioEnable}) async {
    _prefInstance?.setBool(_isBioEnableKey, isBioEnable);
  }

  Future setUserType({required bool isGuestUser}) async {
    _prefInstance?.setBool(_isGuestUserKey, isGuestUser);
  }

  Future setWelcomeUserType({required bool isWelcome}) async {
    _prefInstance?.setBool(_isShowWelcomeUserKey, isWelcome);
  }

  Future setUserPassword({required String password}) async =>
      _prefInstance?.setString(_userPasswordKey, password);

  Future setBottomTabIndex(int index) async =>
      _prefInstance?.setInt(_bottomTabIndexKey, index);

  Future setPortfolioTabIndex(int index) async =>
      _prefInstance?.setInt(_portfolioTabIndexKey, index);

  Future setFixedHeader({required bool isfixedHeader}) async =>
      _prefInstance?.setBool(_isfixedHeaderKey, isfixedHeader);

  Future setPOAUserStatus(bool isPoaUser) async {
    log("isPoaUser ::: $isPoaUser");
    _prefInstance?.setBool(_isPOAClientKey, isPoaUser);
  }

  Future setWLTabIndex(int index) async =>
      _prefInstance?.setInt(_watchListTabIndexKey, index);

  Future setMWView(bool isMWViewChoice) async {
    log("isListView ::: $isMWViewChoice");
    _prefInstance?.setBool(_watchListViewKey, isMWViewChoice);
  }

  Future setIsAskBidEnable({required int wsCardTypeVal}) async {
    _prefInstance?.setInt(_wsCardTypeKey, wsCardTypeVal);
  }

  Future setScripAddTopChoice(bool isScripAddTopChoice) async {
    log("isScripAddTop ::: $isScripAddTopChoice");
    _prefInstance?.setBool(_isScripAddTopKey, isScripAddTopChoice);
  }

  Future setWatchListDefaultTab(List<String> defaultTabs) async =>
      _prefInstance?.setStringList(_watchListDefaultTabKey, defaultTabs);

  Future setFixedOrderWindow({required bool isFixedOrderWindow}) async {
    _prefInstance?.setBool(_isFixedOrderWindowKey, isFixedOrderWindow);
  }

  // Getter

  String? get fcmToken => _prefInstance?.getString(_fcmKey);
  String? get mobileName => _prefInstance?.getString(_mobileNameKey) ?? "";
  String? get mobileId => _prefInstance?.getString(_mobileIdKey) ?? "";
  String? get deviceId => _prefInstance?.getString(_deviceIdKey) ?? "";
  String? get userId => _prefInstance?.getString(_userIdKeyKey) ?? '';
  String? get userName => _prefInstance?.getString(_userNameKey) ?? '';
  String? get sessionId => _prefInstance?.getString(_sessionKey) ?? '';
  String? get locaSessionId => _prefInstance?.getString(_localSessionIdKey);
  String? get activeScreen => _prefInstance?.getString(_activeScreenKey);
  String? get userTheme =>
      _prefInstance?.getString(_userThemeModeKey) ?? 'system';
  String? get userLanguage =>
      _prefInstance?.getString(_userLanguageKey) ?? 'english';
  bool? get sessionLogoutStatus =>
      _prefInstance?.getBool(_sessionLogoutKey) ?? false;
  bool? get isBioEnable => _prefInstance?.getBool(_isBioEnableKey) ?? false;
  bool get isGuestUser => _prefInstance?.getBool(_isGuestUserKey) ?? false;
  bool get isShowWelcomeUser =>
      _prefInstance?.getBool(_isShowWelcomeUserKey) ?? true;
  String? get userPassword => _prefInstance?.getString(_userPasswordKey);
  int get bmTabIndex => _prefInstance?.getInt(_bottomTabIndexKey) ?? 0;
  int get portfolioTabIndex =>
      _prefInstance?.getInt(_portfolioTabIndexKey) ?? 0;
  bool get isFixedHeader => _prefInstance?.getBool(_isfixedHeaderKey) ?? false;
  bool get getIsPOAClient => _prefInstance?.getBool(_isPOAClientKey) ?? false;
  int get wlTabIndex => _prefInstance?.getInt(_watchListTabIndexKey) ?? 0;
  bool? get isListView => _prefInstance?.getBool(_watchListViewKey) ?? true;
  int get wsCardType => _prefInstance?.getInt(_wsCardTypeKey) ?? 0;
  bool? get isMWScripAddTop =>
      _prefInstance?.getBool(_isScripAddTopKey) ?? true;
  List<String> get marketWatchDefaultTab =>
      _prefInstance?.getStringList(_watchListDefaultTabKey) ?? [];
  bool get isFixedOrderWindow =>
      _prefInstance?.getBool(_isFixedOrderWindowKey) ?? false;
}

// Key variable

const String _fcmKey = "fcmKey";
const String _mobileNameKey = 'mobileNameKey';
const String _mobileIdKey = 'mobileIdKey';
const String _deviceIdKey = 'deviceIdKey';
const String _userIdKeyKey = "userIdKey";
const String _userNameKey = "userNameKey";
const String _sessionKey = "sessionKey";
const String _localSessionIdKey = "localSessionIdKey";
const String _activeScreenKey = 'activeScreenKey';
const String _userThemeModeKey = '_userThemeModeKey';
const String _userLanguageKey = "userLanguageKey";
const String _sessionLogoutKey = "sessionLogoutKey";
const String _isBioEnableKey = 'isBioEnableKey';
const String _isGuestUserKey = "isGuestUserKey";
const String _isShowWelcomeUserKey = "isGuestUserKey";
const String _userPasswordKey = "userPasswordKey";
const String _bottomTabIndexKey = "_bottomTabIndexKey";
const String _portfolioTabIndexKey = "portfolioTabIndexKey";
const String _isfixedHeaderKey = 'isfixedHeaderKey';
const String _isPOAClientKey = "isPOAClientKey";
const String _watchListTabIndexKey = "watchListTabIndexKey";
const String _watchListViewKey = "watchListViewKey";
const String _wsCardTypeKey = 'wsCardTypeKey';
const String _isScripAddTopKey = 'isScripAddTopKey';
const String _watchListDefaultTabKey = "watchListDefaultTabKey";
const String _isFixedOrderWindowKey = 'isFixedOrderWindowKey';
