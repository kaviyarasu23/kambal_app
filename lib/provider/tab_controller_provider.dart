import 'package:aliceblue/provider/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/indian_indices_model.dart';
import 'core/default_change_notifier.dart';
import 'portfolio_provider.dart';
import 'websocket_provider.dart';

final tabControllProvider =
    ChangeNotifierProvider((ref) => TabControllerProvider(
          ref,
          locator<Preferences>(),
          locator<ApiExporter>(),
        ));

class TabControllerProvider extends DefaultChangeNotifier {
  TabControllerProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  List<IndianIndices> spotIndicesHeader = spotIndicesDefault;

  BuildContext? context;

  void setContext({required BuildContext cxt}) {
    context = cxt;
    notifyListeners();
  }

  void changeSpotIndex({required IndianIndices value, required int index}) {
    spotIndicesHeader[index] = value;
    notifyListeners();
  }

  /// Method to webscoket subscription / unsubscription send
  ///
  ///
  ///

  void requestWS({required BuildContext context}) {
    String input = "";

    for (var element in spotIndicesHeader) {
      input += "${element.exchange}|${element.token}#";
    }

    if (pref.isFixedHeader) {
      if (ref.read(menuProvider).isExpanded) {
        ref.read(websocketProvider).establishConnection(
              channelInput: input.substring(0, input.length - 1),
              task: 't',
            );
      }
    } else {
      if (ref.read(menuProvider).isExpanded) {
        ref.read(websocketProvider).establishConnection(
              channelInput: input.substring(0, input.length - 1),
              task: 't',
            );
      } else {
        bool isToken1Available = false;
        bool isToken2Available = false;

        // Check if the Indices are available or not check

        if (pref.bmTabIndex == 0) {
        } else if (pref.bmTabIndex == 1) {
        } else if (pref.bmTabIndex == 2) {
        } else if (pref.bmTabIndex == 3) {
          isToken1Available = ref
              .read(portfolioProvider)
              .checkToken(value: spotIndicesHeader[0].token);
          isToken2Available = ref
              .read(portfolioProvider)
              .checkToken(value: spotIndicesHeader[1].token);
          if (!isToken1Available || !isToken2Available) {
            input = '';
            input +=
                "${!isToken1Available ? "${spotIndicesHeader[0].exchange}|${spotIndicesHeader[0].token}" : "${!isToken2Available ? "${spotIndicesHeader[1].exchange}|${spotIndicesHeader[1].token}" : ""}"}#";
            ref.read(websocketProvider).establishConnection(
                  channelInput: input.substring(0, input.length - 1),
                  task: 'u',
                );
          }
        } else if (pref.bmTabIndex == 4) {}

        // if (tabIndex == 2) {
        //   isToken1Available = ref(dashboardProvider)
        //       .checkToken(value: spotIndicesHeader[0].token);
        //   isToken2Available = ref(dashboardProvider)
        //       .checkToken(value: spotIndicesHeader[1].token);
        //   if (!isToken1Available || !isToken2Available) {
        //     input = '';
        //     input +=
        //         "${!isToken1Available ? "${spotIndicesHeader[0].exchange}|${spotIndicesHeader[0].token}" : "${!isToken2Available ? "${spotIndicesHeader[1].exchange}|${spotIndicesHeader[1].token}" : ""}"}#";
        //     ref(websocketProvider).establishConnection(
        //       channelInput: input.substring(0, input.length - 1),
        //       task: 'u',
        //       context: context,
        //       isFromWS: false,
        //     );
        //   }
        // } else if (tabIndex == 0) {
        //   isToken1Available =
        //       ref(marketProvider).checkToken(value: spotIndicesHeader[0].token);
        //   isToken2Available =
        //       ref(marketProvider).checkToken(value: spotIndicesHeader[1].token);
        //   if (!isToken1Available || !isToken2Available) {
        //     input = '';
        //     input +=
        //         "${!isToken1Available ? "${spotIndicesHeader[0].exchange}|${spotIndicesHeader[0].token}" : "${!isToken2Available ? "${spotIndicesHeader[1].exchange}|${spotIndicesHeader[1].token}" : ""}"}#";
        //     ref(websocketProvider).establishConnection(
        //       channelInput: input.substring(0, input.length - 1),
        //       task: 'u',
        //       context: context,
        //       isFromWS: false,
        //     );
        //   }
        // } else if (tabIndex == 3) {
        //   isToken1Available = ref(portfolioProvider)
        //       .checkToken(value: spotIndicesHeader[0].token);
        //   isToken2Available = ref(portfolioProvider)
        //       .checkToken(value: spotIndicesHeader[1].token);
        //   if (!isToken1Available || !isToken2Available) {
        //     input = '';
        //     input +=
        //         "${!isToken1Available ? "${spotIndicesHeader[0].exchange}|${spotIndicesHeader[0].token}" : "${!isToken2Available ? "${spotIndicesHeader[1].exchange}|${spotIndicesHeader[1].token}" : ""}"}#";
        //     ref(websocketProvider).establishConnection(
        //       channelInput: input.substring(0, input.length - 1),
        //       task: 'u',
        //       context: context,
        //       isFromWS: false,
        //     );
        //   }
        // } else if (tabIndex == 1) {
        //   isToken1Available =
        //       ref(orderProvider).checkToken(value: spotIndicesHeader[0].token);
        //   isToken2Available =
        //       ref(orderProvider).checkToken(value: spotIndicesHeader[1].token);

        //   if (!isToken1Available || !isToken2Available) {
        //     input +=
        //         "${!isToken1Available ? "${spotIndicesHeader[0].exchange}|${spotIndicesHeader[0].token}" : "${!isToken2Available ? "${spotIndicesHeader[1].exchange}|${spotIndicesHeader[1].token}" : ""}"}#";
        //     input = '';
        //     ref(websocketProvider).establishConnection(
        //       channelInput: input.substring(0, input.length),
        //       task: 'u',
        //       context: context,
        //       isFromWS: false,
        //     );
        // }
        // }
      }
    }
  }
}
