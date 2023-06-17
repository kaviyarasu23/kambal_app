// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer';
import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/holding_book_model.dart';
import '../model/market_watch_list_model.dart';
import '../shared_widget/snack_bar.dart';
import 'core/default_change_notifier.dart';
import 'market_helper_provider.dart';
import 'settings_provider.dart';
import 'tab_controller_provider.dart';
import 'websocket_provider.dart';

final marketProvider = ChangeNotifierProvider((ref) => MarketProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class MarketProvider extends DefaultChangeNotifier {
  MarketProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  List<String> tabs = [];
  List<String> dummyTabs = ['LIST1', 'LIST2', 'LIST3', 'LIST4', 'LIST5'];

  GetMwResponse? _fetchWatchlistResponse;
  GetMwResponse? get getWatchList => _fetchWatchlistResponse;

  List<Scrip>? _list1;
  List<Scrip>? _list2;
  List<Scrip>? _list3;
  List<Scrip>? _list4;
  List<Scrip>? _list5;
  List<Scrip>? _list6;
  List<Scrip>? _list7;
  List<Scrip>? _list8;

  List<Scrip>? get getMWScrip1 => _list1;
  List<Scrip>? get getMWScrip2 => _list2;
  List<Scrip>? get getMWScrip3 => _list3;
  List<Scrip>? get getMWScrip4 => _list4;
  List<Scrip>? get getMWScrip5 => _list5;
  List<Scrip>? get getMWScrip6 => _list6;
  List<Scrip>? get getMWScrip7 => _list7;
  List<Scrip>? get getMWScrip8 => _list8;

  // Filter

  FilterOption? filterOption;

  List<String> exchangeList = [];
  List<String> get getExchangeList => exchangeList;

  List<String> filterItemsList = [];
  List<String> filterItemsListIndex = [];
  List<Scrip> filteredItems = [];
  String _isDecending = 'default';
  String get getIsDecending => _isDecending;
  String _isUpperPrice = 'default';
  String get getIsUpperPrice => _isUpperPrice;
  String _isUpperPerchange = 'default';
  String get getIsUpperPercen => _isUpperPerchange;
  String _isExchange = 'default';
  String get getIsExch => _isExchange;
  String activeFilter = 'default';
  String get activeFilterSelected => activeFilter;

  // Tab Index

  int tabBarIndex = 0;
  int get getTabIndex => tabBarIndex;

  List<CustomizeWatchlistModel> dummyWatchlistScripShowModel =
      dummyWatchlistScripModel;

  // Reorder

  bool isMwListOrderChange = false;
  final TextEditingController watchlistRenameController =
      TextEditingController();
  String oldMwName = "";

  // filter

  bool isListWSView = false;
  bool get isWSListView => isListWSView;

  // Search

  List<String> clickedIndexSearch = [];
  List<String> get getClickedIndexSearch => clickedIndexSearch;

  // sybol add preference choice

  bool isAddTop = true;
  bool get isScripAddTop => isAddTop;

  int wsCardType = 0;

  bool isDefaultTabNiftyEnable = false;
  bool isDefaultTabBankNiftyEnable = false;
  bool isDefaultTabSensexEnable = false;

  /// Method change Tab bar
  ///
  ///
  ///

  void changeTabBarIndex({
    required int value,
    required BuildContext context,
  }) {
    log("MARKET WATCH TAB CHANGE :::$tabBarIndex");
    log("MARKET WATCH TAB CHANGE :::$value   ${pref.wlTabIndex}");
    clearFilter();

    if (pref.wlTabIndex != value) {
      requestWS(
        isSubscribe: false,
        context: context,
      );
      pref.setWLTabIndex(value);
      tabBarIndex = value;
      requestWS(
        isSubscribe: true,
        context: context,
      );
      log("WL INDEX ::: $tabBarIndex");
    }
    notifyListeners();
  }

  /// Method to getting all MW scrips
  ///
  ///
  ///

  Future<void> getUserWatchlist({
    int? tabIndex,
    required BuildContext context,
    bool forceUpdate = false,
    bool isMwNameUpdate = false,
  }) async {
    try {
      if (tabIndex == null) {
        toggleLoadingOn(true);
      }
      final getScripsInput input = getScripsInput(
        userId: pref.userId!,
        predefined: "true",
      );
      final GetMwResponse? data = await api.getWatchList(
        context: context,
        userId: input,
        ref: ref,
      );
      if (data != null) {
        if (!data.stat) {
          if (data.result == null || data.result!.isEmpty) {
            final stat =
                await ref.read(marketHelperProvider).createMw(context: context);
            if (stat) {
              await getUserWatchlist(
                context: context,
                forceUpdate: true,
                tabIndex: tabIndex,
              );
            } else {}
          }
        } else {
          if (data.result!.length >
                  (_fetchWatchlistResponse == null
                      ? 0
                      : _fetchWatchlistResponse!.result!.length) ||
              forceUpdate) {
            _fetchWatchlistResponse = data;

            if (tabs.isEmpty || isMwNameUpdate || forceUpdate) {
              tabs = [];
              int count = 0;
              for (var item in _fetchWatchlistResponse!.result!) {
                tabs.add("$count:${item.mwName}");
              }
              log("TAB NAMES ::: ${tabs}");
            }
          }
          addScripValSet(context: context);
        }
      }
    } catch (e) {
      log("FailedWS:: ${e.toString()}");
    } finally {
      if (tabIndex == null) {
        try {
          toggleLoadingOn(false);
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }

  /// Method to add all scrip indivdual in getting all MW scrips
  ///
  ///
  void addScripValSet({required BuildContext context}) {
    if (_fetchWatchlistResponse != null) {
      for (var i = 0; i < _fetchWatchlistResponse!.result!.length; i++) {
        switch (i) {
          case 0:
            _list1 = _fetchWatchlistResponse!.result![i].scrips;
            // addSortOrderScripValSet(context: context);
            break;
          case 1:
            _list2 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 2:
            _list3 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 3:
            _list4 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 4:
            _list5 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 5:
            _list6 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 6:
            _list7 = _fetchWatchlistResponse!.result![i].scrips;
            break;
          case 7:
            _list8 = _fetchWatchlistResponse!.result![i].scrips;
            break;
        }
        updateHoldWL(tabWLIndex: i);
      }
    }
  }

  /// Method to get scrip indivdual
  ///
  ///
  Future<void> getScrip({
    required int tabIndex,
    required BuildContext context,
  }) async {
    switch (tabIndex) {
      case 0:
        _fetchWatchlistResponse != null
            ? _list1 = await api.getScrips(
                _fetchWatchlistResponse!.result![tabIndex].mwId!,
                context,
                ref,
                _fetchWatchlistResponse!.result![tabIndex].mwName!,
              )
            : null;
        notifyListeners();
        break;
      case 1:
        _list2 = await api.getScrips(
          _fetchWatchlistResponse!.result![tabIndex].mwId!,
          context,
          ref,
          _fetchWatchlistResponse!.result![tabIndex].mwName!,
        );
        notifyListeners();
        // print("2::  ${_list2?.values.map((e) => e.token).toList()}");
        break;
      case 2:
        _list3 = await api.getScrips(
          _fetchWatchlistResponse!.result![tabIndex].mwId!,
          context,
          ref,
          _fetchWatchlistResponse!.result![tabIndex].mwName!,
        );
        notifyListeners();
        break;
      case 3:
        _list4 = await api.getScrips(
          _fetchWatchlistResponse!.result![tabIndex].mwId!,
          context,
          ref,
          _fetchWatchlistResponse!.result![tabIndex].mwName!,
        );
        notifyListeners();

        break;
      case 4:
        _list5 = await api.getScrips(
          _fetchWatchlistResponse!.result![tabIndex].mwId!,
          context,
          ref,
          _fetchWatchlistResponse!.result![tabIndex].mwName!,
        );
        notifyListeners();

        break;
    }
    updateHoldWL(tabWLIndex: tabIndex);
    notifyListeners();
    requestWS(isSubscribe: true, context: context);
  }

  /// Method to update holdings qty in MW add
  ///
  ///
  ///

  void updateHoldWL({required int tabWLIndex}) {
    List<Holding> holdVal = ref.read(portfolioProvider).holdings;
    switch (tabWLIndex) {
      case 0:
        for (var holdelement in holdVal) {
          if (_list1 != null) {
            if (_list1!.any((element) => ((holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token)))) {
              int holdIndex = _list1!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list1![holdIndex].isHoldScrip = true;
              _list1![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list1!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list1!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list1![holdIndex].isHoldScrip = true;
              _list1![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 1:
        for (var holdelement in holdVal) {
          if (_list2 != null) {
            if (_list2!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list2!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list2![holdIndex].isHoldScrip = true;
              _list2![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list2!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list2!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list2![holdIndex].isHoldScrip = true;
              _list2![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 2:
        for (var holdelement in holdVal) {
          if (_list3 != null) {
            if (_list3!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list3!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list3![holdIndex].isHoldScrip = true;
              _list3![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list3!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list3!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list3![holdIndex].isHoldScrip = true;
              _list3![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 3:
        for (var holdelement in holdVal) {
          if (_list4 != null) {
            if (_list4!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list4!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list4![holdIndex].isHoldScrip = true;
              _list4![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list4!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list4!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list4![holdIndex].isHoldScrip = true;
              _list4![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 4:
        for (var holdelement in holdVal) {
          if (_list5 != null) {
            if (_list5!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list5!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list5![holdIndex].isHoldScrip = true;
              _list5![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list5!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list5!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list5![holdIndex].isHoldScrip = true;
              _list5![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 5:
        for (var holdelement in holdVal) {
          if (_list6 != null) {
            if (_list6!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list6!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list6![holdIndex].isHoldScrip = true;
              _list6![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list6!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list6!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list6![holdIndex].isHoldScrip = true;
              _list6![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 6:
        for (var holdelement in holdVal) {
          if (_list7 != null) {
            if (_list7!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list7!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list7![holdIndex].isHoldScrip = true;
              _list7![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list7!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list7!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list7![holdIndex].isHoldScrip = true;
              _list7![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
      case 7:
        for (var holdelement in holdVal) {
          if (_list8 != null) {
            if (_list8!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![0].token))) {
              int holdIndex = _list8!.indexWhere(
                  (element) => element.token == holdelement.symbol![0].token);
              _list8![holdIndex].isHoldScrip = true;
              _list8![holdIndex].holdQty = holdelement.netQty;
            }
            if (_list8!.any((element) => (holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                holdelement.symbol!.length > 1 &&
                holdelement.symbol != null &&
                holdelement.symbol!.isNotEmpty &&
                element.token == holdelement.symbol![1].token))) {
              int holdIndex = _list8!.indexWhere(
                  (element) => element.token == holdelement.symbol![1].token);
              _list8![holdIndex].isHoldScrip = true;
              _list8![holdIndex].holdQty = holdelement.netQty;
            }
          }
        }
        break;
    }
    notifyListeners();
  }

  /// Method to check if the list is changed
  ///
  /// return [bool]
  ///

  bool isListOrdered() {
    bool isReordered = false;
    if (tabBarIndex == 0) {
      log("LIST 1 LEN :: ${getMWScrip1!.length}");
      for (int i = 0; i < getMWScrip1!.length; i++) {
        log("SNO OF MARKETWATCH  ${getMWScrip1![i].sno.toString()}");
        if (getMWScrip1![i].sno != i) {
          return true;
        }
      }
    } else if (tabBarIndex == 1) {
      log("LIST 2 LEN :: ${getMWScrip2!.length}");
      for (int i = 0; i < getMWScrip2!.length; i++) {
        if (getMWScrip2![i].sno != i) {
          return true;
        }
      }
    } else if (tabBarIndex == 2) {
      log("LIST 3 LEN :: ${getMWScrip3!.length}");
      for (int i = 0; i < getMWScrip3!.length; i++) {
        if (getMWScrip3![i].sno != i) {
          return true;
        }
      }
    } else if (tabBarIndex == 3) {
      log("LIST 4 LEN :: ${getMWScrip4!.length}");
      for (int i = 0; i < getMWScrip4!.length; i++) {
        if (getMWScrip4![i].sno != i) {
          return true;
        }
      }
    } else if (tabBarIndex == 4) {
      log("LIST 5 LEN :: ${getMWScrip5!.length}");
      for (int i = 0; i < getMWScrip5!.length; i++) {
        if (getMWScrip5![i].sno != i) {
          return true;
        }
      }
    }

    return isReordered;
  }

  /// Method to check change the list Order
  ///
  ///
  ///

  void reOrderList(
      {required int oldIndex, required int newIndex, required int tabIndex}) {
    final int oldI = oldIndex;
    int newI = newIndex;
    if (newI > oldI) {
      newI -= 1;
    }
    switch (tabIndex) {
      case 0:
        final element = _list1!.removeAt(oldI);
        _list1!.insert(newI, element);
        break;
      case 1:
        final element = _list2!.removeAt(oldI);
        _list2!.insert(newI, element);
        break;
      case 2:
        final element = _list3!.removeAt(oldI);
        _list3!.insert(newI, element);
        break;
      case 3:
        final element = _list4!.removeAt(oldI);
        _list4!.insert(newI, element);
        break;
      case 4:
        final element = _list5!.removeAt(oldI);
        _list5!.insert(newI, element);
        break;

      default:
        break;
    }
    bool isChnaged = isListOrdered();
    log("ISCHANGED ::: $isChnaged");
    if (isChnaged) {
      isMwListOrderChange = true;
    } else {
      isMwListOrderChange = false;
    }

    notifyListeners();
  }

  /// clear filter changes
  ///
  ///
  ///

  void clearFilter() {
    filterItemsListIndex = [];
    filteredItems = [];
    filterItemsList = [];
    activeFilter = 'default';
    _isDecending = 'default';
    _isUpperPrice = 'default';
    _isUpperPerchange = 'default';
    _isExchange = 'default';
    setDefaultValue(filteredItems.isNotEmpty);
  }

  void setDefaultValue(bool isFilter) {
    if (pref.wlTabIndex == 0) {
      if (!isFilter) {
        getMWScrip1?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 1) {
      if (!isFilter) {
        getMWScrip2?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 2) {
      if (!isFilter) {
        getMWScrip3?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 3) {
      if (!isFilter) {
        getMWScrip4?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 4) {
      if (!isFilter) {
        getMWScrip5?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 5) {
      if (!isFilter) {
        getMWScrip6?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 6) {
      if (!isFilter) {
        getMWScrip7?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    } else if (pref.wlTabIndex == 7) {
      if (!isFilter) {
        getMWScrip8?.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
      }
    }
    if (isFilter) {
      filteredItems.sort((item1, item2) => item1.sno!.compareTo(item2.sno!));
    }
    notifyListeners();
  }

  void changeView({required bool tilesChoice}) {
    isListWSView = tilesChoice;
    notifyListeners();
  }

  bool checkIsFilterItemSelected({required String item}) {
    if (filterItemsList.contains(item)) {
      return true;
    }
    return false;
  }

  /// Method to add and remove filters
  ///
  ///
  void addRemoveFilterPosition({required String selectedValue}) {
    filteredItems = [];

    if (selectedValue.toLowerCase() == 'index' ||
        selectedValue.toLowerCase() == 'holdings') {
      if (filterItemsListIndex.contains(selectedValue.toUpperCase())) {
        filterItemsListIndex.remove(selectedValue.toUpperCase());
      } else {
        filterItemsListIndex.add(selectedValue.toUpperCase());
      }
      if (filterItemsList.contains(selectedValue)) {
        filterItemsList.remove(selectedValue);
      } else {
        filterItemsList.add(selectedValue);
      }
    } else {
      if (filterItemsList.contains(selectedValue)) {
        filterItemsList.remove(selectedValue);
      } else {
        filterItemsList.add(selectedValue);
      }
    }
    notifyListeners();
  }

  /// Method to add scrip in Top / Bottom
  ///
  ///
  void changeAddPreference({required bool choice}) {
    isAddTop = choice;
    pref.setScripAddTopChoice(isAddTop);
    ref.read(settingsProvider).checkIfPreferenceChanged(
          context: ref.read(tabControllProvider).context!,
          tagName: 'mwt',
        );
    notifyListeners();
  }

  /// Method to set Active filter
  ///
  ///
  ///

  void setActiveFilter(String activeFilterName) {
    if (activeFilter == '') {
      activeFilter = activeFilterName;
    } else if (activeFilter != activeFilterName) {
      setOtherFilterDefault(activeFilter);
      activeFilter = activeFilterName;
    }
    notifyListeners();
  }

  /// Method to set other active status default
  ///
  ///
  ///

  void setOtherFilterDefault(String setFilterDefault) {
    if (setFilterDefault == 'alphabets') {
      _isDecending = 'default';
    } else if (setFilterDefault == 'ltp') {
      _isUpperPrice = 'default';
    } else if (setFilterDefault == 'perChange') {
      _isUpperPerchange = 'default';
    } else if (setFilterDefault == 'exchange') {
      _isExchange = 'default';
    }
    notifyListeners();
  }

  /// Method to change alphabets
  ///
  ///
  ///

  void sortAlphabets(bool isClear) {
    if (!isClear) {
      setActiveFilter('alphabets');
      if (_isDecending == 'default') {
        _isDecending = 'up';
      } else if (_isDecending == 'up') {
        _isDecending = 'down';
      } else if (_isDecending == 'down') {
        _isDecending = 'default';
      }
    }
    notifyListeners();
  }

  /// Method to change LTP
  ///
  ///
  ///

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
    notifyListeners();
  }

  /// Method to change LTP PerChange
  ///
  ///
  ///

  void sortPercentageChange(bool isClear) {
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
    notifyListeners();
  }

  /// Method to Apply filter changes
  ///
  ///
  ///

  // Alphabets Filter

  void applyAlphabetsFilter() {
    if (_isDecending == 'default') {
      setDefaultValue(filteredItems.isNotEmpty);
    } else {
      if (pref.wlTabIndex == 0) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        } else {
          getMWScrip1!.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        }
      } else if (pref.wlTabIndex == 1) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        } else {
          getMWScrip2!.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        }
      } else if (pref.wlTabIndex == 2) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        } else {
          getMWScrip3!.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        }
      } else if (pref.wlTabIndex == 3) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        } else {
          getMWScrip4!.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        }
      } else if (pref.wlTabIndex == 4) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        } else {
          getMWScrip5!.sort((item1, item2) => _isDecending == 'down'
              ? item2.formattedInsName.compareTo(item1.formattedInsName)
              : item1.formattedInsName.compareTo(item2.formattedInsName));
        }
      }
    }
    notifyListeners();
  }

  // apply for ltp

  void applyLastTradePrice() {
    if (_isUpperPrice == 'default') {
      setDefaultValue(filteredItems.isNotEmpty);
    } else {
      if (pref.wlTabIndex == 0) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        } else {
          getMWScrip1!.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        }
      } else if (pref.wlTabIndex == 1) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        } else {
          getMWScrip2!.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        }
      } else if (pref.wlTabIndex == 2) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        } else {
          getMWScrip3!.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        }
      } else if (pref.wlTabIndex == 3) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        } else {
          getMWScrip4!.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        }
      } else if (pref.wlTabIndex == 4) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        } else {
          getMWScrip5!.sort((item1, item2) => _isUpperPrice == 'down'
              ? double.parse(item2.ltp!).compareTo(double.parse(item1.ltp!))
              : double.parse(item1.ltp!).compareTo(double.parse(item2.ltp!)));
        }
      }
    }
    notifyListeners();
  }

  // Apply for LTP Perchange

  void applyPerChange() {
    if (_isUpperPerchange == 'default') {
      setDefaultValue(filteredItems.isNotEmpty);
    } else {
      if (pref.wlTabIndex == 0) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          getMWScrip1!.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      } else if (pref.wlTabIndex == 1) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          getMWScrip2!.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      } else if (pref.wlTabIndex == 2) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          getMWScrip3!.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      } else if (pref.wlTabIndex == 3) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          getMWScrip4!.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      } else if (pref.wlTabIndex == 4) {
        if (filteredItems.isNotEmpty) {
          filteredItems.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        } else {
          getMWScrip5!.sort((item1, item2) => _isUpperPerchange == 'down'
              ? double.parse(item2.perChange!)
                  .compareTo(double.parse(item1.perChange!))
              : double.parse(item1.perChange!)
                  .compareTo(double.parse(item2.perChange!)));
        }
      }
    }

    notifyListeners();
  }

  void marketWatchName() {
    watchlistRenameController.text =
        getWatchList!.result![pref.wlTabIndex].mwName!;
    log("tab index of the mwname${getWatchList!.result![pref.wlTabIndex].mwName!}");
    oldMwName = getWatchList!.result![pref.wlTabIndex].mwName!;

    notifyListeners();
  }

  /// Discard changes
  ///
  ///
  ///

  void deletedListAdded() {
    String token = '';
    for (var element in ref.read(marketHelperProvider).deletedListItems) {
      if (pref.wlTabIndex == 0) {
        _list1!.add(element);
      }
      if (pref.wlTabIndex == 1) {
        _list2!.add(element);
      }
      if (pref.wlTabIndex == 2) {
        _list3!.add(element);
      }
      if (pref.wlTabIndex == 3) {
        _list4!.add(element);
      }
      if (pref.wlTabIndex == 4) {
        _list5!.add(element);
      }
      log("DELETE ADDED LIST TO ::: ${token}");
    }
    setDefaultDeletedScrip();
  }

  Future<bool> sortMwListOrder({
    required BuildContext context,
  }) async {
    bool res = false;
    try {
      toggleLoadingOn(true);
      List<ScripData> scripDataInput = [];
      int count = 0;
      List<Scrip> listScrip = [];
      int tanIndexMW = ref.read(marketProvider).getTabIndex;
      MarketProvider refMW = ref.read(marketProvider);
      listScrip = tanIndexMW == 0
          ? refMW.getMWScrip1!
          : tanIndexMW == 1
              ? refMW.getMWScrip2!
              : tanIndexMW == 2
                  ? refMW.getMWScrip3!
                  : tanIndexMW == 3
                      ? refMW.getMWScrip4!
                      : refMW.getMWScrip5!;
      for (var element in listScrip) {
        scripDataInput.add(ScripData(
            exch: element.ex, sortingOrder: count, token: element.token));
        count += 1;
      }
      SortMWListOrder input = SortMWListOrder(
        mwId: ref
            .read(marketProvider)
            .getWatchList!
            .result![ref.read(marketProvider).getTabIndex]
            .mwId!,
        userId: pref.userId!,
        scripData: scripDataInput,
      );
      final data = await api.sortMwListOrder(
        input: input,
        context: context,
        ref: ref,
      );
      if (data.isNotEmpty) {
        if (data == 'success') {
          await getScrip(
            tabIndex: getTabIndex,
            context: context,
          );
          res = true;
          return res;
        } else if (data == 'failed') {
          res = false;
          return res;
        }
      }
      return res;
    } catch (e) {
      log("$e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
    notifyListeners();
    return res;
  }

  void setDefaultDeletedScrip() {
    if (tabBarIndex == 0) {
      getMWScrip1!.sort(
          (item1, item2) => item1.sortingOrder.compareTo(item2.sortingOrder));
      for (var element in getMWScrip1!) {
        element.sno = element.sortingOrder;
      }
    } else if (tabBarIndex == 1) {
      getMWScrip2!.sort(
          (item1, item2) => item1.sortingOrder.compareTo(item2.sortingOrder));
      for (var element in getMWScrip2!) {
        element.sno = element.sortingOrder;
      }
    } else if (tabBarIndex == 2) {
      getMWScrip3!.sort(
          (item1, item2) => item1.sortingOrder.compareTo(item2.sortingOrder));
      for (var element in getMWScrip3!) {
        element.sno = element.sortingOrder;
      }
    } else if (tabBarIndex == 3) {
      getMWScrip4!.sort(
          (item1, item2) => item1.sortingOrder.compareTo(item2.sortingOrder));
      for (var element in getMWScrip4!) {
        element.sno = element.sortingOrder;
      }
    } else if (tabBarIndex == 4) {
      getMWScrip5!.sort(
          (item1, item2) => item1.sortingOrder.compareTo(item2.sortingOrder));
      for (var element in getMWScrip5!) {
        element.sno = element.sortingOrder;
      }
    }
    notifyListeners();
  }

  /// Market Filter
  ///
  ///
  ///

  void initialFilterOption() {
    List<String> initialFilterItem = [];
    initialFilterItem.addAll(filterItemsList);
    initialFilterItem.addAll(filterItemsListIndex);
    filterOption = FilterOption(
      addSymbolPref: pref.isMWScripAddTop,
      banknifty: pref.marketWatchDefaultTab.contains("banknifty") ? "1" : "0",
      nifty: pref.marketWatchDefaultTab.contains("nifty") ? "1" : "0",
      sensex: pref.marketWatchDefaultTab.contains("sensex") ? "1" : "0",
      sort: "",
      watchlistFilter: initialFilterItem,
      watchlistTile: pref.isListView!,
      watchlistView: pref.wsCardType,
      alphabetState: _isDecending,
      ltpState: _isUpperPrice,
      perChangeState: _isUpperPerchange,
    );
    isListWSView = pref.isListView!;
    wsCardType = pref.wsCardType;
    isDefaultTabNiftyEnable = pref.marketWatchDefaultTab.contains("nifty");
    isDefaultTabBankNiftyEnable =
        pref.marketWatchDefaultTab.contains("banknifty");
    isDefaultTabSensexEnable = pref.marketWatchDefaultTab.contains("sensex");
    notifyListeners();
  }

  void changeCardType({
    required int selectedCardTypeVal,
  }) {
    wsCardType = selectedCardTypeVal;
    notifyListeners();
  }

  void setDefaultTabChange({
    required bool status,
    required String title,
    required Function(int val) updateTab,
  }) {
    if (title.toLowerCase() == "nifty") {
      isDefaultTabNiftyEnable = status;
    } else if (title.toLowerCase() == "banknifty") {
      isDefaultTabBankNiftyEnable = status;
    } else {
      isDefaultTabSensexEnable = status;
    }

    log("DEFAULT TAB LEN ::: ${pref.marketWatchDefaultTab.length}");

    notifyListeners();
  }

  void discardFilterChanges() {
    if (filterOption!.addSymbolPref != pref.isMWScripAddTop) {
      pref.setScripAddTopChoice(filterOption!.addSymbolPref!);
    } else if (filterOption!.banknifty !=
        (pref.marketWatchDefaultTab.contains("banknifty") ? "1" : "0")) {
      final defTab = pref.marketWatchDefaultTab;
      if (filterOption!.banknifty == "0") {
        if (defTab.contains("banknifty")) {
          defTab.remove("banknifty");
        }
        pref.setWatchListDefaultTab(defTab);
      } else {
        if (!defTab.contains("banknifty")) {
          defTab.add("banknifty");
        }
        pref.setWatchListDefaultTab(defTab);
      }
    } else if (filterOption!.nifty !=
        ((pref.marketWatchDefaultTab.contains("nifty") &&
                (!pref.marketWatchDefaultTab.contains("banknifty")))
            ? "1"
            : "0")) {
      final defTab = pref.marketWatchDefaultTab;
      if (filterOption!.banknifty == "0") {
        if (defTab.contains("nifty")) {
          defTab.remove("nifty");
        }
        pref.setWatchListDefaultTab(defTab);
      } else {
        if (!defTab.contains("nifty")) {
          defTab.add("nifty");
        }
        pref.setWatchListDefaultTab(defTab);
      }
    } else if (filterOption!.sensex !=
        (pref.marketWatchDefaultTab.contains("sensex") ? "1" : "0")) {
      final defTab = pref.marketWatchDefaultTab;
      if (filterOption!.banknifty == "0") {
        if (defTab.contains("sensex")) {
          defTab.remove("sensex");
        }
        pref.setWatchListDefaultTab(defTab);
      } else {
        if (!defTab.contains("sensex")) {
          defTab.add("sensex");
        }
        pref.setWatchListDefaultTab(defTab);
      }
    } else if (filterOption!.alphabetState != _isDecending ||
        filterOption!.ltpState != _isUpperPrice ||
        filterOption!.perChangeState != _isUpperPerchange) {
      _isDecending = filterOption!.alphabetState!;
      _isUpperPrice = filterOption!.ltpState!;
      _isUpperPerchange = filterOption!.perChangeState!;
      if (filterOption!.alphabetState != "default") {
        applyAlphabetsFilter();
      } else if (filterOption!.ltpState != "default") {
        applyLastTradePrice();
      } else if (filterOption!.perChangeState != "default") {
        applyPerChange();
      } else {
        setDefaultValue(false);
      }
    } else if (!isFilterNotEdited()) {
      List<String> filterInitial = filterOption!.watchlistFilter ?? [];
      List<String> tempListFilterItem = [];
      List<String> tempStatusFilterItem = [];
      for (var element in filterInitial) {
        if (element.toLowerCase() == "index" ||
            element.toLowerCase() == "holdings") {
          tempStatusFilterItem.add(element.toUpperCase());
        } else {
          tempListFilterItem.add(element.toUpperCase());
        }
      }
      filterItemsList = tempListFilterItem;
      filterItemsListIndex = tempStatusFilterItem;
      applyFilterCatagory();
    } else if (filterOption!.watchlistView != wsCardType) {
      pref.setIsAskBidEnable(wsCardTypeVal: filterOption!.watchlistView!);
    } else if (filterOption!.watchlistTile != isWSListView) {
      pref.setMWView(filterOption!.watchlistTile!);
    }
    notifyListeners();
  }

  Future<void> saveFilter({required Function(int val)? updateTab}) async {
    List<String> defaultTab = pref.marketWatchDefaultTab;
    bool isDefaultChanged = false;
    if (filterOption!.nifty != (isDefaultTabNiftyEnable ? "1" : "0")) {
      if (isDefaultTabNiftyEnable) {
        if (!(defaultTab.contains("nifty"))) {
          defaultTab.add("nifty");
          pref.setWatchListDefaultTab(defaultTab);
        }
      } else {
        if (defaultTab.contains("nifty")) {
          defaultTab.remove("nifty");
          pref.setWatchListDefaultTab(defaultTab);
          requestWS(
            isSubscribe: false,
            context: ref.read(tabControllProvider).context!,
          );
        }
      }
      ref.read(settingsProvider).checkIfPreferenceChanged(
            context: ref.read(tabControllProvider).context!,
            tagName: 'n50',
          );
      if (!isDefaultChanged) {
        isDefaultChanged = true;
      }
    } else if (filterOption!.banknifty !=
        (isDefaultTabBankNiftyEnable ? "1" : "0")) {
      if (isDefaultTabBankNiftyEnable) {
        if (!(defaultTab.contains("banknifty"))) {
          defaultTab.add("banknifty");
          pref.setWatchListDefaultTab(defaultTab);
        }
      } else {
        if (defaultTab.contains("banknifty")) {
          defaultTab.remove("banknifty");
          pref.setWatchListDefaultTab(defaultTab);
          requestWS(
            isSubscribe: false,
            context: ref.read(tabControllProvider).context!,
          );
        }
      }
      if (!isDefaultChanged) {
        isDefaultChanged = true;
      }
      ref.read(settingsProvider).checkIfPreferenceChanged(
            context: ref.read(tabControllProvider).context!,
            tagName: 'bnf',
          );
    } else if (filterOption!.sensex != (isDefaultTabSensexEnable ? "1" : "0")) {
      if (isDefaultTabSensexEnable) {
        if (!(defaultTab.contains("sensex"))) {
          defaultTab.add("sensex");
          pref.setWatchListDefaultTab(defaultTab);
        }
      } else {
        if (defaultTab.contains("sensex")) {
          defaultTab.remove("sensex");
          pref.setWatchListDefaultTab(defaultTab);
          requestWS(
            isSubscribe: false,
            context: ref.read(tabControllProvider).context!,
          );
        }
      }
      if (!isDefaultChanged) {
        isDefaultChanged = true;
      }
      ref.read(settingsProvider).checkIfPreferenceChanged(
            context: ref.read(tabControllProvider).context!,
            tagName: 'snx',
          );
    } else if (filterOption!.alphabetState != _isDecending ||
        filterOption!.ltpState != _isUpperPrice ||
        filterOption!.perChangeState != _isUpperPerchange) {
      applyFilter();
    } else if (!isFilterNotEdited()) {
      applyFilterCatagory();
    } else if (filterOption!.watchlistView != wsCardType) {
      pref.setIsAskBidEnable(wsCardTypeVal: wsCardType);
      ref.read(settingsProvider).checkIfPreferenceChanged(
            context: ref.read(tabControllProvider).context!,
            tagName: 'sdp',
          );
    } else if (filterOption!.watchlistTile != isWSListView) {
      pref.setMWView(isWSListView);
      ref.read(settingsProvider).checkIfPreferenceChanged(
            context: ref.read(tabControllProvider).context!,
            tagName: 'mwv',
          );
    }

    if (isDefaultChanged) {
      await getUserWatchlist(
        context: ref.read(tabControllProvider).context!,
        forceUpdate: true,
      );
      updateTab!(tabs.length);
    }
    notifyListeners();
  }

  // Method to apply filetr

  void applyFilter() {
    if (activeFilter == 'alphabets') {
      applyAlphabetsFilter();
    } else if (activeFilter == 'ltp') {
      applyLastTradePrice();
    } else if (activeFilter == "perChange") {
      applyPerChange();
    }
  }

  void applyFilterCatagory() {
    if (pref.wlTabIndex == 0) {
      for (var wsitem in getMWScrip1!) {
        for (final item in filterItemsList) {
          if (item.toLowerCase() != 'index' &&
              item.toLowerCase() != 'holdings') {
            if (filterItemsListIndex.isNotEmpty) {
              for (var indexitem in filterItemsListIndex) {
                if (wsitem.ex.toLowerCase() == item.toLowerCase() &&
                    wsitem.exSeg.toLowerCase() != indexitem.toLowerCase()) {
                  filteredItems.add(wsitem);
                }
              }
            } else {
              if (wsitem.ex.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            }
          } else {
            if (item.toLowerCase() == 'index') {
              if (wsitem.exSeg.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            } else if (item.toLowerCase() == 'holdings') {
              if ((wsitem.holdQty!.toLowerCase() != '0' &&
                  wsitem.holdQty!.toLowerCase() != 'null')) {
                filteredItems.add(wsitem);
              }
            }
          }
        }
      }
      if (filteredItems.isEmpty) {
        filteredItems = _list1 ?? [];
      }
    } else if (pref.wlTabIndex == 1) {
      for (var wsitem in getMWScrip2!) {
        for (final item in filterItemsList) {
          if (item.toLowerCase() != 'index' &&
              item.toLowerCase() != 'holdings') {
            if (filterItemsListIndex.isNotEmpty) {
              for (var indexitem in filterItemsListIndex) {
                if (wsitem.ex.toLowerCase() == item.toLowerCase() &&
                    wsitem.exSeg.toLowerCase() != indexitem.toLowerCase()) {
                  filteredItems.add(wsitem);
                }
              }
            } else {
              if (wsitem.ex.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            }
          } else {
            if (item.toLowerCase() == 'index') {
              if (wsitem.exSeg.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            } else if (item.toLowerCase() == 'holdings') {
              if ((wsitem.holdQty!.toLowerCase() != '0' &&
                  wsitem.holdQty!.toLowerCase() != 'null')) {
                filteredItems.add(wsitem);
              }
            }
          }
        }
      }
      if (filteredItems.isEmpty) {
        filteredItems = _list2 ?? [];
      }
    } else if (pref.wlTabIndex == 2) {
      for (var wsitem in getMWScrip3!) {
        for (final item in filterItemsList) {
          if (item.toLowerCase() != 'index' &&
              item.toLowerCase() != 'holdings') {
            if (filterItemsListIndex.isNotEmpty) {
              for (var indexitem in filterItemsListIndex) {
                if (wsitem.ex.toLowerCase() == item.toLowerCase() &&
                    wsitem.exSeg.toLowerCase() != indexitem.toLowerCase()) {
                  filteredItems.add(wsitem);
                }
              }
            } else {
              if (wsitem.ex.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            }
          } else {
            if (item.toLowerCase() == 'index') {
              if (wsitem.exSeg.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            } else if (item.toLowerCase() == 'holdings') {
              if ((wsitem.holdQty!.toLowerCase() != '0' &&
                  wsitem.holdQty!.toLowerCase() != 'null')) {
                filteredItems.add(wsitem);
              }
            }
          }
        }
      }
      if (filteredItems.isEmpty) {
        filteredItems = _list3 ?? [];
      }
    } else if (pref.wlTabIndex == 3) {
      for (var wsitem in getMWScrip4!) {
        for (final item in filterItemsList) {
          if (item.toLowerCase() != 'index' &&
              item.toLowerCase() != 'holdings') {
            if (filterItemsListIndex.isNotEmpty) {
              for (var indexitem in filterItemsListIndex) {
                if (wsitem.ex.toLowerCase() == item.toLowerCase() &&
                    wsitem.exSeg.toLowerCase() != indexitem.toLowerCase()) {
                  filteredItems.add(wsitem);
                }
              }
            } else {
              if (wsitem.ex.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            }
          } else {
            if (item.toLowerCase() == 'index') {
              if (wsitem.exSeg.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            } else if (item.toLowerCase() == 'holdings') {
              if ((wsitem.holdQty!.toLowerCase() != '0' &&
                  wsitem.holdQty!.toLowerCase() != 'null')) {
                filteredItems.add(wsitem);
              }
            }
          }
        }
      }
      if (filteredItems.isEmpty) {
        filteredItems = _list4 ?? [];
      }
    } else if (pref.wlTabIndex == 4) {
      for (var wsitem in getMWScrip5!) {
        for (final item in filterItemsList) {
          if (item.toLowerCase() != 'index' &&
              item.toLowerCase() != 'holdings') {
            if (filterItemsListIndex.isNotEmpty) {
              for (var indexitem in filterItemsListIndex) {
                if (wsitem.ex.toLowerCase() == item.toLowerCase() &&
                    wsitem.exSeg.toLowerCase() != indexitem.toLowerCase()) {
                  filteredItems.add(wsitem);
                }
              }
            } else {
              if (wsitem.ex.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            }
          } else {
            if (item.toLowerCase() == 'index') {
              if (wsitem.exSeg.toLowerCase() == item.toLowerCase()) {
                filteredItems.add(wsitem);
              }
            } else if (item.toLowerCase() == 'holdings') {
              if ((wsitem.holdQty!.toLowerCase() != '0' &&
                  wsitem.holdQty!.toLowerCase() != 'null')) {
                filteredItems.add(wsitem);
              }
            }
          }
        }
      }
      if (filteredItems.isEmpty) {
        filteredItems = _list5 ?? [];
      }
    }
    notifyListeners();
  }

  /// Method to Subscribe webscoket
  ///
  ///
  ///

  void requestWS({
    required bool isSubscribe,
    required BuildContext context,
  }) {
    log("ENTERED ${pref.wlTabIndex} $isSubscribe");
    String input = "";
    exchangeList = [];

    if ((getMWScrip1?.isNotEmpty == true && pref.wlTabIndex == 0) ||
        !isSubscribe) {
      if (getMWScrip1 != null) {
        getMWScrip1?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip2?.isNotEmpty == true && pref.wlTabIndex == 1) ||
        !isSubscribe) {
      if (getMWScrip2 != null) {
        getMWScrip2?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip3?.isNotEmpty == true && pref.wlTabIndex == 2) ||
        !isSubscribe) {
      if (getMWScrip3 != null) {
        getMWScrip3?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip4?.isNotEmpty == true && pref.wlTabIndex == 3) ||
        !isSubscribe) {
      if (getMWScrip4 != null) {
        getMWScrip4?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip5?.isNotEmpty == true && pref.wlTabIndex == 4) ||
        !isSubscribe) {
      if (getMWScrip5 != null) {
        getMWScrip5?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip6?.isNotEmpty == true && pref.wlTabIndex == 5) ||
        !isSubscribe) {
      if (getMWScrip6 != null) {
        getMWScrip6?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip7?.isNotEmpty == true && pref.wlTabIndex == 6) ||
        !isSubscribe) {
      if (getMWScrip7 != null) {
        getMWScrip7?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if ((getMWScrip8?.isNotEmpty == true && pref.wlTabIndex == 7) ||
        !isSubscribe) {
      if (getMWScrip8 != null) {
        getMWScrip8?.forEach((element) {
          input += "${element.ex}|${element.token}#";
          if (!exchangeList.contains(element.ex)) {
            exchangeList.add(element.ex);
          }
          if (element.exSeg.toLowerCase() == 'index') {
            if (!exchangeList.contains(element.exSeg)) {
              exchangeList.add(element.exSeg);
            }
          }
          if (element.holdQty!.toLowerCase() != 'null' &&
              element.holdQty!.toLowerCase() != '0') {
            if (!exchangeList.contains('HOLDINGS')) {
              exchangeList.add('HOLDINGS');
            }
          }
        });
      }
    }
    if (input.isNotEmpty) {
      ref.read(websocketProvider).establishConnection(
            channelInput: input.substring(0, input.length - 1),
            task: isSubscribe ? "t" : "u",
          );
    }
    notifyListeners();
  }

  bool isFilterNotEdited() {
    List<String> wsFilter = filterItemsList;
    wsFilter.addAll(filterItemsListIndex);
    if (filterOption!.watchlistFilter!.length != wsFilter.length) {
      return false;
    }
    for (var element in filterOption!.watchlistFilter!) {
      bool isAppear = false;
      for (var wsElement in wsFilter) {
        if (wsElement == element) {
          isAppear = true;
        }
      }
      if (!isAppear) {
        return false;
      }
    }
    return true;
  }

  bool checkFilterChanges() {
    if (filterOption != null) {
      if (filterOption!.addSymbolPref != pref.isMWScripAddTop) {
        return true;
      } else if (filterOption!.banknifty !=
          (pref.marketWatchDefaultTab.contains("banknifty") ? "1" : "0")) {
        return true;
      } else if (filterOption!.nifty !=
          ((pref.marketWatchDefaultTab.contains("nifty")) ? "1" : "0")) {
        return true;
      } else if (filterOption!.sensex !=
          (pref.marketWatchDefaultTab.contains("sensex") ? "1" : "0")) {
        return true;
      } else if (filterOption!.alphabetState != _isDecending ||
          filterOption!.ltpState != _isUpperPrice ||
          filterOption!.perChangeState != _isUpperPerchange) {
        return true;
      } else if (!isFilterNotEdited()) {
        return true;
      } else if (filterOption!.watchlistView != wsCardType) {
        return true;
      } else if (filterOption!.watchlistTile != isWSListView) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  /// Method to update add / delete locally
  ///
  ///
  void addDeleteScripMw({
    required List<Scrip> addDeleteScripVal,
    required BuildContext context,
    required bool isAdd,
  }) {
    int tabIndexVal = pref.wlTabIndex;

    switch (tabIndexVal) {
      case 0:
        var seen = <String>{};
        _list1 = _list1!
            .where((uniqueList) => seen.add(uniqueList.token.toString()))
            .toList();
        int totallen = _list1!.length;
        if (isAdd) {
          if (pref.isMWScripAddTop!) {
            for (int i = 0; i < addDeleteScripVal.length; i++) {
              if (!(seen.contains(addDeleteScripVal[i].token))) {
                addDeleteScripVal[i].sno = i;
                addDeleteScripVal[i].sortingOrder = i;
              }
            }
          } else {
            for (var element in addDeleteScripVal) {
              if (!(seen.contains(element.token))) {
                element.sno = totallen;
                element.sortingOrder = totallen;
                totallen += 1;
              }
            }
          }

          if (totallen <= 30) {
            if (pref.isMWScripAddTop!) {
              _list1!.insertAll(0, addDeleteScripVal);
            } else {
              _list1!.addAll(addDeleteScripVal);
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar("Market Watch full"));
          }

          notifyListeners();
        } else {
          _list1!.remove(_list1!.firstWhere(
              (element) => addDeleteScripVal[0].token == element.token));
          int count = 0;
          for (var element in _list1!) {
            element.sno = count;
            count += 1;
          }
          log(_list1!.toString());
          notifyListeners();
        }
        String token = "";
        for (var item in _list1!) {
          token += "${item.token} ";
        }

        log("ADD DELETE ::: 1 ${isAdd} ${token}");

        notifyListeners();
        break;
      case 1:
        var seen = Set<String>();
        _list2 = _list2!
            .where((uniqueList) => seen.add(uniqueList.token.toString()))
            .toList();
        if (isAdd) {
          int totallen = _list2!.length;

          if (pref.isMWScripAddTop!) {
            for (int i = 0; i < addDeleteScripVal.length; i++) {
              if (!(seen.contains(addDeleteScripVal[i].token))) {
                addDeleteScripVal[i].sno = i;
                addDeleteScripVal[i].sortingOrder = i;
              }
            }
          } else {
            for (var element in addDeleteScripVal) {
              if (!(seen.contains(element.token))) {
                element.sno = totallen;
                element.sortingOrder = totallen;
                totallen += 1;
              }
            }
          }

          if (totallen <= 30) {
            if (pref.isMWScripAddTop!) {
              _list2!.insertAll(0, addDeleteScripVal);
            } else {
              _list2!.addAll(addDeleteScripVal);
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar("Market Watch full"));
          }

          notifyListeners();
        } else {
          _list2!.remove(_list2!.firstWhere(
              (element) => addDeleteScripVal[0].token == element.token));
          int count = 0;
          for (var element in _list2!) {
            element.sno = count;
            count += 1;
          }
          notifyListeners();
        }
        String token = "";
        for (var item in _list2!) {
          token += "${item.token} ";
        }

        log("ADD DELETE ::: 2 ${isAdd} ${token}");
        notifyListeners();
        break;
      case 2:
        var seen = Set<String>();
        _list3 = _list3!
            .where((uniqueList) => seen.add(uniqueList.token.toString()))
            .toList();
        if (isAdd) {
          int totallen = _list3!.length;
          if (pref.isMWScripAddTop!) {
            for (int i = 0; i < addDeleteScripVal.length; i++) {
              if (!(seen.contains(addDeleteScripVal[i].token))) {
                addDeleteScripVal[i].sno = i;
                addDeleteScripVal[i].sortingOrder = i;
              }
            }
          } else {
            for (var element in addDeleteScripVal) {
              if (!(seen.contains(element.token))) {
                element.sno = totallen;
                element.sortingOrder = totallen;
                totallen += 1;
              }
            }
          }
          if (totallen <= 30) {
            if (pref.isMWScripAddTop!) {
              _list3!.insertAll(0, addDeleteScripVal);
            } else {
              _list3!.addAll(addDeleteScripVal);
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar("Market Watch full"));
          }

          notifyListeners();
        } else {
          _list3!.remove(_list3!.firstWhere(
              (element) => addDeleteScripVal[0].token == element.token));
          int count = 0;
          for (var element in _list3!) {
            element.sno = count;
            count += 1;
          }
          notifyListeners();
        }
        String token = "";
        for (var item in _list3!) {
          token += "(${item.token} , ${item.sno} , ${item.sortingOrder})";
        }

        log("ADD DELETE ::: 3 ${isAdd} ${token}");
        notifyListeners();
        break;
      case 3:
        var seen = <String>{};
        _list4 = _list4!
            .where((uniqueList) => seen.add(uniqueList.token.toString()))
            .toList();
        if (isAdd) {
          int totallen = _list4!.length;
          if (pref.isMWScripAddTop!) {
            for (int i = 0; i < addDeleteScripVal.length; i++) {
              if (!(seen.contains(addDeleteScripVal[i].token))) {
                addDeleteScripVal[i].sno = i;
                addDeleteScripVal[i].sortingOrder = i;
              }
            }
          } else {
            for (var element in addDeleteScripVal) {
              if (!(seen.contains(element.token))) {
                element.sno = totallen;
                element.sortingOrder = totallen;
                totallen += 1;
              }
            }
          }
          if (totallen <= 30) {
            if (pref.isMWScripAddTop!) {
              _list4!.insertAll(0, addDeleteScripVal);
            } else {
              _list4!.addAll(addDeleteScripVal);
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              errorSnackBar(
                "Market Watch full",
              ),
            );
          }

          notifyListeners();
        } else {
          _list4!.remove(_list4?.firstWhere(
              (element) => addDeleteScripVal[0].token == element.token));
          int count = 0;
          for (var element in _list4!) {
            element.sno = count;
            count += 1;
          }
          notifyListeners();
        }
        String token = "";
        for (var item in _list4!) {
          token += "(${item.token} , ${item.sno}) ";
        }

        log("ADD DELETE ::: 4 ${isAdd} ${token} ");
        notifyListeners();

        break;
      case 4:
        var seen = Set<String>();
        _list5 = _list5!
            .where((uniqueList) => seen.add(uniqueList.token.toString()))
            .toList();
        if (isAdd) {
          int totallen = _list5!.length;
          if (pref.isMWScripAddTop!) {
            for (int i = 0; i < addDeleteScripVal.length; i++) {
              if (!(seen.contains(addDeleteScripVal[i].token))) {
                addDeleteScripVal[i].sno = i;
                addDeleteScripVal[i].sortingOrder = i;
              }
            }
          } else {
            for (var element in addDeleteScripVal) {
              if (!(seen.contains(element.token))) {
                element.sno = totallen;
                element.sortingOrder = totallen;
                totallen += 1;
              }
            }
          }
          if (totallen <= 30) {
            if (pref.isMWScripAddTop!) {
              _list5!.insertAll(0, addDeleteScripVal);
            } else {
              _list5!.addAll(addDeleteScripVal);
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar("Market Watch full"));
          }

          notifyListeners();
        } else {
          _list5!.remove(_list5!.firstWhere(
              (element) => addDeleteScripVal[0].token == element.token));
          int count = 0;
          for (var element in _list5!) {
            element.sno = count;
            count += 1;
          }
          notifyListeners();
        }
        String token = "";
        for (var item in _list5!) {
          token += "${item.token}  ";
        }
        if (isAdd) {
          updateHoldWL(tabWLIndex: tabIndexVal);
        }

        log("ADD DELETE ::: 5 ${isAdd} ${token}");
        notifyListeners();

        break;
    }
    if (isAdd) {
      updateHoldWL(tabWLIndex: tabIndexVal);
    }
    requestWS(isSubscribe: true, context: context);
    notifyListeners();
  }
}
