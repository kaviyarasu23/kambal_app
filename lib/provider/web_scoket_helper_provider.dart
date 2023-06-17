import 'dart:async';
import 'dart:developer';

import 'package:aliceblue/provider/menu_provider.dart';
import 'package:aliceblue/provider/tab_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/webscoket_connection_model.dart';
import '../util/functions.dart';
import 'websocket_provider.dart';

final webscoketHelperProvider =
    ChangeNotifierProvider((ref) => WebscoketHelperProvider(
          ref,
          locator<Preferences>(),
          locator<ApiExporter>(),
        ));

class WebscoketHelperProvider extends ChangeNotifier {
  WebscoketHelperProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  bool isWebscoketConnected = false;
  bool isSessionExpired = false;
  late Timer _timer;
  late Timer local;

  String depthChennalInput = '';
  String get depthChennalInputVal => depthChennalInput;
  bool isDepthActive = false;

  void changeWSConnectionStatus({required bool wsStatus}) {
    if (isWebscoketConnected != wsStatus) {
      isWebscoketConnected = wsStatus;
      heartBeatStateChange(
        isStart: true,
        isNeedToChange: true,
      );
    }
    isWebscoketConnected = wsStatus;
    notifyListeners();
  }

  void sessionExpireStatus({required bool sesionExpire}) {
    isSessionExpired = sesionExpire;
    notifyListeners();
  }

  void activeDepthChennalInput(
      {required String chennalVal, required bool isDepthAct}) {
    depthChennalInput = chennalVal;
    isDepthActive = isDepthAct;
    notifyListeners();
  }

  void heartBeatStateChange({required bool isStart, bool? isNeedToChange}) {
    if (checkIsInfOrNullOrNan(value: pref.sessionId ?? '')) {
      try {
        _timer.cancel();
        log("TIMER CANCELLED");
      } catch (e) {
        log("TIMER  CANCELLED");
      }
    } else if (isStart) {
      if (isNeedToChange != null) {
        if (isNeedToChange) {
          try {
            log("HB SENT NEED TO CHANGE WS CHECK ::: $isWebscoketConnected");
            local.cancel();
            _timer.cancel();
          } catch (e) {
            log("Failed to status change Timer cancel ::: $e");
          }
        }
      }
      _timer = Timer.periodic(Duration(seconds: isWebscoketConnected ? 30 : 3),
          (Timer t) {
        try {
          if (pref.activeScreen?.toLowerCase() != 'login') {
            heartBeat();
            local = t;
            t.cancel();
            _timer.cancel();
            heartBeatStateChange(isStart: true);
          }
        } catch (e) {
          log("HB SENT ERROR ::: $e");
          _timer.cancel();
        }
      });
    } else {
      _timer.cancel();
      log("TIMER CANCELLED");
    }
  }

  void heartBeat() {
    log("HB SENT TIME :: ${DateTime.now()}");
    ref.read(websocketProvider).establishConnection(
          channelInput: '',
          task: 'h',
        );
  }

  /// Method to create WS session
  ///
  ///

  Future<void> createWSSession({
    required BuildContext context,
  }) async {
    try {
      final SessionCreateInvalidateInput input = SessionCreateInvalidateInput(
        userId: pref.userId ?? '',
        source: "KBMOB",
      );
      await api.createWSSession(
        context: context,
        ref: ref,
        input: input,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Method to invalidate WS session
  ///
  ///

  Future<void> invalidateWSSession({
    required BuildContext context,
  }) async {
    try {
      final SessionCreateInvalidateInput input = SessionCreateInvalidateInput(
        userId: pref.userId ?? '',
        source: "KBMOB",
      );
      await api.invalidateWSSession(
        context: context,
        ref: ref,
        input: input,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Method to when the webscoket is disconnected afetr connection add subscription
  /// 
  /// 
  /// 

  void reSubscribeWS({required BuildContext context}) {
    if (ref.read(menuProvider).isExpanded || pref.isFixedHeader) {
      ref.read(tabControllProvider).requestWS(context: context);
    }
    // if (pref.bmTabIndex == 0) {
    //   ref(marketProvider).requestWS(
    //     isSubscribe: true,
    //     context: context,
    //   );
    // } else if (pref.bmTabIndex == 1) {
    //   ref(orderProvider).requestWS(
    //     isSubscribe: true,
    //     context: context,
    //   );
    // } else if (pref.bmTabIndex == 2) {
    //   ref(dashboardProvider).requestWS(
    //     context: context,
    //     isSubscribe: true,
    //   );
    // } else if (pref.bmTabIndex == 3) {
    //   ref(portfolioProvider).requestWSPort(
    //     isSubscribe: true,
    //     context: context,
    //   );
    // }

    // if (ref(marketDepthProvider).isDepthActive) {
    //   ref(websocketProvider).connectTouchLine(
    //     task: 'd',
    //     input: '${ref(marketDepthProvider).depthChennalInput}',
    //   );
    // }

    // if (pref.activeScreen == 'option chain') {
    //   ref(optionChainProvider).requestWS(
    //     isSubscribe: true,
    //     context: ref(tabControllProvider).context!,
    //   );
    // }

    // if (pref.activeScreen == 'sector') {
    //   ref(dashboardProvider).requestWS(
    //     isSubscribe: true,
    //     context: ref(tabControllProvider).context!,
    //   );
    // }

    // if (pref.activeScreen!.contains('analytics')) {
    //   ref(dashboardProvider).requestWS(
    //     isSubscribe: true,
    //     context: ref(tabControllProvider).context!,
    //   );
    // }
  } 

  Future<void> checkSessionValid({required BuildContext context}) async {
  //   try {
  //     sessionExpireStatus(sesionExpire: true);
  //     final res = pref.isGuestUser == false
  //         ? await ref(settingsProvider).getProfileData(context)
  //         : "success";
  //     if (res?.toLowerCase() == 'unauthourized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     }
  //   } catch (e) {
  //     log("Failed to check session via profile");
  //   } finally {}
  }
}
