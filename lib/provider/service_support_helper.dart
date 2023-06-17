import 'dart:developer';

import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/holding_book_model.dart';
import '../model/position_book_model.dart';
import 'core/default_change_notifier.dart';

final serviceSupportProvider =
    ChangeNotifierProvider((ref) => ServiceSupportHelperProvider(
          ref,
          locator<Preferences>(),
          locator<ApiExporter>(),
        ));

class ServiceSupportHelperProvider extends DefaultChangeNotifier {
  ServiceSupportHelperProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  PositionBookInfo? positionBookInfo;
  PositionBookInfo? get getPositions => positionBookInfo;

  // Position Calculation value

  double totalPnlPos = 0.00;
  double mtomPos = 0.00;
  double totalRealisedPnl = 0;
  double totalUnRealisedPnl = 0;

  // Position filter option list

  List<PositionBookInfoResult> _positions = [];
  List<PositionBookInfoResult> _exitPositions = [];
  List<PositionBookInfoResult> _orderedPosition = [];
  List<String> exchangeFilterList = [];
  List<String> orderFilterList = [];

  // Holdings

  HoldingBookInfo? holdingBookInfo;
  HoldingBookInfo? get holdingInfo => holdingBookInfo;

  List<Holding> holdingScripList = [];

  // holdings calculation

  double netPnl = 0.0;
  double dayPnl = 0.0;
  double totalInvest = 0.0;
  double totalCurrent = 0.0;
  double totalPreClose = 0.0;
  double netPnlPerChange = 0.0;
  double dayPnlPerChange = 0.0;

  // Authorize / Revoke

  bool isAuthorizeShow = false;
  bool isRevokeShow = false;

  Future<void> fetchPositions({
    required BuildContext context,
    bool isNeedRefresh = false,
  }) async {
    try {
      toggleLoadingOn(true);
      positionBookInfo = await api.fetchPositions(
        context: context,
        ref: ref,
      );
      if ((ref.read(portfolioProvider).positionBookInfo != positionBookInfo) ||
          isNeedRefresh) {
        log("TESTING(${ref.read(portfolioProvider).portfolioTabs[1]})");
        calculateTotalMtom();
        log("TOTAL PNL VAL ::: ${totalPnlPos}");
        updatePosition();
        ref.read(portfolioProvider).requestWS(
              isSubscribe: true,
            );
        notifyListeners();
      } else {
        ref.read(portfolioProvider).requestWS(
              isSubscribe: true,
            );
      }
      notifyListeners();
    } catch (e) {
      log("Failed to fetch positions ::: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {
        log("$e");
      }
    }
  }

  void updatePosition() {
    ref.read(portfolioProvider).updatePosition(
          positionBookInfo: getPositions,
          updatedPositionBook: _positions,
          updatedExitBook: _exitPositions,
          updatedOrderedPositionBook: _orderedPosition,
          updatedtotalPnlPos: totalPnlPos,
          updatedMtomPos: mtomPos,
          updatedTotalRealisedPnl: totalRealisedPnl,
          updatedTotalUnRealisedPnl: totalUnRealisedPnl,
          updatedExchangeFilterList: exchangeFilterList,
          updatedorderFilterList: orderFilterList,
        );
    notifyListeners();
  }

  ///  calculating total mtom
  ///
  ///

  Future<void> calculateTotalMtom() async {
    totalPnlPos = 0;
    mtomPos = 0;
    int count = 0;
    int snoCount = 0;
    totalRealisedPnl = 0;
    totalUnRealisedPnl = 0;
    _exitPositions = [];
    _orderedPosition = [];
    final List<PositionBookInfoResult> temp = [];
    exchangeFilterList = [];
    orderFilterList = [];
    if (positionBookInfo != null &&
        positionBookInfo!.status! &&
        positionBookInfo!.result != null &&
        positionBookInfo!.result!.isNotEmpty) {
      positionBookInfo!.result!.forEach((element) {
        element.unrealizedPnl = unRealisedProfitLoss(data: element).toString();
        element.pnl = (double.parse(element.realizedPnl!) +
                double.parse(element.unrealizedPnl!))
            .toStringAsFixed(2);
        element.mtm = (realisedProfitLoss(
                  data: element,
                  isTodayPnl: true,
                ) +
                unRealisedProfitLoss(
                  data: element,
                  isTodayPnl: true,
                ))
            .toStringAsFixed(2);
        totalPnlPos += double.parse(element.pnl!);
        mtomPos += double.parse(element.mtm!);
        totalRealisedPnl += double.parse(element.realizedPnl!);
        totalUnRealisedPnl += double.parse(element.unrealizedPnl!);
        if (!exchangeFilterList.contains(element.exchange)) {
          exchangeFilterList.add(element.exchange!);
        }
        if (!orderFilterList.contains(element.product)) {
          orderFilterList.add(element.product!);
        }

        if (element.netQty != '0') {
          element.sno = snoCount;
          element.exitOrderIndex = count;
          _exitPositions.add(element);
          _orderedPosition.add(element);
          snoCount += 1;
          count = count + 1;
        } else {
          temp.add(element);
        }
      });
      if (temp.isNotEmpty) {
        temp.forEach((element) {
          element.sno = snoCount;
          _orderedPosition.add(element);
          snoCount += 1;
        });
      }
      orderFilterList.add("SHORT");
      orderFilterList.add("LONG");
      orderFilterList.add("CLOSED");
      _positions = _orderedPosition;
    } else {
      if (ref.read(portfolioProvider).positionBookInfo != null &&
          ref.read(portfolioProvider).positionBookInfo!.result != null &&
          ref.read(portfolioProvider).positionBookInfo!.result!.isNotEmpty) {}
    }
    log("TOTAL PNL CHECK ::: ${totalPnlPos}");
  }

  /// Calculate Position realised Profit Loss
  ///
  ///
  ///

  double realisedProfitLoss({
    required PositionBookInfoResult data,
    bool isTodayPnl = false,
  }) {
    double realise = 0;
    int closedQty = 0;
    int tempQty = 0;

    if (double.parse(data.buyQty ?? '0').ceil() > 0 &&
        double.parse(data.sellQty ?? '0').ceil() > 0) {
      if (double.parse(data.buyQty ?? '0') >
          double.parse(data.sellQty ?? '0').ceil()) {
        closedQty = double.parse(data.sellQty ?? '0').ceil();
      } else {
        closedQty = double.parse(data.buyQty ?? '0').ceil();
      }

      if (closedQty == 0) {
        closedQty = double.parse(data.buyQty ?? '0').ceil();
      }

      tempQty = data.exchange!.toLowerCase() == 'nfo' ||
              data.exchange!.toLowerCase() == 'bfo' ||
              data.exchange!.toLowerCase() == 'nse' ||
              data.exchange!.toLowerCase() == 'bse'
          ? closedQty
          : closedQty * double.parse(data.lotsize ?? '0').ceil();

      if (isTodayPnl) {
        realise = tempQty *
            (double.parse(data.mtmSellprice ?? '0') -
                double.parse(data.mtmBuyPrice ?? '0'));
      } else {
        realise = tempQty *
            (double.parse(data.sellPrice ?? '0') -
                double.parse(data.buyPrice ?? '0'));
      }
      return realise;
    } else {
      return realise;
    }
  }

  /// Calculate Position unrealised Profit Loss
  ///
  ///
  ///

  double unRealisedProfitLoss({
    required PositionBookInfoResult data,
    bool isTodayPnl = false,
  }) {
    double unRealise = 0;
    if (double.parse(data.netQty ?? '0').ceil() != 0) {
      double tempAvgPrc = 0;
      if (isTodayPnl) {
        tempAvgPrc = double.parse(data.netQty ?? '0').ceil() > 0
            ? double.parse(data.ltp ?? '0') -
                double.parse(data.mtmBuyPrice ?? '0')
            : double.parse(data.mtmSellprice ?? '0') -
                double.parse(data.ltp ?? '0');
      } else {
        tempAvgPrc = double.parse(data.netQty ?? '0').ceil() > 0
            ? double.parse(data.ltp ?? '0') - double.parse(data.buyPrice ?? '0')
            : double.parse(data.sellPrice ?? '0') -
                double.parse(data.ltp ?? '0');
      }
      int tempQtyMul = data.exchange!.toLowerCase() == 'nfo' ||
              data.exchange!.toLowerCase() == 'bfo' ||
              data.exchange!.toLowerCase() == 'nse' ||
              data.exchange!.toLowerCase() == 'bse'
          ? double.parse(data.netQty ?? '0').ceil()
          : double.parse(data.netQty ?? '0').ceil() *
              double.parse(data.lotsize ?? '0').ceil();
      if (tempQtyMul < 0) {
        tempQtyMul = tempQtyMul * -1;
      }
      unRealise = tempQtyMul * tempAvgPrc;
      return unRealise;
    } else {
      return unRealise;
    }
  }

  /// Method to Position convert
  ///
  ///

  Future<void> positionConvert({
    required BuildContext context,
    required PositionConvertInput input,
  }) async {
    try {
      toggleLoadingOn(true);
      final res = await api.convertPosition(
        context: context,
        ref: ref,
        input: input,
      );
      if (res) {
        fetchPositions(
          context: context,
          isNeedRefresh: true,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      log("Failed to convert positions ::: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  /// Method to Position Square off
  ///
  ///

  // Future<void> positionSquareOff({
  //   required BuildContext context,
  // }) async {
  //   try {
  //     toggleLoadingOn(true);
  //     List<Map<String, dynamic>> input = [];
  //     List<PositionBook> positionBookDataInfo = ref(positionProvider).positions;
  //     for (var element in positionBookDataInfo) {
  //       PlaceOrderInput elementInfo = PlaceOrderInput(
  //         exchange: element.exchange!,
  //         qty: isNumberNegative(element.netQty!)
  //             ? element.exchange!.toLowerCase() == "mcx" ? (double.parse(element.netQty!.substring(1)) * double.parse(element.lotsize ?? '1')).toStringAsFixed(0) : element.netQty!.substring(1)
  //             : element.exchange!.toLowerCase() == "mcx" ? (double.parse(element.netQty!) * double.parse(element.lotsize ?? '1')).toStringAsFixed(0) : element.netQty!,
  //         orderType: "Regular",
  //         priceType: "MKT",
  //         product: element.product!,
  //         tradingSymbol: element.tradingsymbol!,
  //         transType: isNumberNegative(element.netQty!) ? "B" : "S",
  //         ret: "DAY",
  //         source: ApiLinks.loginType,
  //       );
  //       input.add(elementInfo.toJson());
  //     }

  //     final res = await api.positionSquOff(
  //       context: context,
  //       ref: ref,
  //       input: input,
  //     );
  //     if (res != null) {
  //       log("CANCEL ORDER POSITION SQUARE OFF RES ::: STATUS CODE :: ${res.statusCode} ::: BODY ::: ${res.body}");
  //       if (res.statusCode == 200) {
  //         final json = jsonDecode(res.body);
  //         List<String> successOrderNo = [];
  //         for (var element in json) {
  //           if ((element['status'] ?? '').toString().toLowerCase() == 'ok' &&
  //               (element['message'] ?? '').toString().toLowerCase() ==
  //                   'success' &&
  //               element['result'] != null) {
  //             var successInfo = element['result'];
  //             successOrderNo.add(successInfo[0]['orderNo']);
  //           }
  //         }
  //         if (successOrderNo.length == input.length) {
  //           ScaffoldMessenger.of(context).clearSnackBars();
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               successSnackbar("Position square off Successfully"));
  //           fetchPositions(context: context,isNeedRefresh: true);
  //         } else if (successOrderNo.isNotEmpty) {
  //           ScaffoldMessenger.of(context).clearSnackBars();
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               successSnackbar("Position square off Partially executed"));
  //           fetchPositions(context: context,isNeedRefresh: true);
  //         } else {
  //           ScaffoldMessenger.of(context).clearSnackBars();
  //           ScaffoldMessenger.of(context)
  //               .showSnackBar(successSnackbar("Position square off Error"));
  //         }

  //         Navigator.pop(context);
  //         Navigator.pop(context);
  //       }
  //     }
  //   } catch (e) {
  //     log("Failed to positions square off ::: $e");
  //   } finally {
  //     try {
  //       toggleLoadingOn(false);
  //     } catch (e) {}
  //   }
  // }

  Future fetchHoldings({
    required BuildContext context,
  }) async {
    try {
      holdingBookInfo = await api.fetchHoldings(
        context: context,
        ref: ref,
      );

      if (ref.read(portfolioProvider).holdingInfo != holdingBookInfo) {
        addHoldingCalculation();
        if (holdingBookInfo != null &&
            holdingBookInfo!.status! &&
            holdingBookInfo!.result != null &&
            holdingBookInfo!.result!.isNotEmpty) {
          pref.setPOAUserStatus(holdingBookInfo!.result![0].poa ?? false);
          if (!pref.getIsPOAClient) {
            if (holdingBookInfo!.result![0].holdings != null) {
              isAuthorizeShow = holdingBookInfo!.result![0].holdings!
                  .any((element) => !element.authFlag!);
              isRevokeShow = holdingBookInfo!.result![0].holdings!
                  .any((element) => element.authFlag!);
            }
          } else {
            isAuthorizeShow = false;
            isRevokeShow = false;
          }
        }

        updateHoldings();
      }
    } catch (e) {
      log("Failed to fetch holdings :: $e");
    }
  }

  /// Method to update Holdings
  ///
  ///
  ///

  void updateHoldings() {
    ref.read(portfolioProvider).updateHoldingsInfo(
          revokeStatus: isRevokeShow,
          authourizeStatus: isAuthorizeShow,
          updatedholdings: holdingScripList,
          updatedDayPnl: dayPnl,
          updatedDayPnlPerChange: dayPnlPerChange,
          updatedNetPnl: netPnl,
          updatedNetPnlPerChange: netPnlPerChange,
          updatedTotalCurrent: totalCurrent,
          updatedTotalInvest: totalInvest,
          updatedTotalPrevClose: totalPreClose,
        );
  }

  /// Method to calculate PNL
  ///
  ///
  ///

  void addHoldingCalculation() {
    int count = 0;
    double _netPnlSum = 0.0;
    double _dayPnlSum = 0.0;
    double _prevCloseSum = 0.0;
    double _currentSum = 0.0;
    double _investSum = 0.0;

    if (holdingBookInfo != null &&
        holdingBookInfo!.status! &&
        holdingBookInfo!.result != null &&
        holdingBookInfo!.result!.isNotEmpty &&
        holdingBookInfo!.result![0].holdings != null) {
      holdingBookInfo!.result![0].holdings!.forEach((element) {
        final double _uploadedPrc = double.parse(element.buyPrice ?? '0.00');
        final int _tradedQty = double.parse(element.tradedQty ?? '0').ceil();
        final double sellAmount = double.parse(element.sellAmount ?? '0.00');
        final double _ltp = double.parse(element.symbol?[0].ltp ?? '0.00');
        final int _netQty = double.parse(element.netQty ?? '0').ceil();
        final double _realizedPnl = sellAmount - (_uploadedPrc * _tradedQty);
        final double _unrealizedPnl =
            (_netQty - _tradedQty) * (_ltp - _uploadedPrc);
        final double _pdc = double.parse(element.symbol?[0].pdc ?? '0.00');
        final double _realizedDaysPnl = sellAmount - (_pdc * _tradedQty);
        final double _unrealizedDaysPnl =
            (_netQty - _tradedQty) * (_ltp - _pdc);
        final double _pnlChangeVal = (_ltp - _uploadedPrc);
        final double _pnlPercentageChangeVal =
            ((_pnlChangeVal / _uploadedPrc) * 100);
        final double _todayPnlChangeVal = (_ltp - _pdc);
        final double _todayPnlPerChange = (((_ltp - _pdc) / _pdc) * 100);

        final double _pnlVal = _realizedPnl + _unrealizedPnl;
        final double _daysPnl = _realizedDaysPnl + _unrealizedDaysPnl;
        final double _investVal = (_uploadedPrc * _netQty);

        count = count + 1;
        element.netPnl = _pnlVal.toStringAsFixed(2);
        element.netPnlPerChange = _pnlPercentageChangeVal.toStringAsFixed(2);
        element.invest = _investVal.toStringAsFixed(2);
        element.change = _todayPnlChangeVal.toStringAsFixed(2);
        element.perChange = _todayPnlPerChange.toStringAsFixed(2);
        element.dayPnl = _daysPnl.toStringAsFixed(2);

        _dayPnlSum = _dayPnlSum + _daysPnl;
        _prevCloseSum = _prevCloseSum + (_pdc * _netQty);
        _netPnlSum = _netPnlSum + _pnlVal;
        _currentSum = (_currentSum + (_ltp * _netQty));
        _investSum = (_investSum + _investVal);
      });

      netPnl = _netPnlSum;
      dayPnl = _dayPnlSum;
      totalPreClose = _prevCloseSum;
      totalInvest = _investSum;
      totalCurrent = _currentSum;

      netPnlPerChange = (((totalCurrent - totalInvest) / totalInvest) * 100);
      dayPnlPerChange =
          (((totalCurrent - totalPreClose) / totalPreClose) * 100);
      holdingScripList = holdingBookInfo!.result![0].holdings ?? [];
    }
  }
}
