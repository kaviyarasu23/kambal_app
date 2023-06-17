import 'dart:convert';

import 'place_order_input_model.dart';

class getScripsInput {
  getScripsInput({
    required this.userId,
    this.predefined = "false",
  });

  String userId;
  String predefined;

  factory getScripsInput.fromJson(Map<String, dynamic> json) => getScripsInput(
        userId: json["userId"],
        predefined: json["predefined"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "predefined": predefined,
      };
}

class CustomizeWatchlistModel {
  final String scripName;
  final String ltp;
  final String? exchange;
  final String? holdQty;
  final String? change;
  final String? perChange;
  final String? bidQty;
  final String? bidPrice;
  final String? askQty;
  final String? askPrice;
  final String? volume;
  final int value;
  CustomizeWatchlistModel({
    this.askPrice,
    this.askQty,
    this.bidPrice,
    this.bidQty,
    this.change = "-2.05",
    this.exchange,
    this.holdQty,
    this.ltp = "2023",
    this.perChange = "-0.05",
    this.scripName = "SYMBOL",
    this.volume,
    required this.value,
  });
}

List<CustomizeWatchlistModel> dummyWatchlistScripModel = [
  CustomizeWatchlistModel(
    value: 0,
    exchange: "NSE",
    holdQty: "10",
  ),
  CustomizeWatchlistModel(
    value: 1,
    exchange: "NSE",
    holdQty: "10",
    askQty: "10",
    askPrice: "1020",
    bidPrice: "1000",
    bidQty: "5",
  ),
  CustomizeWatchlistModel(
      value: 2,
      exchange: "NSE",
      holdQty: "10",
      askQty: "10",
      askPrice: "1020",
      bidPrice: "1000",
      bidQty: "5",
      volume: "523000.10"),
];

class FilterOption {
  String nifty;
  String banknifty;
  String sensex;
  int? watchlistView;
  bool? watchlistTile;
  List<String>? watchlistFilter;
  String sort;
  bool? addSymbolPref;
  String? alphabetState;
  String? ltpState;
  String? perChangeState;
  FilterOption({
    this.nifty = "",
    this.addSymbolPref,
    this.banknifty = "",
    this.sensex = "",
    this.sort = "",
    this.watchlistFilter,
    this.watchlistTile,
    this.watchlistView,
    this.alphabetState = "default",
    this.ltpState = "default",
    this.perChangeState = "default",
  });
}

class WatchlistViewArgs {
  List<Scrip> data;
  int tabIndex;
  int scripCount;
  bool isListView;
  int wsCardType;
  Function(int val) updateTab;

  WatchlistViewArgs({
    required this.data,
    required this.isListView,
    required this.scripCount,
    required this.tabIndex,
    required this.updateTab,
    required this.wsCardType,
  });
}



class MarketWatchAddScripsInput {
  MarketWatchAddScripsInput({
    required this.userId,
    required this.mwId,
    required this.scripData,
  });

  String userId;
  int mwId;
  List<MarketWatchAddScripsDatum> scripData;

  factory MarketWatchAddScripsInput.fromJson(Map<String, dynamic> json) =>
      MarketWatchAddScripsInput(
        userId: json["userId"],
        mwId: json["mwId"],
        scripData: List<MarketWatchAddScripsDatum>.from(json["scripData"]
            .map((x) => MarketWatchAddScripsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "mwId": mwId,
        "scripData": List<dynamic>.from(scripData.map((x) => x.toJson())),
      };
}

class MarketWatchAddScripsDatum {
  MarketWatchAddScripsDatum({
    required this.exch,
    required this.token,
  });

  String exch;
  String token;

  factory MarketWatchAddScripsDatum.fromJson(Map<String, dynamic> json) =>
      MarketWatchAddScripsDatum(
        exch: json["exch"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "exch": exch,
        "token": token,
      };
}

class MoreInfoModelArgs {
  String ltp;
  String change;
  String close;
  String scripName;
  String percentageChange;
  bool isFromDashBoard;
  bool isDepthAck;
  String symbol;
  OrderWindowArguments? orderWindowArguments;
  MoreInfoModelArgs({
    this.change = "0.00",
    this.ltp = "0.00",
    this.close = "0.00",
    this.percentageChange = "0.00",
    required this.scripName,
    required this.isFromDashBoard,
    this.orderWindowArguments,
    this.isDepthAck = false,
    this.symbol = "",
  });
}

class MarketWatchNameUpdateInput {
  final String userId;
  final String mwId;
  final String mwName;
  MarketWatchNameUpdateInput({
    required this.mwId,
    required this.mwName,
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'mwId': mwId,
        'mwName': mwName,
      };
}

class ScripData {
  final String exch;
  final String token;
  final int sortingOrder;
  ScripData({
    required this.exch,
    required this.sortingOrder,
    required this.token,
  });
  Map<String, dynamic> toJson() => {
        'exch': exch,
        'sortingOrder': sortingOrder,
        'token': token,
      };
}


class SortMWListOrder {
  final String mwId;
  final String userId;
  final List<ScripData> scripData;
  SortMWListOrder({
    required this.mwId,
    required this.userId,
    required this.scripData,
  });
  Map<String, dynamic> toJson() => {
        'mwId': mwId,
        'userId': userId,
        'scripData': scripData,
      };
}


GetMwResponse getMwResponseFromJson(String str) =>
    GetMwResponse.fromJson(json.decode(str));

String getMwResponseToJson(GetMwResponse data) => json.encode(data.toJson());

class GetMwResponse {
  GetMwResponse({
    required this.stat,
    required this.message,
    required this.result,
  });

  bool stat;
  String message;
  List<MarketWatchScrips>? result;

  factory GetMwResponse.fromJson(Map<String, dynamic> json) {
    List<MarketWatchScrips>? resultVal = [];
    if (json["result"] != null) {
      for (var item in json["result"]) {
        resultVal.add(MarketWatchScrips.fromJson(item));
      }
    }
    final String message =
        (json['emsg'] ?? (json["message"] ?? '').toString()).toString();
    final bool status =
        ((json["status"] ?? '').toString().toLowerCase() == 'ok');
    return GetMwResponse(
      stat: status,
      message: message,
      result: resultVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "stat": stat,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class MarketWatchScrips {
  MarketWatchScrips({
    required this.mwId,
    required this.mwName,
    required this.scrips,
    this.errorMessage = '',
    this.isPredef = false,
  });

  String? mwId;
  String? mwName;
  bool? isPredef;
  List<Scrip>? scrips;
  String? errorMessage;

  factory MarketWatchScrips.fromJson(Map<String, dynamic> json) {
    String errorMessageVal = (json['emsg'] ?? '').toString();
    List<Scrip> scripsVal = [];
    int count = 0;
    if (json["scrips"] != null) {
      for (var item in json["scrips"]) {
        item['sno'] = count;
        item["sortOrder"] = count;
        scripsVal.add(Scrip.fromJson(item));
        count += 1;
      }
    }
    if (json["result"] != null) {
      for (var item in json["result"]) {
        item['sno'] = count;
        item["sortOrder"] = count;
        scripsVal.add(Scrip.fromJson(item));
        count += 1;
      }
    }
    return MarketWatchScrips(
      mwId: (json["mwId"] ?? '').toString(),
      mwName: (json["mwName"] ?? '').toString(),
      isPredef: (json["preDef"] ?? '0').toString() == "1",
      scrips: scripsVal,
      errorMessage: errorMessageVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "mwId": mwId,
        "mwName": mwName,
        "scrips": List<dynamic>.from(scrips!.map((x) => x.toJson())),
      };
}

class Scrip {
  Scrip(
      {required this.formattedInsName,
      required this.ex,
      required this.exSeg,
      required this.token,
      this.splittedTagName,
      required this.sortingOrder,
      required this.tradingSymbol,
      required this.expDt,
      required this.pdc,
      this.ltp = "0.00",
      this.perChange = "0.00",
      this.change = "0.00",
      this.isIndex,
      this.high = "0.00",
      this.low = "0.00",
      this.open = "0.00",
      this.bodlot = "0",
      this.tickSize = "0.00",
      this.volume = "0.00",
      this.w52h = "0.00",
      this.w52l = "0.00",
      this.holdQty,
      this.isHoldScrip,
      this.afterPoint,
      required this.symbol,
      this.sno,
      this.bp = '0.00',
      this.bq = '0',
      this.sp = '0.00',
      this.sq = '0',
      this.isWeekExpiry = false,
      this.errorMsg = '',
      this.segment});

  String formattedInsName;
  String ex;
  String exSeg;
  String token;
  bool? isWeekTag;
  String? splittedTagName = "";
  int sortingOrder;
  String tradingSymbol;
  String expDt;
  String pdc;
  String? ltp;
  String? perChange;
  String symbol;
  String? change;
  bool? isIndex;
  String? open;
  String? high;
  String? low;
  String? bodlot;
  String? tickSize;
  String? volume;
  String? w52h;
  String? w52l;
  String? holdQty;
  bool? isHoldScrip;
  int? afterPoint;
  int? sno;
  String? bq;
  String? bp;
  String? sq;
  String? sp;
  bool? isWeekExpiry;
  String? errorMsg;
  String? segment;
  factory Scrip.fromJson(Map<String, dynamic> json) {
    String openval = '0.00';
    String highval = '0.00';
    String lowval = '0.00';
    String bodlotval = '0';
    String tickSizeval = '0.00';
    String volumeval = '0.00';
    String w52hval = '0.00';
    String w52lval = '0.00';
    String holdQtyval = 'null';
    bool isHoldScripVal = false;
    String? symbolVal;
    final String exchange = (json["exchange"] ?? '').toString();
    int afterPointVal =
        (exchange.toLowerCase() == 'cds' || exchange.toLowerCase() == 'bcd')
            ? 4
            : 2;
    symbolVal = ((json["segment"] ?? '').toString().toLowerCase() ==
                'nse_idx' ||
            (json["segment"] ?? '').toString().toLowerCase() == 'nse_idx')
        ? (json["formattedInsName"] ?? "").toString()
        : (exchange.toLowerCase() == "nse" || exchange.toLowerCase() == "bse")
            ? (json["tradingSymbol"] ?? "").toString()
            : (json["formattedInsName"] ?? "").toString();
    String pdcVal = (json["pdc"] ?? '0.00').toString();
    String ltpVal = pdcVal;
    String exVal = (json["exchange"] ?? '').toString();
    String changeVal =
        (double.parse(ltpVal) - double.parse(pdcVal)).toStringAsFixed(2);
    String perChangeVal = (((double.parse(ltpVal) - double.parse(pdcVal)) /
                double.parse(pdcVal)) *
            100)
        .toStringAsFixed(2);
    String splitted = "";
    exVal.toLowerCase() == "nfo"
        ? symbolVal.split(" ").length > 1
            ? symbolVal.split(" ")[1].contains('th') ||
                    symbolVal.split(" ")[1].contains('nd') ||
                    symbolVal.split(" ")[1].contains('rd')
                ? symbolVal.split(" ")[1].contains('th')
                    ? splitted = "th"
                    : symbolVal.split(" ")[1].contains('nd')
                        ? splitted = "nd"
                        : splitted = "rd"
                : ""
            : ""
        : "";
    return Scrip(
      symbol: (json["symbol"] ?? ""),
      formattedInsName: symbolVal,
      ex: (json["exchange"] ?? '').toString(),
      exSeg: (json["segment"] ?? '').toString(),
      token: (json["token"] ?? '').toString(),
      sortingOrder: (json["sortOrder"] ?? 0),
      tradingSymbol: (json["tradingSymbol"] ?? '').toString(),
      expDt: (json["expiry"] ?? '').toString(),
      pdc: (json["pdc"] ?? '0.00').toString(),
      splittedTagName: splitted,
      change: changeVal,
      perChange: perChangeVal,
      isIndex: (json["segment"] ?? '').toString().toLowerCase() == 'nse_idx' ||
          (json["segment"] ?? '').toString().toLowerCase() == 'nse_idx',
      segment: (json["segment"] ?? ''),
      high: highval,
      low: lowval,
      open: openval,
      bodlot: bodlotval,
      tickSize: tickSizeval,
      volume: volumeval,
      w52h: w52hval,
      w52l: w52lval,
      holdQty: holdQtyval,
      isHoldScrip: isHoldScripVal,
      afterPoint: afterPointVal,
      sno: (json['sno'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "segment": segment,
        "formattedInsName": formattedInsName,
        "ex": ex,
        "exSeg": exSeg,
        "token": token,
        "sortingOrder": sortingOrder,
        "tradingSymbol": tradingSymbol,
        "expDt": expDt,
        "pdc": pdc,
      };
}
