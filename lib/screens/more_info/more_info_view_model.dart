import 'dart:developer';

import 'package:aliceblue/api/core/api_exporter.dart';
import 'package:aliceblue/locator/locator.dart';
import 'package:aliceblue/provider/core/default_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/market_watch_list_model.dart';
import '../../model/scrip_quote_details.dart';
import '../../model/security_info.dart';



final moreInfoViewProvider =
    ChangeNotifierProvider.autoDispose((ref) => MoreInfoViewModel(
          ref,
          locator<ApiExporter>(),
        ));

class MoreInfoViewModel extends DefaultChangeNotifier {
  final Ref ref;
  final ApiExporter api;
  MoreInfoViewModel(
    this.ref,
    this.api,
  );
  MoreInfoModelArgs? moreInfoModelArgs;
  MoreInfoModelArgs? get moreInfo => moreInfoModelArgs;
  SecurityInfo? _securityInfo;
  SecurityInfo? get getSecurityInfo => _securityInfo;
  ScripQuoteDetails? _scripQuoteData;
  ScripQuoteDetails? get getScripQuoteDetails => _scripQuoteData;

  List<String> moreInfoHeadList = [
    "Market Depth",
    "Technicals",
    "Info",
  ];
  List<String> get getMoreInfoHeadList => moreInfoHeadList;

  String optionType = "";
  String spotType = "";
  String get optionSpotType => spotType;

  void setMoreInfoArgs(
      {required MoreInfoModelArgs args, required BuildContext context}) {
    moreInfoModelArgs = args;
  }

  setExpiry({required BuildContext context}) async {
    items = [];
    isLtpSelected = true;
    // await ref(helperProvider).fetchOptionChainExpiryFetch(
    //     context: context, symbol: moreInfo!.symbol);
    // spotType = moreInfo!.symbol;

    // for (var item in ref(helperProvider).optionChainExpiry!.underlyingExpiry) {
    //   items.add(item);
    // }

    selectedValue = items[0];
  }

  List<String> items = [];

  int tabIndex = 0;
  int get getIndex => tabIndex;

  fetchOptionChainService({required BuildContext context}) async {
    // await ref(helperProvider).fetchOptionChainExpiryFetch(
    //     context: context, symbol: moreInfo!.symbol);
    // final OptionChainInput input = OptionChainInput(
    //   symbol: moreInfo!.symbol,
    //   expiry: '${selectedValue}',
    //   strikeNo: 10,
    // );
    // await ref(helperProvider).fetchOptionChain(
    //   context: context,
    //   expiry: selectedValue,
    //   underlying: spotType,
    // );
  }

  changeTabIndex({required int index, required BuildContext context}) {
    tabIndex = index;
    if (tabIndex == 3) {
      fetchOptionChainService(context: context);
    }
    notifyListeners();
  }

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("LTP"),
    1: Text("OI")
  };

  bool isLtpSelected = true;
  bool get isLtpEnable => isLtpSelected;

  void changeOptionToggle({required bool isLtp}) {
    isLtpSelected = isLtp;
    log("IS LTP :::: $isLtpSelected");
    notifyListeners();
  }

  String selectedValue = '';
  bool isCallVal = true;
  bool get isCall => isCallVal;

  void changeSelectedValue(
      {required String value, required BuildContext context}) {
    selectedValue = value;
    fetchOptionChainService(context: context);
    notifyListeners();
  }

  void changeType({required bool value}) {
    isCallVal = value;
    notifyListeners();
  }

  /// Method to get ScripQuotes
  ///
  ///

  Future<void> getSecurityInfoDetails({
    required String symbol,
    required String exchange,
    required BuildContext context,
  }) async {
    try {
      toggleLoadingOn(true);
      final SecurityInfoInput input = SecurityInfoInput(
        exch: exchange,
        token: symbol,
      );
      _securityInfo = await api.getSecurityInfoDetails(
        input: input,
        context: context,
        ref: ref,
      );
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }
}
