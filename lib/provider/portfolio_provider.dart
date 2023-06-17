import 'dart:developer';

import 'package:aliceblue/provider/service_support_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/holding_book_model.dart';
import '../model/position_book_model.dart';
import '../util/constants.dart';
import 'core/default_change_notifier.dart';
import 'websocket_provider.dart';

final portfolioProvider = ChangeNotifierProvider((ref) => PortfolioProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class PortfolioProvider extends DefaultChangeNotifier {
  PortfolioProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  // Tab Names

  List<String> portfolioTabs = [
    'holdings (0)',
    'position (0)',
  ];

  int tabBarIndex = 0;
  int get getTabIndex => tabBarIndex;

  // position convert qty error

  String? errorQuantity;
  final TextEditingController convertPositionController =
      TextEditingController();

  // Service Call

  bool isPositionInitialCall = true;
  bool isHoldingsInitialServiceCall = true;

  PositionBookInfo? positionBookInfo;
  PositionBookInfo? get getPositions => positionBookInfo;

  List<PositionBookInfoResult> positions = [];
  List<PositionBookInfoResult> exitPositions = [];
  List<PositionBookInfoResult> orderedPosition = [];
  List<String> exchangeFilterList = [];
  List<PositionBookInfoResult> filteredSearchItem = [];
  List<PositionBookInfoResult> sortFilteredPositionItems = [];
  PositionBookInfoResult? activePos;
  PositionBookInfoResult? get getActivePos => activePos;
  List<String> orderFilterList = [];
  List<String> get getOrderFilterList => orderFilterList;

  // Position Calculation

  double totalPnlPos = 0.0;
  double mtomPos = 0.0;
  double totalRealisedPnl = 0.0;
  double totalUnRealisedPnl = 0.0;

  // search position

  List<PositionBookInfoResult> filteredPositionSearchItems = [];
  final TextEditingController searchController = TextEditingController();
  bool isPosSearchEnable = false;

  // Holdings

  HoldingBookInfo? holdingBookInfo;
  HoldingBookInfo? get holdingInfo => holdingBookInfo;
  List<Holding> holdings = [];

  // Holdings Auth / Revoke

  bool isAuthorizeShow = false;
  bool get isAuthorize => isAuthorizeShow;
  bool isRevokeShow = false;
  bool get isRevokeBtnShow => isRevokeShow;

  // Holdings filter

  List<Holding> filteredHoldItems = [];
  List<String> filterStatusItemsList = [];
  List<Holding> holdingSearchItems = [];
  List<String> filterItemsListHoldIndex = [];
  List<String> filterItemsListHold = [];
  bool isHoldingsSearchEnable = false;

  // holdings calculation

  double netPnl = 0.0;
  double dayPnl = 0.0;
  double totalInvest = 0.0;
  double totalCurrent = 0.0;
  double totalPreClose = 0.0;
  double netPnlPerChange = 0.0;
  double dayPnlPerChange = 0.0;

  String activeFilter = 'default';
  String get activeFilterSelected => activeFilter;

  String _isDecending = 'default';
  String get getIsDecending => _isDecending;
  String _isUpperPrice = 'default';
  String get getIsUpperPrice => _isUpperPrice;
  String _isUpperPnl = 'default';
  String get getIsUpperPnl => _isUpperPnl;
  String _isExchange = 'default';
  String get getIsExch => _isExchange;
  String _isUpperPerchange = 'default';
  String get getIsUpperPercen => _isUpperPerchange;
  String _isUpperPnlPercent = 'default';
  String get getIsUpperPnlPercent => _isUpperPnlPercent;
  String _isUpperInvest = 'default';
  String get getIsUpperInvest => _isUpperInvest;

  /// Method to clear filter holdings
  ///
  ///
  ///

  void clearHoldingsFilter() {
    filteredHoldItems = [];
  }

  /// Method to clear filter Position
  ///
  ///
  ///

  void clearPositionsFilter() {
    isPosSearchEnable = false;
    filteredSearchItem = [];
    searchController.text = "";
    notifyListeners();
  }

  void updateHoldPosTab({required int len, required bool isHoldUpdate}) {
    bool isNeedToNotify = false;
    if (isHoldUpdate) {
      if (portfolioTabs[0]
              .split(" ")[1]
              .substring(1, portfolioTabs[0].split(" ")[1].length - 1) !=
          len.toString()) {
        isNeedToNotify = true;
      }
    } else {
      if (portfolioTabs[1]
              .split(" ")[1]
              .substring(1, portfolioTabs[1].split(" ")[1].length - 1) !=
          len.toString()) {
        isNeedToNotify = true;
      }
    }
    if (isNeedToNotify) {
      portfolioTabs[isHoldUpdate ? 0 : 1] =
          portfolioTabs[isHoldUpdate ? 0 : 1].split(" ")[0] + " ($len)";
      notifyListeners();
    }
  }

  void changeTabBarIndexPortfolio({
    required int value,
    required BuildContext context,
  }) {
    log("PORTFOLIO TAB CHANGE :::$tabBarIndex");
    log("PORTFOLIO WATCH TAB CHANGE :::$value   ${pref.portfolioTabIndex}");
    clearHoldingsFilter();
    clearPositionsFilter();
    if (pref.portfolioTabIndex != value) {
      // requestWSPort(
      //   isSubscribe: false,
      //   context: context,
      // );
      pref.setPortfolioTabIndex(value);
      tabBarIndex = value;

      tabChangeServiceCall(context: context);

      // requestWSPort(
      //   isSubscribe: true,
      //   context: context,
      // );
      log("ORDER INDEX ::: $tabBarIndex");
    }
    notifyListeners();
  }

  void tabChangeServiceCall({
    required BuildContext context,
  }) {
    if (pref.portfolioTabIndex == 0) {
      // fetchHoldings(context);
      // ref(holdingsProvider).fetchHoldings(
      //   context: context,
      // );
    } else if (pref.portfolioTabIndex == 1) {
      fetchPositions(context: context);
    }
  }

  /// Method to fetch User Positions
  ///
  ///
  ///

  Future<void> fetchPositions({
    required BuildContext context,
  }) async {
    try {
      if (!pref.isGuestUser) {
        clearPositionsFilter();
        if (isPositionInitialCall) {
          toggleLoadingOn(true);
          await ref.read(serviceSupportProvider).fetchPositions(
                context: context,
              );
          isPositionInitialCall = false;
        } else {
          ref.read(serviceSupportProvider).fetchPositions(
                context: context,
              );
        }
      }

      notifyListeners();
    } catch (e) {
      log("Failed to fetch positions ::: $e");
    } finally {
      toggleLoadingOn(false);
    }
  }

  void updatePosition({
    required PositionBookInfo? positionBookInfo,
    required List<PositionBookInfoResult> updatedPositionBook,
    required List<PositionBookInfoResult> updatedExitBook,
    required List<PositionBookInfoResult> updatedOrderedPositionBook,
    required double updatedtotalPnlPos,
    required double updatedMtomPos,
    required double updatedTotalRealisedPnl,
    required double updatedTotalUnRealisedPnl,
    required List<String> updatedExchangeFilterList,
    required List<String> updatedorderFilterList,
  }) {
    positionBookInfo = positionBookInfo;
    positions = updatedPositionBook;
    exitPositions = updatedExitBook;
    orderedPosition = updatedOrderedPositionBook;
    totalPnlPos = updatedtotalPnlPos;
    mtomPos = updatedMtomPos;
    totalRealisedPnl = updatedTotalRealisedPnl;
    totalUnRealisedPnl = updatedTotalUnRealisedPnl;
    exchangeFilterList = updatedExchangeFilterList;
    orderFilterList = updatedorderFilterList;
    updateHoldPosTab(isHoldUpdate: false, len: positions.length);
    requestWS(
      isSubscribe: true,
    );
    notifyListeners();
  }

  /// Positio search change
  ///
  ///
  ///

  void changeSearchPositions() {
    if (!isPosSearchEnable) {
      isPosSearchEnable = true;
    } else {
      filteredPositionSearchItems = [];
      isPosSearchEnable = false;
      searchController.text = "";
    }
    notifyListeners();
  }

  void searchFilter({required String searchContent}) {
    log(searchContent);
    filteredPositionSearchItems = [];
    if (pref.portfolioTabIndex == 1) {
      if (searchContent.isNotEmpty) {
        filteredPositionSearchItems = positions
            .where((element) => element.tradingsymbol!
                .toLowerCase()
                .startsWith(searchContent.toLowerCase()))
            .toList();
      } else {
        filteredPositionSearchItems = positions;
      }
    }
    notifyListeners();
  }

  /// Method to convert position
  ///
  ///
  ///

  Future<void> convertPositionQuantityValidation(
    BuildContext context,
    PositionBookInfoResult data,
  ) async {
    final String qtyControllerValue = convertPositionController.text.toString();
    final double minLot = double.parse(data.lotsize!);
    if (qtyControllerValue == "" || qtyControllerValue.isEmpty) {
      errorQuantity = qtyNull;
    } else if (qtyControllerValue == '0') {
      errorQuantity = qtyZero;
    } else if (double.parse(qtyControllerValue) % minLot != 0.0) {
      errorQuantity = 'Quantity should be multiple of ${minLot.ceil()}';
    } else if (double.parse(qtyControllerValue) >
        (double.parse(data.netQty!).isNegative
            ? double.parse(data.netQty!.substring(1))
            : double.parse(data.netQty!))) {
      errorQuantity = "Quantity should not greater then ${data.netQty}";
    } else {
      errorQuantity = "";
      PositionConvertInput input = PositionConvertInput(
        exchange: data.exchange!.toString(),
        prevProduct: data.product!.toString(),
        product: data.exchange == "NSE" || data.exchange == "BSE"
            ? data.product!.toUpperCase() == "CNC"
                ? "MIS".toString()
                : "CNC".toString()
            : data.product!.toUpperCase() == "NRML"
                ? "MIS".toString()
                : "NRML".toString(),
        qty: qtyControllerValue.isEmpty
            ? '0'.toString()
            : data.exchange!.toLowerCase() == "mcx"
                ? (double.parse(qtyControllerValue) *
                        double.parse(data.lotsize ?? '1'))
                    .toStringAsFixed(2)
                : qtyControllerValue,
        tradingSymbol: data.tradingsymbol!.toString(),
        tranType: double.parse(data.netQty!) > 0 ? "B" : "S",
      );
      await ref.read(serviceSupportProvider).positionConvert(
            context: context,
            input: input,
          );
    }
    notifyListeners();
  }

  Future<void> fetchHoldings({
    required BuildContext context,
  }) async {
    try {
      if (!pref.isGuestUser) {
        if (isHoldingsInitialServiceCall) {
          toggleLoadingOn(true);
          await ref.read(serviceSupportProvider).fetchHoldings(
                context: context,
              );
          isHoldingsInitialServiceCall = false;
        } else {
          ref.read(serviceSupportProvider).fetchHoldings(
                context: context,
              );
        }
      }
    } catch (e) {
      log("Failed to fetch holdings ::: $e");
    } finally {
      toggleLoadingOn(false);
    }
  }

  /// Method to update Holdings
  ///
  ///
  ///

  void updateHoldingsInfo({
    required List<Holding> updatedholdings,
    required bool authourizeStatus,
    required double updatedNetPnl,
    required double updatedDayPnl,
    required double updatedTotalInvest,
    required double updatedTotalCurrent,
    required double updatedTotalPrevClose,
    required double updatedNetPnlPerChange,
    required double updatedDayPnlPerChange,
    required bool revokeStatus,
  }) {
    holdings = updatedholdings;
    netPnl = updatedNetPnl;
    dayPnl = updatedDayPnl;
    totalInvest = updatedTotalInvest;
    totalCurrent = updatedTotalCurrent;
    totalPreClose = updatedTotalPrevClose;
    netPnlPerChange = updatedNetPnlPerChange;
    isAuthorizeShow = authourizeStatus;
    isRevokeShow = revokeStatus;
    dayPnlPerChange = updatedDayPnlPerChange;
    // ref(marketProvider).updateHoldingsDetails(holdVal: updatedholdings);
    isHoldingsInitialServiceCall = false;
    updateHoldPosTab(
      isHoldUpdate: true,
      len: holdings.length,
    );
    requestWS(
      isSubscribe: true,
    );
    toggleLoadingOn(false);
    notifyListeners();
  }

  /// Holdings Search change
  ///
  ///
  ///

  void changeSearchHoldings() {
    if (!isHoldingsSearchEnable) {
      isHoldingsSearchEnable = true;
    } else {
      holdingSearchItems = [];
      isHoldingsSearchEnable = false;
      searchController.text = "";
    }
    notifyListeners();
  }

  /// check filter
  ///
  ///
  ///

  bool validateFilterIsActive() {
    if (filteredHoldItems.isNotEmpty ||
        getIsDecending != 'default' ||
        getIsUpperPercen != 'default' ||
        getIsUpperPnl != 'default' ||
        getIsUpperPnlPercent != 'default' ||
        getIsUpperPrice != 'default' ||
        getIsExch != 'default') {
      return true;
    }

    return false;
  }

  // Position / Holdings filter Market watch

  void setActiveFilter(String activeFilterName) {
    if (activeFilter == 'default') {
      activeFilter = activeFilterName;
    } else if (activeFilter != activeFilterName) {
      setOtherFilterDefault(activeFilter);
      activeFilter = activeFilterName;
    }
    notifyListeners();
  }

  void setOtherFilterDefault(String setFilterDefault) {
    if (setFilterDefault == 'alphabets') {
      _isDecending = 'default';
    } else if (setFilterDefault == 'pnl') {
      _isUpperPnl = 'default';
    } else if (setFilterDefault == 'ltp') {
      _isUpperPrice = 'default';
    } else if (setFilterDefault == 'exchange') {
      _isExchange = 'default';
    } else if (setFilterDefault == 'perChange') {
      _isUpperPerchange = 'default';
    } else if (setFilterDefault == 'pnlPerChange') {
      _isUpperPnlPercent = 'default';
    }

    notifyListeners();
  }

  void setDefaultvalue(bool isFilter) {
    if (pref.portfolioTabIndex == 0) {
      if (!isFilter) {
        if (holdings.isNotEmpty && holdings.isNotEmpty) {
          holdings.sort(
            (a, b) => a.sno!.compareTo(b.sno!),
          );
        }
      } else {
        filteredHoldItems.sort(
          (a, b) => a.sno!.compareTo(b.sno!),
        );
      }
    }
    notifyListeners();
  }

  void sortLastTradePrice(bool isClear) {
    if (!isClear) {
      setActiveFilter('ltp');
      if (_isUpperPrice == 'default') {
        _isUpperPrice = 'up';
      } else if (_isUpperPrice == 'up') {
        _isUpperPrice = 'down';
      } else if (_isUpperPrice == 'down') {
        _isUpperPrice = 'default';
        setActiveFilter('default');
      }
    }
    if (_isUpperPrice == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.symbol![0].ltp!)
                  .compareTo(double.parse(item1.symbol![0].ltp!))
              : double.parse(item1.symbol![0].ltp!)
                  .compareTo(double.parse(item2.symbol![0].ltp!)));
        } else {
          holdings.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.symbol![0].ltp!)
                  .compareTo(double.parse(item1.symbol![0].ltp!))
              : double.parse(item1.symbol![0].ltp!)
                  .compareTo(double.parse(item2.symbol![0].ltp!)));
        }
      }
    }

    notifyListeners();
  }

  void sortLtpPerChange(bool isClear) {
    if (!isClear) {
      setActiveFilter('perChange');
      if (_isUpperPerchange == 'default') {
        _isUpperPerchange = 'up';
      } else if (_isUpperPerchange == 'up') {
        _isUpperPerchange = 'down';
      } else if (_isUpperPerchange == 'down') {
        _isUpperPerchange = 'default';
        setActiveFilter('default');
      }
    }
    if (_isUpperPerchange == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        _isUpperPerchange == 'default';
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isUpperPerchange == 'up'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          holdings.sort((item1, item2) => _isUpperPerchange == 'up'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      }
    }
    notifyListeners();
  }

  void sortAlphabets(bool isClear) {
    if (!isClear) {
      setActiveFilter('alphabets');
      if (_isDecending == 'default') {
        _isDecending = 'up';
      } else if (_isDecending == 'up') {
        _isDecending = 'down';
      } else if (_isDecending == 'down') {
        _isDecending = 'default';
        setActiveFilter('default');
      }
    }
    if (_isDecending == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.symbol![0].tradingSymbol!
                  .compareTo(item1.symbol![0].tradingSymbol!)
              : item1.symbol![0].tradingSymbol!
                  .compareTo(item2.symbol![0].tradingSymbol!));
        } else {
          holdings.sort((item1, item2) => _isDecending == 'down'
              ? item2.symbol![0].tradingSymbol!
                  .compareTo(item1.symbol![0].tradingSymbol!)
              : item1.symbol![0].tradingSymbol!
                  .compareTo(item2.symbol![0].tradingSymbol!));
        }
      }
    }
    notifyListeners();
  }

  void sortExchange(bool isClear) {
    if (!isClear) {
      setActiveFilter('exchange');
      if (_isExchange == 'default') {
        _isExchange = 'up';
      } else if (_isExchange == 'up') {
        _isExchange = 'down';
      } else if (_isExchange == 'down') {
        _isExchange = 'default';
        setActiveFilter('default');
      }
    }
    if (_isExchange == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isExchange == 'down'
              ? item2.symbol![0].exchange!.compareTo(item1.symbol![0].exchange!)
              : item2.symbol![0].exchange!
                  .compareTo(item2.symbol![0].exchange!));
        } else {
          holdings.sort((item1, item2) => _isExchange == 'down'
              ? item2.symbol![0].exchange!.compareTo(item2.symbol![0].exchange!)
              : item2.symbol![0].exchange!
                  .compareTo(item2.symbol![0].exchange!));
        }
      }
    }
    notifyListeners();
  }

  void sortProfitAndLossPercentage(bool isClear) {
    if (!isClear) {
      setActiveFilter('pnlPerChange');
      if (_isUpperPnlPercent == 'default') {
        _isUpperPnlPercent = 'up';
      } else if (_isUpperPnlPercent == 'up') {
        _isUpperPnlPercent = 'down';
      } else if (_isUpperPnlPercent == 'down') {
        _isUpperPnlPercent = 'default';
        setActiveFilter('default');
      }
    }
    if (_isUpperPnlPercent == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        _isUpperPnlPercent == 'default';
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isUpperPnlPercent == 'up'
              ? double.parse(item2.netPnlPerChange!)
                  .compareTo(double.parse(item1.netPnlPerChange!))
              : double.parse(item1.netPnlPerChange!)
                  .compareTo(double.parse(item2.netPnlPerChange!)));
        } else {
          holdings.sort((item1, item2) => _isUpperPnlPercent == 'up'
              ? double.parse(item2.netPnlPerChange!)
                  .compareTo(double.parse(item1.netPnlPerChange!))
              : double.parse(item1.netPnlPerChange!)
                  .compareTo(double.parse(item2.netPnlPerChange!)));
        }
      }
    }
    notifyListeners();
  }

  void sortProfitAndLoss(bool isClear) {
    if (!isClear) {
      setActiveFilter('pnl');
      if (_isUpperPnl == 'default') {
        _isUpperPnl = 'up';
      } else if (_isUpperPnl == 'up') {
        _isUpperPnl = 'down';
      } else if (_isUpperPnl == 'down') {
        _isUpperPnl = 'default';
        setActiveFilter('default');
      }
    }
    if (_isUpperPnl == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        _isUpperPnl == 'default';
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isUpperPnl == 'up'
              ? double.parse(item2.netPnl!)
                  .compareTo(double.parse(item1.netPnl!))
              : double.parse(item1.netPnl!)
                  .compareTo(double.parse(item2.netPnl!)));
        } else {
          filteredHoldItems = holdings;
          filteredHoldItems.sort((item1, item2) => _isUpperPnl == 'up'
              ? double.parse(item2.netPnl.toString())
                  .compareTo(double.parse(item1.netPnl!))
              : double.parse(item1.netPnl!)
                  .compareTo(double.parse(item2.netPnl!)));
        }
      }
    }

    notifyListeners();
  }

  void sortInvestedAmount(bool isClear) {
    if (!isClear) {
      setActiveFilter('invest');
      if (_isUpperInvest == 'default') {
        _isUpperInvest = 'up';
      } else if (_isUpperInvest == 'up') {
        _isUpperInvest = 'down';
      } else if (_isUpperInvest == 'down') {
        _isUpperInvest = 'default';
        setActiveFilter('default');
      }
    }
    if (_isUpperInvest == 'default') {
      setDefaultvalue(filteredHoldItems.isNotEmpty);
    } else {
      if (pref.portfolioTabIndex == 0) {
        _isUpperInvest == 'default';
        if (filteredHoldItems.isNotEmpty) {
          filteredHoldItems.sort((item1, item2) => _isUpperInvest == 'up'
              ? double.parse(item2.invest!)
                  .compareTo(double.parse(item1.invest!))
              : double.parse(item1.invest!)
                  .compareTo(double.parse(item2.invest!)));
        } else {
          filteredHoldItems = holdings;
          filteredHoldItems.sort((item1, item2) => _isUpperInvest == 'up'
              ? double.parse(item2.invest.toString())
                  .compareTo(double.parse(item1.invest!))
              : double.parse(item1.invest!)
                  .compareTo(double.parse(item2.invest!)));
        }
      }
    }

    notifyListeners();
  }

  void addRemoveFilter({required String selectedValue}) {
    filteredHoldItems = [];
    if (pref.portfolioTabIndex == 0) {
      if (filterItemsListHold.contains(selectedValue)) {
        filterItemsListHold.remove(selectedValue);
      } else {
        filterItemsListHold.add(selectedValue);
      }

      for (var wsitem in holdings) {
        for (final item in filterItemsListHold) {
          if (filterItemsListHoldIndex.isNotEmpty) {
            for (var indexitem in filterItemsListHoldIndex) {
              if (wsitem.symbol!.length > 1
                  ? wsitem.symbol![0].exchange! == "NSE"
                      ? wsitem.symbol![0].exchange!.toLowerCase() ==
                              item.toLowerCase() &&
                          wsitem.symbol![0].exchange!.toLowerCase() !=
                              indexitem.toLowerCase()
                      : wsitem.symbol![1].exchange!.toLowerCase() ==
                              item.toLowerCase() &&
                          wsitem.symbol![1].exchange!.toLowerCase() !=
                              indexitem.toLowerCase()
                  : wsitem.symbol![0].exchange!.toLowerCase() ==
                          item.toLowerCase() &&
                      wsitem.symbol![0].exchange!.toLowerCase() !=
                          indexitem.toLowerCase()) {
                filteredHoldItems.add(wsitem);
              }
            }
          } else {
            if (wsitem.symbol!.length > 1
                ? wsitem.symbol![0].exchange! == "NSE"
                    ? wsitem.symbol![0].exchange!.toLowerCase() ==
                        item.toLowerCase()
                    : wsitem.symbol![1].exchange!.toLowerCase() ==
                        item.toLowerCase()
                : wsitem.symbol![0].exchange!.toLowerCase() ==
                    item.toLowerCase()) {
              filteredHoldItems.add(wsitem);
            }
          }
        }
      }

      if (filteredHoldItems.isEmpty) {
        filteredHoldItems = holdings;
      }
    }
    notifyListeners();
  }

  /// Method to check if the token is present or not
  ///
  ///
  ///

  bool checkToken({
    required String value,
  }) {
    if (pref.portfolioTabIndex == 0) {
      return holdings.any((element) => element.symbol![0].token == value);
    } else if (pref.portfolioTabIndex == 1) {
      return positions.any((element) => element.token == value);
    }
    return true;
  }

  /// Method to subscribe / unsubscribe
  ///
  ///

  void requestWS({
    required bool isSubscribe,
  }) {
    try {
      String input = "";

      // Holdings Subscribe / unSubscribe

      if (pref.portfolioTabIndex == 0) {}

      // Position Subscibe / unsubscribe

      if (pref.portfolioTabIndex == 1) {
        for (var element in positions) {
          input += "${element.exchange}|${element.token}#";
        }
      }

      if (input.isNotEmpty) {
        ref.read(websocketProvider).establishConnection(
              channelInput: input.substring(0, input.length - 1),
              task: isSubscribe ? "t" : "u",
            );
      }
    } catch (e) {
      log("Failed to subscibe / unSubscribe WS ::: $e");
    }
  }
}
