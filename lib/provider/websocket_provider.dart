import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:aliceblue/provider/service_support_helper.dart';
import 'package:aliceblue/provider/tab_controller_provider.dart';
import 'package:aliceblue/provider/web_scoket_helper_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/core/api_links.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/ws_df_feed_model.dart';
import '../model/ws_tf_feed_model.dart';

final websocketProvider = ChangeNotifierProvider((ref) => WebSocketProvider(
      ref,
      locator<Preferences>(),
    ));

class WebSocketProvider extends ChangeNotifier {
  WebSocketProvider(
    this.ref,
    this.pref,
  );

  final Preferences pref;
  final Ref ref;

  // Position

  double totalPnlPos = 0;
  double mtomPos = 0;
  double reliasedPnlPosition = 0;
  double unreliasedPnlPosition = 0;

  // Holdings

  double totalPnlHold = 0;
  double totalCurrent = 0;
  double totalTodayPnlHold = 0;
  double totalPnlPercentageHold = 0;
  double totalTodayPnlPercentageHold = 0;

  late WebSocketChannel channel;
  StreamController<TouchlineUpdateStream> tfUpdate =
      StreamController<TouchlineUpdateStream>.broadcast();
  StreamController<DepthWSResponse> dfUpdate =
      StreamController<DepthWSResponse>.broadcast();
  StreamController<double> positionTotalPnl =
      StreamController<double>.broadcast();
  StreamController<double> holdingsTotalPnl =
      StreamController<double>.broadcast();
  StreamController<double> holdingsTotalTodayPnl =
      StreamController<double>.broadcast();
  StreamController<double> holdingsTotalCurrent =
      StreamController<double>.broadcast();
  StreamController<double> holdingsTotalPnlPercentage =
      StreamController<double>.broadcast();
  StreamController<double> holdingsTotalTodayPnlPercentage =
      StreamController<double>.broadcast();

  StreamController<double> positionMTM = StreamController<double>.broadcast();
  StreamController<double> reliasedPnlPos =
      StreamController<double>.broadcast();
  StreamController<double> unreliasedPnlPos =
      StreamController<double>.broadcast();

  void closeSocket() {
    channel.sink.close();
  }

  Future<void> establishConnection({
    required String channelInput,
    required String task,
  }) async {
    if (pref.sessionId != null) {
      if (task.toLowerCase() == 'd' || task.toLowerCase() == 'ud') {
        ref.read(webscoketHelperProvider).activeDepthChennalInput(
              chennalVal: channelInput,
              isDepthAct: task.toLowerCase() == 'd' ? true : false,
            );
      }
      log("CONNECTION CHECK ::: ${ref.read(webscoketHelperProvider).isWebscoketConnected}");
      if ((!(ref.read(webscoketHelperProvider).isWebscoketConnected))) {
        log(":: Connecting :: KAMBALA");
        final bytes = utf8.encode(pref.sessionId!); // data being hashed
        final bytes1 = utf8.encode(sha256.convert(bytes).toString());
        final digest = sha256.convert(bytes1).toString();
        log('DIGEST ::::: $digest');
        channel = IOWebSocketChannel.connect(ApiLinks.norenWSURL);
        final data = {
          "t": "c",
          "actid": '${pref.userId}_KB${ApiLinks.loginType}',
          "uid": '${pref.userId}_KB${ApiLinks.loginType}',
          "source": "KB${ApiLinks.loginType}",
          "susertoken": digest,
        };
        log("CONNECTION INPUT ::: $data");
        channel.sink.add(jsonEncode(data));
        channel.stream.listen((data) {
          log("ALL FEED  ::  $data");

          final res = jsonDecode(data.toString());
          // log(res['s'].toString());

          if ((res['s'] ?? '').toString().toLowerCase() == "ok" &&
              (res['t'] ?? '').toString().toLowerCase() == "ck") {
            log(":: Connecting :: KAMBALA OK :::: END TIME ::: ${DateTime.now()} :::: TASK ::: $task");
            ref
                .read(webscoketHelperProvider)
                .changeWSConnectionStatus(wsStatus: true);
            if (!(ref.read(webscoketHelperProvider).isSessionExpired)) {
              ref
                  .read(webscoketHelperProvider)
                  .sessionExpireStatus(sesionExpire: false);
            }
            // subscribeOrderStatus();
            ref.read(webscoketHelperProvider).reSubscribeWS(
                  context: ref.read(tabControllProvider).context!,
                );
          }
          if ((res['s'] ?? '').toString().toLowerCase() == "not_ok" &&
              (res['t'] ?? '').toString().toLowerCase() == "ck") {
            ref
                .read(webscoketHelperProvider)
                .changeWSConnectionStatus(wsStatus: false);
            if (!(ref.read(webscoketHelperProvider).isSessionExpired)) {
              ref.read(webscoketHelperProvider).checkSessionValid(
                    context: ref.read(tabControllProvider).context!,
                  );
            }
          }

          switch (res['t'].toString().toLowerCase()) {
            case "tf":
              log("Scrip Feed :::: $data");

              tfUpdate.add(
                TouchlineUpdateStream.fromJson(res),
              );

              if (pref.bmTabIndex == 3 || pref.bmTabIndex == 2) {
                positionTotalPnlCal(TouchlineUpdateStream.fromJson(res));
              }

              // if (pref.activeScreen == 'option chain') {
              //   getOptionChainSpotIndex(TouchlineUpdateStream.fromJson(res));
              // }

              break;
            case "tk":
              log("Scrip Acknowledgement :::: $data");
              tfUpdate.add(
                TouchlineUpdateStream.fromJson(res),
              );
              if (pref.bmTabIndex == 3 || pref.bmTabIndex == 2) {
                positionTotalPnlCal(TouchlineUpdateStream.fromJson(res));
              }
              // if (pref.activeScreen == 'option chain') {
              //   getOptionChainSpotIndex(TouchlineUpdateStream.fromJson(res));
              // }
              // if (pref.bmTabIndex == 1 && pref.oderTabIndex == 3) {
              //   setBasketListLtpSet(TouchlineUpdateStream.fromJson(res));
              // }
              break;
            case "dk":
              log("DK ::: ${res.toString()}");
              dfUpdate.add(DepthWSResponse.fromJson(res));
              break;
            case "df":
              log("DF ::: ${res.toString()}");
              dfUpdate.add(DepthWSResponse.fromJson(res));
              break;
            case "om":
              log("OM MESSAGE ::: ${jsonEncode(res.toString())}");
              // orderStatusUpdate.add(OrderStatusFeedWs.fromJson(res));
              // orderStatusNotification(
              //     orderStatus: OrderStatusFeedWs.fromJson(res));

              break;
          }
        })
          ..onDone(() async {
            try {
              ref.read(webscoketHelperProvider)
                  .changeWSConnectionStatus(wsStatus: false);
              log(":: DONE ERR :::: Connection Closed ::: TIME ::: ${DateTime.now()}");
            } catch (e) {}
          })
          ..onError((handleError) async {
            try {
              ref.read(webscoketHelperProvider)
                  .changeWSConnectionStatus(wsStatus: false);
              log(":: ON ERR :::: Connection Closed ::: TIME ::: ${DateTime.now()}");
            } catch (e) {}
          });
      } else {
        if (ref.read(webscoketHelperProvider).isWebscoketConnected &&
            (task.toLowerCase() == 't' ||
                task.toLowerCase() == 'u' ||
                task.toLowerCase() == 'd' ||
                task.toLowerCase() == 'ud' ||
                task.toLowerCase() == 'h')) {
          connectTouchLine(input: channelInput, task: task);
        }
      }
    }
  }


  void connectTouchLine({required String task, required String input}) {
    final data = {
      "t": task,
      "k": input,
    };
    log('Subscription ws:: $input $task');
    // log('Status ws::$wsConnected');
    // log("SUB :: $data");
    channel.sink.add(jsonEncode(data));
  }

  void subscribeOrderStatus() {
    final data = {
      "actid": "${pref.userId}_KB${ApiLinks.loginType}",
      "t": "o",
    };
    channel.sink.add(jsonEncode(data));
  }

  /// Method to calculate position page pnl
  /// 
  /// 
  /// 
  
  void positionTotalPnlCal(TouchlineUpdateStream update) {
    if (((pref.bmTabIndex == 3 && pref.portfolioTabIndex == 1)) &&
        ref.read(portfolioProvider).positions.isNotEmpty) {
      for (var element in ref.read(portfolioProvider).positions) {
        if (element.token == update.tk) {
          element.ltp = update.lp == null || update.lp! == 'null'
              ? element.ltp
              : update.lp!;

          String realisedPnlPos = ref.read(serviceSupportProvider)
              .realisedProfitLoss(
                data: element,
              )
              .toString();
          String unrealisedPnlPos = ref.read(serviceSupportProvider)
              .unRealisedProfitLoss(data: element)
              .toString();
          String pnlVal =
              (double.parse(realisedPnlPos) + double.parse(unrealisedPnlPos))
                  .toStringAsFixed(2);

          String mtomVal = (ref.read(serviceSupportProvider).realisedProfitLoss(
                    data: element,
                    isTodayPnl: true,
                  ) +
                  ref.read(serviceSupportProvider).unRealisedProfitLoss(
                    data: element,
                    isTodayPnl: true,
                  ))
              .toStringAsFixed(2);
          element.pnl = pnlVal;
          element.mtm = mtomVal;
          element.realizedPnl = realisedPnlPos;
          element.unrealizedPnl = unrealisedPnlPos;
          calculateTotalPnlPos();
        }
      }
    } else if (pref.bmTabIndex == 3 && pref.portfolioTabIndex == 0 ||
        (pref.bmTabIndex == 2)) {
      if (ref.read(portfolioProvider).holdings.isNotEmpty &&
          ref.read(portfolioProvider).holdings.isNotEmpty) {
        for (var element in ref.read(portfolioProvider).holdings) {
          if (element.symbol![0].token == update.tk) {
            element.symbol![0].ltp = update.lp == null || update.lp! == 'null'
                ? element.symbol![0].ltp
                : update.lp!;
            calculateTotalPnlHold();
          }
        }
      }
    }
  }

  void calculateTotalPnlPos() {
    totalPnlPos = 0;
    mtomPos = 0;
    reliasedPnlPosition = 0;
    unreliasedPnlPosition = 0;
    for (var element in ref.read(portfolioProvider).positions) {
      totalPnlPos += double.parse(element.pnl!.replaceAll(',', ''));
      mtomPos += double.parse(element.mtm!.replaceAll(',', ''));
      reliasedPnlPosition +=
          double.parse(element.realizedPnl!.replaceAll(',', ''));
      unreliasedPnlPosition +=
          double.parse(element.unrealizedPnl!.replaceAll(',', ''));
    }
    positionTotalPnl.add(totalPnlPos);
    positionMTM.add(mtomPos);
    reliasedPnlPos.add(reliasedPnlPosition);
    unreliasedPnlPos.add(unreliasedPnlPosition);
    log("POSITION TOTAL PNL CAL ::: WHOLE $totalPnlPos");
    log("POSITION TODAY PNL CAL ::: WHOLE $mtomPos");
  }

  void calculateTotalPnlHold() {
    totalPnlHold = 0;
    totalCurrent = 0;
    totalTodayPnlHold = 0;
    totalPnlPercentageHold = 0;
    totalTodayPnlPercentageHold = 0;
    for (var element in ref.read(portfolioProvider).holdings) {
      totalCurrent += (double.parse(element.symbol![0].ltp!.replaceAll(',', '')) *
          double.parse(element.netQty!.replaceAll(',', '')));
    }

    totalPnlHold = (totalCurrent - ref.read(portfolioProvider).totalInvest);
    totalTodayPnlHold = (totalCurrent - ref.read(portfolioProvider).totalPreClose);
    totalPnlPercentageHold =
        ((totalPnlHold / ref.read(portfolioProvider).totalInvest) * 100);
    totalTodayPnlPercentageHold =
        ((totalTodayPnlHold / ref.read(portfolioProvider).totalPreClose) * 100);

    holdingsTotalCurrent.add(totalCurrent);
    holdingsTotalPnl.add(totalPnlHold);
    holdingsTotalTodayPnl.add(totalTodayPnlHold);
    holdingsTotalPnlPercentage.add(totalPnlPercentageHold);
    holdingsTotalTodayPnlPercentage.add(totalTodayPnlPercentageHold);
    log("TOTAL PNL HOLDINGS BOOK WS ::: $totalPnlHold");
    notifyListeners();
  }
}
