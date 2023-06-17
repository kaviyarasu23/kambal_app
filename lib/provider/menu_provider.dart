import 'dart:developer';

import 'package:aliceblue/provider/web_scoket_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import 'core/default_change_notifier.dart';

final menuProvider = ChangeNotifierProvider((ref) => MenuProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class MenuProvider extends DefaultChangeNotifier {
  MenuProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  bool isExpand = false;
  bool get isExpanded => isExpand;

  int tabIndex = 0;

  void changeExpand(bool value) {
    isExpand = value;
    if (isExpand) {
      // ref.read(fundsProvider).getFundsData(context!);
    }
    // requestWS(context: context!);
    notifyListeners();
  }

  void setBottomTabIntial() {
    pref.setBottomTabIndex(0);
    tabIndex = 0;
  }

  Future<void> changeTabIndex(int index, BuildContext context) async {
    // unSubscribeWS(ctxt: context);
    tabIndex = index;
    pref.setBottomTabIndex(index);
    log("CURRENT BM TAB INDEX ::: ${pref.bmTabIndex}");
    // if (tabIndex == 0) {
    //   ref(dashboardProvider).requestWS(context: context, isSubscribe: true);
    // } else if (tabIndex == 1) {
    //   ref(marketProvider).requestWS(isSubscribe: true, context: context);
    // } else if (tabIndex == 2) {
    //   ref(portfolioProvider).requestWSPort(isSubscribe: true, context: context);
    // } else if (tabIndex == 3) {
    //   ref(orderProvider).requestWS(isSubscribe: true, context: context);
    //   ref(orderProvider).changeSearch(false);
    //   ref(orderProvider).changeFocus(context);
    // }

    notifyListeners();
  }

  /// Method to initial service call
  ///
  ///
  ///

  void initialCallService() {
    pref.setActiveScreen(screen: 'home');
    ref.read(webscoketHelperProvider).heartBeatStateChange(isStart: true);
  }
}
