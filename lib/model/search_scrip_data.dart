// To parse this JSON data, do
//
//     final searchScripData = searchScripDataFromJson(jsonString);

import 'dart:convert';
// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

Searchdata searchFromJson(String str) => Searchdata.fromJson(json.decode(str));

String searchToJson(Searchdata data) => json.encode(data.toJson());

class Searchdata {
  Searchdata({
    required this.status,
    required this.message,
    required this.result,
  });

  String status;
  String message;
  List<SearchScripData> result;

  factory Searchdata.fromJson(Map<String, dynamic> json) => Searchdata(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        result: List<SearchScripData>.from(
            json["result"].map((x) => SearchScripData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result,
      };
}

// class Result {
//   Result({
//     required this.exchange,
//     required this.segment,
//     required this.symbol,
//     required this.token,
//     required this.scripName,
//   });

//   String exchange;
//   String segment;
//   String symbol;
//   String token;
//   String scripName;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         exchange: (json["exchange"] ?? "").toString(),
//         segment: json["segment"],
//         symbol: json["symbol"],
//         token: json["token"],
//         scripName: json["scripName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "exchange": exchange,
//         "segment": segment,
//         "symbol": symbol,
//         "token": token,
//         "scripName": scripName,
//       };
// }

class SearchScripData {
  SearchScripData({
    required this.exch,
    required this.exchangeSegment,
    required this.symbol,
    required this.token,
    this.splittedInsName,
    this.splittedTagName,
    required this.formattedInsName,
    required this.weekTag,
    this.isWeekTag = false,
    this.ltp = "0.00",
    this.change = "0.00",
    this.percentageChange = "0.00",
    this.close = "0.00",
    this.high = "0.00",
    this.low = "0.00",
    this.open = "0.00",
    this.isIndex = false,
    this.formatedInstrumentName = "",
    this.expiry,
    this.isMonth = false,
    this.isWeek = false,
  });
  bool? isWeekTag;
  String? exch;
  String? exchangeSegment;
  String? symbol;
  String? token;
  String? expiry;
  String? splittedTagName;
  String? splittedInsName;
  String? formattedInsName;
  String? weekTag;
  String? ltp;
  String? change;
  String? percentageChange;
  String? high;
  String? low;
  String? close;
  String? open;
  bool? isIndex;
  String? formatedInstrumentName;

  bool isMonth;
  bool isWeek;

  factory SearchScripData.fromJson(Map<String, dynamic> json) {
    final String ltpVal = "0.00";
    final String highVal = "0.00";
    final String lowVal = "0.00";
    final String openVal = "0.00";
    final String closeVal = "0.00";
    final String changeVal = "0.00";
    final String expiryValue = (json["expiry"] ?? "").toString();
    final String percentageChangeVal = "0.00";
    final String exch = (json["exchange"] ?? '').toString();
    final String symbolName = (json["symbol"] ?? '').toString();
    final String formatedSymbolName =
        (json["formattedInsName"] ?? '').toString();
    final String exSeg = (json["segment"] ?? '').toString();
    String weekTag = (json["weekTag"] ?? '').toString();
    final bool isIndexScrip = exSeg.toLowerCase().startsWith('index');
    final String instName =
        exch.toLowerCase() == 'nse' || exch.toLowerCase() == 'bse'
            ? symbolName
            : formatedSymbolName;
    final bool isWeekTabValue = weekTag.isNotEmpty && weekTag != "null";
    bool isMonthTagVal = false;
    bool isWeekTagVal = false;
    if (weekTag.isNotEmpty) {
      if (weekTag.toLowerCase() == 'm') {
        isMonthTagVal = true;
      } else if (weekTag.toLowerCase().contains("w")) {
        isWeekTagVal = true;
        final weekTagSplitVal = weekTag.toLowerCase().split("w");
        weekTag = weekTag.isNotEmpty
            ? weekTagSplitVal[0].isEmpty
                ? "${weekTagSplitVal[0].isEmpty ? 'W' : weekTagSplitVal[0]}${weekTagSplitVal[1]}"
                : weekTagSplitVal[1].isEmpty
                ? "${weekTagSplitVal[1].isEmpty ? 'W' : weekTagSplitVal[1]}${weekTagSplitVal[0]}"
                : "${weekTagSplitVal[0]}${weekTagSplitVal[1].isEmpty ? 'W' : weekTagSplitVal[1]}"
            : weekTag;
      }
    }
    String splitted = "";
    exch.toLowerCase() == "nfo"
        ? formatedSymbolName.split(" ").length > 1
            ? formatedSymbolName.split(" ")[1].contains('th') ||
                    formatedSymbolName.split(" ")[1].contains('nd') ||
                    formatedSymbolName.split(" ")[1].contains('rd')
                ? formatedSymbolName.split(" ")[1].contains('th')
                    ? splitted = "th"
                    : formatedSymbolName.split(" ")[1].contains('nd')
                        ? splitted = "nd"
                        : splitted = "rd"
                : ""
            : ""
        : "";
    return SearchScripData(
      expiry: expiryValue,
      isWeekTag: isWeekTabValue,
      splittedInsName: (json["formattedInsName"] ?? "").split(" ").toString(),
      exch: exch,
      exchangeSegment: exSeg,
      symbol: symbolName,
      token: (json["token"] ?? '').toString(),
      formattedInsName: formatedSymbolName,
      weekTag: weekTag,
      ltp: ltpVal,
      splittedTagName: splitted,
      percentageChange: percentageChangeVal,
      change: changeVal,
      close: closeVal,
      high: highVal,
      low: lowVal,
      open: openVal,
      isIndex: isIndexScrip,
      formatedInstrumentName: instName,
      isMonth: isMonthTagVal,
      isWeek: isWeekTagVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "exch": exch,
        "exchange_segment": exchangeSegment,
        "symbol": symbol,
        "token": token,
        "formattedInsName": formattedInsName,
      };
}
