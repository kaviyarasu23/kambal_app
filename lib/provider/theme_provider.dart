import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/preferences.dart';
import '../locator/locator.dart';

final themeProvider = ChangeNotifierProvider(
    (ref) => ThemesProvider(ref, locator<Preferences>()));

class ThemesProvider extends ChangeNotifier {
  ThemesProvider(
    this.ref,
    this.pref,
  );
  final Ref ref;
  final Preferences pref;

  ThemeMode? themeMode;
  bool isDark = false;
  bool get isDarkMode => isDark;
  String? themeGroupType;

  bool getThemeData() {
    if (pref.userTheme != null) {
      if (pref.userTheme == 'system') {
        final brightness = SchedulerBinding.instance.window.platformBrightness;
        themeMode =
            brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
        pref.setUserThemeMode('system');
      } else {
        themeMode = pref.userTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }

      log('themeMode Pref ::: $themeMode');
    } else if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      log('themeMode System ::: $themeMode');
    } else {
      pref.setUserThemeMode('light');
      log('themeMode none ::: $themeMode');
    }
    isDark = themeMode == ThemeMode.dark;
    return isDark;
    // notifyListeners();
  }

  void changeTheme(String themeModeStatus) {
    if (themeModeStatus == 'system') {
      themeMode = ThemeMode.system;
      pref.setUserThemeMode('system');
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      themeMode =
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
      isDark = themeMode == ThemeMode.dark;
    } else if (themeModeStatus == 'light') {
      themeMode = ThemeMode.light;
      pref.setUserThemeMode('light');
      isDark = false;
    } else {
      themeMode = ThemeMode.dark;
      pref.setUserThemeMode('dark');
      isDark = true;
    }
    themeGroupType = themeModeStatus;
    notifyListeners();
  }
}
