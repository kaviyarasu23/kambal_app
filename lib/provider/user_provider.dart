import 'dart:developer';

import 'package:aliceblue/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../router/route_names.dart';
import 'core/default_change_notifier.dart';
import 'web_scoket_helper_provider.dart';
import 'websocket_provider.dart';

final userProvider = ChangeNotifierProvider((ref) => UserProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class UserProvider extends DefaultChangeNotifier {
  UserProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  Future<void> sessionLogout({required BuildContext context}) async {
    try {
      try {
        toggleLoadingOn(false);
      } catch (e) {
        log("TOGGLE LOADING FALSE ::: $e");
      }

      if (ref.read(webscoketHelperProvider).isWebscoketConnected) {
        ref.read(websocketProvider).closeSocket();
      }

      final String userId = pref.userId ?? '';
      final String userName = pref.userName ?? '';
      final String mobileId = pref.mobileId ?? '';
      final String mobileName = pref.mobileName ?? '';
      final String fcmToken = pref.fcmToken ?? '';
      final String userTheme = pref.userTheme ?? 'system';
      final String userLanguage = pref.userLanguage ?? 'english';

      pref.clearLocalPref();

      pref.setUserId(userId);
      pref.setUserName(userName: userName);
      pref.setUserThemeMode(userTheme);
      pref.setMobileId(mobileId: mobileId);
      pref.setMobileName(mobileName: mobileName);
      pref.setFCMToken(fcmToken);
      pref.setUserLanguage(userLanguage);
      pref.setActiveScreen(screen: 'login');
      pref.setSessionLogoutStatus(true);
      log("TOGGLE LOADING CHECK ::: ${ref.read(loginProvider).loading}");
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.splash, (route) => false);
    } catch (e) {
      log("Failed to session logout :: $e");
    }
  }

  /// Method to switch Account
  ///
  /// return [void]

  Future<void> switchAccount({required BuildContext context}) async {
    try {
      try {
        toggleLoadingOn(false);
      } catch (e) {
        log("TOGGLE LOADING FALSE ::: $e");
      }
      ref.read(loginProvider).clearController();
      ref.read(loginProvider).clearError();
      final bool isFirstTimeOpen = pref.isShowWelcomeUser;
      final String theme = pref.userTheme ?? 'system';
      final String mobileId = pref.mobileId ?? '';
      final String fcmToken = pref.fcmToken ?? '';
      pref.clearLocalPref();
      pref.setWelcomeUserType(isWelcome: isFirstTimeOpen);
      pref.setMobileId(mobileId: mobileId);
      pref.setFCMToken(fcmToken);
      pref.setUserThemeMode(theme);
      log("IS SHOW WELCOME :: $isFirstTimeOpen");
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.userId, (route) => false);
    } catch (e) {
      log("Failed to switch account ::: $e");
    }
  }
}
