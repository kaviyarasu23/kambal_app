import 'dart:developer';

import 'package:aliceblue/model/position_book_model.dart';
import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../api/core/api_links.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/place_order_input_model.dart';
import '../shared_widget/snack_bar.dart';
import '../util/functions.dart';
import 'core/default_change_notifier.dart';

final portfolioServiceSupportProvider =
    ChangeNotifierProvider((ref) => PortfolioServiceSupportHelperProvider(
          ref,
          locator<Preferences>(),
          locator<ApiExporter>(),
        ));

class PortfolioServiceSupportHelperProvider extends DefaultChangeNotifier {
  PortfolioServiceSupportHelperProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  /// Method to Position Square off
  ///
  ///

  Future<void> positionSquareOff({
    required BuildContext context,
  }) async {
    try {
      toggleLoadingOn(true);
      List<Map<String, dynamic>> input = [];
      List<PositionBookInfoResult> positionBookDataInfo =
          ref.read(portfolioProvider).positions;
      for (var element in positionBookDataInfo) {
        PlaceOrderInput elementInfo = PlaceOrderInput(
          exchange: element.exchange!,
          qty: isNumberNegative(element.netQty!)
              ? element.exchange!.toLowerCase() == "mcx"
                  ? (double.parse(element.netQty!.substring(1)) *
                          double.parse(element.lotsize ?? '1'))
                      .toStringAsFixed(0)
                  : element.netQty!.substring(1)
              : element.exchange!.toLowerCase() == "mcx"
                  ? (double.parse(element.netQty!) *
                          double.parse(element.lotsize ?? '1'))
                      .toStringAsFixed(0)
                  : element.netQty!,
          orderType: "Regular",
          priceType: "MKT",
          product: element.product!,
          tradingSymbol: element.tradingsymbol!,
          transType: isNumberNegative(element.netQty!) ? "B" : "S",
          ret: "DAY",
          source: ApiLinks.loginType,
        );
        input.add(elementInfo.toJson());
      }

      final res = await api.positionSquOff(
        context: context,
        ref: ref,
        input: input,
      );
      if (res != null) {
        if (res == "success") {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              successSnackbar("Position square off Successfully"));
          ref.read(portfolioProvider).fetchPositions(
                context: context,
              );
        } else if (res == "partial") {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              successSnackbar("Position square off Partially executed"));
          ref.read(portfolioProvider).fetchPositions(
                context: context,
              );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(successSnackbar("Position square off Error"));
        }

        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      log("Failed to positions square off ::: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }
}
