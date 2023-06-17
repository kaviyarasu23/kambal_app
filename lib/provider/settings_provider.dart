import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/get_user_preference_model.dart';
import '../model/user_profile_model.dart';
import 'core/default_change_notifier.dart';
import 'theme_provider.dart';

final settingsProvider = ChangeNotifierProvider((ref) => SettingsProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class SettingsProvider extends DefaultChangeNotifier {
  SettingsProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  // Profile

  ProfileRes? _profileRes;
  ProfileRes? get getProfileRes => _profileRes;

  String? orderTypes;
  String? get getOrderTypes => orderTypes;

  String? products;
  String? get getProducts => products;

  // User Pref

  GetUserPref? userPref;
  GetUserPref? get getUserPref => userPref;

  List<UpdatePrefInput> updateUserPref = [];
  List<UpdatePrefInput> get getUpdatePref => updateUserPref;

  /// Method to fetch User Profile
  ///
  ///
  ///

  Future<String?> getProfileData({required BuildContext context}) async {
    try {
      toggleLoadingOn(true);
      _profileRes = await api.getProfile(
        context: context,
        ref: ref,
      );
      if (_profileRes != null &&
          _profileRes!.result.isNotEmpty &&
          _profileRes!.result[0]!.clientName != "") {
        toggleLoadingOn(true);
        pref.setUserName(userName: _profileRes!.result[0]!.clientName);
        String pCode = '';
        for (final item in _profileRes!.result[0]!.priceTypes) {
          if (item.toLowerCase().trim() != 'bo' &&
              item.toLowerCase().trim() != 'co') {
            pCode += '$item,';
          }
        }
        orderTypes = "";
        orderTypes = pCode.substring(0, pCode.length - 1);
        String ProductTypes = "";
        for (final item in _profileRes!.result[0]!.productTypes) {
          ProductTypes += '$item,';
        }
        products = ProductTypes;
      }
      notifyListeners();
      return _profileRes?.status == 'not_ok' &&
              _profileRes?.message == 'unauthourized'
          ? 'unauthourized'
          : 'success';
    } catch (e) {
      log(e.toString());
    } finally {
      toggleLoadingOn(false);
    }
    return null;
  }

  void initlizePref() {
    if (userPref != null) {
      for (var element in userPref!.result) {
        if (element.tag.toLowerCase() == 'thm') {
          String theme = element.value.toString() == "0"
              ? "system"
              : element.value.toString() == "1"
                  ? "light"
                  : "dark";
          ref.read(themeProvider).changeTheme(theme);
        } else if (element.tag.toLowerCase() == 'n50') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          if (defaultTab.contains("nifty")) {
            if (element.value.toLowerCase() == "0") {
              defaultTab.remove("nifty");
              pref.setWatchListDefaultTab(defaultTab);
            }
          } else {
            if (element.value.toLowerCase() == "1") {
              defaultTab.add("nifty");
              pref.setWatchListDefaultTab(defaultTab);
            }
          }
        } else if (element.tag.toLowerCase() == 'bnf') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          if (defaultTab.contains("banknifty")) {
            if (element.value.toLowerCase() == "0") {
              defaultTab.remove("banknifty");
              pref.setWatchListDefaultTab(defaultTab);
            }
          } else {
            if (element.value.toLowerCase() == "1") {
              defaultTab.add("banknifty");
              pref.setWatchListDefaultTab(defaultTab);
            }
          }
        } else if (element.tag.toLowerCase() == 'snx') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          if (defaultTab.contains("sensex")) {
            if (element.value.toLowerCase() == "0") {
              defaultTab.remove("sensex");
              pref.setWatchListDefaultTab(defaultTab);
            }
          } else {
            if (element.value.toLowerCase() == "1") {
              defaultTab.add("sensex");
              pref.setWatchListDefaultTab(defaultTab);
            }
          }
        } else if (element.tag.toLowerCase() == 'fxh') {
          pref.setFixedHeader(
              isfixedHeader: (element.value.toString().toLowerCase() == '1'));
        } else if (element.tag.toLowerCase() == 'sow') {
          pref.setFixedOrderWindow(
              isFixedOrderWindow:
                  element.value.toString().toLowerCase() == '1');
        } else if (element.tag.toLowerCase() == 'sdp') {
          pref.setIsAskBidEnable(
              wsCardTypeVal: double.parse(element.value).ceil());
        } else if (element.tag.toLowerCase() == 'lng') {
          pref.setUserLanguage(
              element.value.toLowerCase() == 'en' ? 'english' : 'தமிழ்');
        } else if (element.tag.toLowerCase() == 'mwt') {
          pref.setScripAddTopChoice(element.value.toLowerCase() == '0');
        } else if (element.tag.toLowerCase() == 'mwv') {
          pref.setMWView(element.value.toLowerCase() == '0');
        }
      }
    }
  }

  /// Method to check if Any changes are happen
  ///
  ///

  Future<void> checkIfPreferenceChanged({
    required BuildContext context,
    required String tagName,
    bool isSingle = true,
  }) async {
    updateUserPref = [];

    if (userPref != null) {
      for (var element in userPref!.result) {
        if (element.tag.toLowerCase() == 'thm' &&
            tagName == 'thm' &&
            element.value.toLowerCase() !=
                (pref.userTheme!.toLowerCase() == "system"
                    ? "0"
                    : pref.userTheme!.toLowerCase() == "light"
                        ? "1"
                        : "2")) {
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.userTheme!,
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        } else if (element.tag.toLowerCase() == 'n50' && tagName == 'n50') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          final String niftyTabChoice =
              defaultTab.contains("nifty") ? '1' : '0';
          if (niftyTabChoice != element.value) {
            UpdatePrefInput updatePrefInput = UpdatePrefInput(
              tag: element.tag,
              value: defaultTab.contains("nifty") ? '1' : '0',
            );
            updateUserPref.add(updatePrefInput);
            if (isSingle) {
              break;
            }
          }
        } else if (element.tag.toLowerCase() == 'bnf' && tagName == 'bnf') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          final String bankNiftyTabChoice =
              defaultTab.contains("banknifty") ? '1' : '0';
          if (bankNiftyTabChoice != element.value) {
            UpdatePrefInput updatePrefInput = UpdatePrefInput(
              tag: element.tag,
              value: defaultTab.contains("banknifty") ? '1' : '0',
            );
            updateUserPref.add(updatePrefInput);
            if (isSingle) {
              break;
            }
          }
        } else if (element.tag.toLowerCase() == 'snx' && tagName == 'snx') {
          final List<String> defaultTab = pref.marketWatchDefaultTab;
          final String sensexTabChoice =
              defaultTab.contains("sensex") ? '1' : '0';
          if (sensexTabChoice != element.value) {
            UpdatePrefInput updatePrefInput = UpdatePrefInput(
              tag: element.tag,
              value: defaultTab.contains("sensex") ? '1' : '0',
            );
            updateUserPref.add(updatePrefInput);
            if (isSingle) {
              break;
            }
          }
        } else if (element.tag.toLowerCase() == 'fxh' &&
            tagName == 'fxh' &&
            (element.value.toString().toLowerCase() == '0' ? true : false) !=
                pref.isFixedHeader) {
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.isFixedHeader ? '1' : '0',
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        } else if (element.tag.toLowerCase() == 'sow' &&
            tagName == 'sow' &&
            (element.value.toLowerCase() == '0' ? true : false) !=
                pref.isFixedOrderWindow) {
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.isFixedOrderWindow ? '1' : '0',
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        } else if (element.tag.toLowerCase() == 'sdp' &&
            tagName == 'sdp' &&
            (element.value.toString().toLowerCase() == '0'
                    ? 0
                    : element.value.toString().toLowerCase() == '1'
                        ? 1
                        : 2) !=
                pref.wsCardType) {
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.wsCardType.toString(),
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        } else if (element.tag.toLowerCase() == 'mwv' &&
            tagName == 'mwv' &&
            (element.value.toString().toLowerCase() == '0') !=
                pref.isListView) {
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.isListView! ? "0" : "1",
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        } else if (element.tag.toLowerCase() == 'lng' &&
            tagName == 'lng' &&
            element.value.toLowerCase() !=
                (pref.userLanguage!.toLowerCase() == 'english' ? 'EN' : 'TA')) {
          pref.setUserLanguage(element.value);
          UpdatePrefInput updatePrefInput = UpdatePrefInput(
            tag: element.tag,
            value: pref.userLanguage!,
          );
          updateUserPref.add(updatePrefInput);
          if (isSingle) {
            break;
          }
        }
      }
    }
    if (updateUserPref.isNotEmpty) {
      if (isSingle) {
        updatePreference(context: context, updatePreference: updateUserPref[0]);
      } else {
        // updatePreferenceAll(context: context, updatePreference: updateUserPref);
      }
    }
  }

  /// Method to fetch User Preference
  ///
  ///

  Future<void> updatePreference({
    required BuildContext context,
    required UpdatePrefInput updatePreference,
  }) async {
    try {
      userPref = await api.updateUserPreference(
        input: updatePreference,
        context: context,
        ref: ref,
      );
      initlizePref();
      notifyListeners();
    } catch (e) {}
  }
}
