import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/contract_info_model.dart';
import '../model/market_watch_list_model.dart';
import '../model/search_scrip_data.dart';
import '../model/technical_analysis_response.dart';
import '../shared_widget/snack_bar.dart';
import 'core/default_change_notifier.dart';
import 'market_provider.dart';
import 'websocket_provider.dart';

final marketHelperProvider =
    ChangeNotifierProvider((ref) => MarketHelperProvider(
          ref,
          locator<Preferences>(),
          locator<ApiExporter>(),
        ));

class MarketHelperProvider extends DefaultChangeNotifier {
  MarketHelperProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  List<MarketWatchAddScripsDatum> deleteScripList = [];
  List<Scrip> deletedListItems = [];

  // Contract Info

  ContractInfoRes? contractInfoRes = null;
  ContractInfoRes? get getContractInfoRes => contractInfoRes;

  List<GetContractScrip> marketDepthList = [];
  List<GetContractScrip> get getMarketDepth => marketDepthList;

  List<SearchScripData> _searchScripList = [];
  List<SearchScripData> get getScripSearchResult => _searchScripList;

  List<SearchScripData> _filterSearchScripList = [];
  List<SearchScripData> get getfilterScripSearchResult =>
      _filterSearchScripList;

  TechnicalAnalysisResponse? technicalAnalysisResponse;
  TechnicalAnalysisResponse? get getTechnicalAnalysisData =>
      technicalAnalysisResponse;

  bool isMwNameChange = false;

  bool isSearchFilter = false;

  String searchFilterActiveName = "ALL";

  final List<String> all = [
    "All",
    "NFO",
    "NSE",
    "CDS",
    "MCX",
    "BSE",
    "BCD",
  ];
  List<String> searchFilter = ["All"];

  final List<String> allScripSearch = [
    "All",
    "NFO",
    "NSE",
    "CDS",
    "MCX",
    "BSE",
  ];

  List<String> clickedIndexSearch = [];
  List<String> get getClickedIndexSearch => clickedIndexSearch;

  void disableFilterButton() {
    isSearchFilter = false;
    notifyListeners();
  }

  /// Clear delete list
  ///
  ///
  ///

  void clearDeleteList() {
    deleteScripList = [];
    deletedListItems = [];
    notifyListeners();
  }

  void clearMwNameChange() {
    ref.read(marketProvider).isMwListOrderChange = false;
    isMwNameChange = false;
    notifyListeners();
  }

  /// Change MW Name Change Status
  ///
  ///

  void mwNameStatus({required bool status}) {
    isMwNameChange = status;
    notifyListeners();
  }

  /// Discard Changes
  ///
  ///

  void discardChanges(int changeStatus) {
    if (changeStatus == 3 || changeStatus == 2) {
      if (isMwNameChange) {
        ref.read(marketProvider).watchlistRenameController.text =
            ref.read(marketProvider).oldMwName;
      }
    } else if (changeStatus == 1) {
      if (ref.read(marketHelperProvider).deleteScripList.isNotEmpty) {
        ref.read(marketProvider).deletedListAdded();
      } else {
        ref.read(marketProvider).setDefaultValue(false);
      }
    }
    notifyListeners();
  }

  void deleteScripListAdd({
    required String mwId,
    required MarketWatchAddScripsDatum scripsList,
    required List<Scrip> deleteScrip,
    required BuildContext context,
  }) {
    deletedListItems.add(deleteScrip[0]);
    deleteScripList.add(scripsList);
    ref.read(marketProvider).addDeleteScripMw(
          addDeleteScripVal: deleteScrip,
          context: context,
          isAdd: false,
        );
    notifyListeners();
  }

  /// Method to call delete local added scrips

  Future<void> deleteAllFromReorder(BuildContext context, String mwId) async {
    final MarketWatchAddScripsInput _input = MarketWatchAddScripsInput(
      mwId: double.parse(mwId).ceil(),
      scripData: deleteScripList,
      userId: pref.userId!,
    );
    final data = await api.deleteScrip(context, _input, ref);
    String input = "";
    if (data) {
      ref.read(marketProvider).getScrip(
          tabIndex: ref.read(marketProvider).tabBarIndex, context: context);
    }
    notifyListeners();
    for (var element in deleteScripList) {
      input += '${element.exch}|${element.token}#';

      ref.read(websocketProvider).establishConnection(
            channelInput: input.substring(0, input.length - 1),
            task: 'u',
          );
    }

    notifyListeners();
  }

  /// Method to get create MW

  Future<bool> createMw({
    required BuildContext context,
  }) async {
    bool res = false;
    try {
      toggleLoadingOn(true);

      final data = await api.createMW(
        ref: ref,
        userId: pref.userId!,
        context: context,
      );
      toggleLoadingOn(false);
      return data;
    } catch (e) {
      log('$e');
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
    notifyListeners();
    return res;
  }

  /// Method to update market watch name
  ///
  ///
  ///

  Future<bool> updateMwName({
    required MarketWatchNameUpdateInput updateMwInput,
    required BuildContext context,
  }) async {
    bool res = false;
    try {
      toggleLoadingOn(true);
      final data = await api.updateMwName(updateMwInput, context, ref);
      if (data) {
        await ref.read(marketProvider).getUserWatchlist(
              tabIndex: ref.read(marketProvider).getTabIndex,
              context: context,
              forceUpdate: true,
              isMwNameUpdate: true,
            );
        ref.read(marketProvider).marketWatchName();
        ref.read(marketHelperProvider).mwNameStatus(status: false);
        return res;
      }
      return res;
    } catch (e) {
      log("$e");
    } finally {
      toggleLoadingOn(false);
      notifyListeners();
    }
    notifyListeners();
    return res;
  }

  Future<void> getContractInfo({
    required BuildContext context,
    required String exchange,
    required String token,
  }) async {
    try {
      toggleLoadingOn(true);
      GetContractInfoInput input = GetContractInfoInput(
        exch: exchange,
        token: token,
      );
      final ContractInfoRes? contractInfo = await api.getContractInfo(
        context: context,
        Input: input,
        ref: ref,
      );
      contractInfoRes = contractInfo;
      if (contractInfo != null) {
        if (contractInfo.result!.isNotEmpty) {
          marketDepthList = [];
          List<GetContractScrip> tempmarketDepthList =
              contractInfo.result![0].scrips ?? [];
          if (tempmarketDepthList.length > 1) {
            tempmarketDepthList[0].exchange!.toLowerCase() == 'nse'
                ? marketDepthList.add(tempmarketDepthList[0])
                : marketDepthList.add(tempmarketDepthList[1]);
            tempmarketDepthList[1].exchange!.toLowerCase() == 'nse'
                ? marketDepthList.add(tempmarketDepthList[0])
                : marketDepthList.add(tempmarketDepthList[1]);
          } else {
            marketDepthList = tempmarketDepthList;
          }
          notifyListeners();
        } else {
          marketDepthList = [];
        }
      }

      notifyListeners();
    } catch (e) {
      log("Failed to fetch get margin ::: $e");
    } finally {
      toggleLoadingOn(false);

      notifyListeners();
    }
  }

  Future<void> getSearchScrip({
    required String key,
    required BuildContext context,
    required List<String> exchangeItems,
  }) async {
    try {
      toggleLoadingOn(true);

      _searchScripList = await api.fetchSearchScrip(
        symbol: key,
        context: context,
        exchangeItems: exchangeItems,
      );

      filterSearch();
    } catch (e) {
      debugPrint("Failed to fetch Seach Data:: ${e.toString()}");
    } finally {
      toggleLoadingOn(false);
    }
  }

  void clearSearch() {
    searchFilter = ["ALL"];
    _searchScripList = [];
    _filterSearchScripList = [];
    diableSearchFilterActiveButton(searchFilterName: "searchFilterName");
  }

  void diableSearchFilterActiveButton({required String searchFilterName}) {
    searchFilterActiveName = "ALL";
    notifyListeners();
  }

  void filterSearch() {
    log(searchFilter.toString());
    if (searchFilter[0].toUpperCase() == "ALL") {
      _filterSearchScripList = _searchScripList;
    } else {
      _filterSearchScripList = _searchScripList
          .where((element) =>
              element.exch == searchFilter.first ||
              element.exch == searchFilter.last)
          .toList();
    }
    notifyListeners();
  }

  /// Method to call add for scrips in MW

  Future<bool> addScrip({
    required String mwId,
    required List<MarketWatchAddScripsDatum> scripsList,
    required int tabIndex,
    required BuildContext context,
  }) async {
    bool isScripAdded = false;
    try {
      toggleLoadingOn(true);
      final MarketWatchAddScripsInput input = MarketWatchAddScripsInput(
        mwId: double.parse(mwId).ceil(),
        scripData: scripsList,
        userId: pref.userId!,
      );
      List<Scrip> res = await api.addScrip(input, context, ref);

      if (res.isNotEmpty) {
        ref.read(marketProvider).addDeleteScripMw(
              context: context,
              addDeleteScripVal: res,
              isAdd: true,
            );
        isScripAdded = true;
      }
    } catch (e) {
      log('$e');
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
    return isScripAdded;
  }

  /// Method to call delete for scrips in MW

  Future<bool> deleteScrip({
    required String mwId,
    required int tabIndex,
    required int index,
    required List<MarketWatchAddScripsDatum> scripsList,
    required List<Scrip> deleteScrip,
    required BuildContext context,
    bool forceUpdate = false,
  }) async {
    bool res = true;
    try {
      toggleLoadingOn(true);
      final MarketWatchAddScripsInput _input = MarketWatchAddScripsInput(
        mwId: double.parse(mwId).ceil(),
        scripData: scripsList,
        userId: " pref.userId!",
      );

      api.deleteScrip(
        context,
        _input,
        ref,
      );
      ref.read(marketProvider).addDeleteScripMw(
            addDeleteScripVal: deleteScrip,
            context: context,
            isAdd: false,
          );
      return res;
    } catch (e) {
      log("$e");
    } finally {
      try {
        toggleLoadingOn(false);
        notifyListeners();
        // ignore: empty_catches
      } catch (e) {}
    }
    notifyListeners();
    return res;
  }

  void changeSearchClickIndex({required String value}) {
    log(value.toString());
    if (clickedIndexSearch.any((element) => element == value)) {
      clickedIndexSearch.remove(value);
    } else {
      clickedIndexSearch.add(value);
    }
    notifyListeners();
  }

  void deleteScripViaSearch(BuildContext context, SearchScripData data,
      List<Scrip> selectedScrip, int tabIndex, int listIndex) async {
    {
      changeSearchClickIndex(value: data.token!);
      List<MarketWatchAddScripsDatum> scripListInput = [
        MarketWatchAddScripsDatum(
          exch: data.exch!,
          token: data.token!,
        )
      ];
      // delete
      await deleteScrip(
        context: context,
        mwId: ref.read(marketProvider).getWatchList!.result![tabIndex].mwId!,
        deleteScrip: [
          selectedScrip.firstWhere((element) => element.token == data.token!)
        ],
        scripsList: scripListInput,
        index: listIndex,
        tabIndex: tabIndex,
        forceUpdate: true,
      );
      changeSearchClickIndex(value: data.token!);
    }
  }

  void addScripViaSearch(BuildContext context, SearchScripData data,
      List<Scrip> selectedScrip, int tabIndex) async {
    if (selectedScrip.length > 30) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(errorSnackBar("Market Watch full"));
      return;
    } else {
      if (ref.read(marketProvider).getWatchList == null) {
        final stat = await createMw(context: context);
        if (stat) {
          await ref.read(marketProvider).getUserWatchlist(
                context: context,
                forceUpdate: true,
                tabIndex: tabIndex,
              );
        }
      }
      log("MWID ::: ${ref.read(marketProvider).getWatchList!.result![tabIndex].mwId}");
      var seen = <String>{};
      selectedScrip
          .where((uniqueList) => seen.add(uniqueList.token.toString()))
          .toList();
      log("ADD SCRIP JSON :::  LENG ::: ${selectedScrip.length}");
      if ((!(seen.contains(data.token)))) {
        changeSearchClickIndex(value: data.token!);
        List<MarketWatchAddScripsDatum> scripListInput = [
          MarketWatchAddScripsDatum(
            exch: data.exch!,
            token: data.token!,
          )
        ];
        await addScrip(
          mwId: ref.read(marketProvider).getWatchList!.result![tabIndex].mwId!,
          scripsList: scripListInput,
          tabIndex: tabIndex,
          context: context,
        );
        changeSearchClickIndex(value: data.token!);
      }
    }
  }

  Future<void> savebutton(
      {required BuildContext context,
      required bool isListChanged,
      required bool isDeleted,
      required bool isMwNameChanged}) async {
    try {
      final MarketWatchScrips currentMWScrip = ref
          .read(marketProvider)
          .getWatchList!
          .result![ref.read(marketProvider).getTabIndex];
      if (isMwNameChanged) {
        MarketWatchNameUpdateInput input = MarketWatchNameUpdateInput(
          mwId: currentMWScrip.mwId!,
          mwName: ref.read(marketProvider).watchlistRenameController.text,
          userId: pref.userId!,
        );
        await updateMwName(updateMwInput: input, context: context);
      }
      if (isListChanged || isDeleted) {
        if (deleteScripList.isNotEmpty) {
          deleteAllFromReorder(context, currentMWScrip.mwId.toString());
        } else {
          ref.read(marketProvider).sortMwListOrder(context: context);
        }
      }
      clearMwNameChange();
      Navigator.pop(context);
    } catch (e) {
      log("$e");
    } finally {}
    notifyListeners();
  }

  // Search

  void enableSearchFilterActiveButton({required String searchFilterName}) {
    searchFilterActiveName = searchFilterName;
    if (searchFilterActiveName == "ALL") {
      searchFilter = ["ALL"];
    } else if (searchFilterActiveName == "STOCKS") {
      searchFilter = ["NSE", "BSE"];
    } else if (searchFilterActiveName == "CURRENCY") {
      searchFilter = ["CDS", "BCD"];
    } else if (searchFilterActiveName == "F&O") {
      searchFilter = ["NFO", "BFO"];
    }
    filterSearch();
  }

  void diablesearchFilterActiveButton({required String searchFilterName}) {
    searchFilterActiveName = "ALL";
    notifyListeners();
  }
}
