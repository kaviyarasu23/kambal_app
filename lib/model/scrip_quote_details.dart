// To parse this JSON data, do
//
//     final scripQuoteDetails = scripQuoteDetailsFromJson(jsonString);

import 'dart:convert';

ScripQuoteDetails scripQuoteDetailsFromJson(String str) =>
    ScripQuoteDetails.fromJson(json.decode(str) as Map<String, dynamic>);

String scripQuoteDetailsToJson(ScripQuoteDetails data) =>
    json.encode(data.toJson());
ScripQuoteDetails? _scripQuoteData;
get data => _scripQuoteData;

class ScripQuoteDetails {
  ScripQuoteDetails({
    required this.optiontype,
    required this.sQty,
    required this.vwapAveragePrice,
    required this.ltq,
    required this.decimalPrecision,
    required this.openPrice,
    required this.ltp,
    required this.scripQuoteDetailsLtp,
    required this.bRate,
    required this.symbolname,
    required this.bQty,
    required this.ltt,
    required this.tickSize,
    required this.multiplier,
    required this.strikeprice,
    required this.totalSell,
    required this.high,
    required this.stat,
    required this.yearlyLowPrice,
    required this.yearlyHighPrice,
    required this.exchFeedTime,
    required this.bodLotQty,
    required this.prvClose,
    required this.change,
    required this.sRate,
    required this.series,
    required this.totalBuy,
    required this.low,
    required this.uniqueKey,
    required this.perChange,
    required this.companyname,
    required this.tradeVolume,
    required this.tSymbl,
    required this.exp,
    required this.ltd,
  });

  String? optiontype;
  String? sQty;
  String? vwapAveragePrice;
  String? ltq;
  String? decimalPrecision;
  String? openPrice;
  String? ltp;
  String? scripQuoteDetailsLtp;
  String? bRate;
  String? symbolname;
  String? bQty;
  String? ltt;
  String? tickSize;
  String? multiplier;
  String? strikeprice;
  String? totalSell;
  String? high;
  String? stat;
  String? yearlyLowPrice;
  String? yearlyHighPrice;
  String? exchFeedTime;
  String? bodLotQty;
  String? prvClose;
  String? change;
  String? sRate;
  String? series;
  String? totalBuy;
  String? low;
  String? uniqueKey;
  String? perChange;
  String? companyname;
  String? tradeVolume;
  String? tSymbl;
  String? exp;
  String? ltd;

  factory ScripQuoteDetails.fromJson(Map<String, dynamic> json) =>
      ScripQuoteDetails(
        optiontype: json["optiontype"].toString(),
        sQty: json["SQty"].toString(),
        vwapAveragePrice: json["vwapAveragePrice"].toString(),
        ltq: json["LTQ"].toString(),
        decimalPrecision: json["DecimalPrecision"].toString(),
        openPrice: json["openPrice"].toString(),
        ltp: json["LTP"].toString(),
        scripQuoteDetailsLtp: json["Ltp"].toString(),
        bRate: json["BRate"].toString(),
        symbolname: json["symbolname"].toString(),
        bQty: json["BQty"].toString(),
        ltt: json["LTT"].toString(),
        tickSize: json["TickSize"].toString(),
        multiplier: json["Multiplier"].toString(),
        strikeprice: json["strikeprice"].toString(),
        totalSell: json["TotalSell"].toString(),
        high: json["High"].toString(),
        stat: json["stat"].toString(),
        yearlyLowPrice: json["yearlyLowPrice"].toString(),
        yearlyHighPrice: json["yearlyHighPrice"].toString(),
        exchFeedTime: json["exchFeedTime"].toString(),
        bodLotQty: json["BodLotQty"].toString(),
        prvClose: json["PrvClose"].toString(),
        change: json["Change"].toString(),
        sRate: json["SRate"].toString(),
        series: json["Series"].toString(),
        totalBuy: json["TotalBuy"].toString(),
        low: json["Low"].toString(),
        uniqueKey: json["UniqueKey"].toString(),
        perChange: json["PerChange"].toString(),
        companyname: json["companyname"].toString(),
        tradeVolume: json["TradeVolume"].toString(),
        tSymbl: json["TSymbl"].toString(),
        exp: json["Exp"].toString(),
        ltd: json["LTD"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "optiontype": optiontype,
        "SQty": sQty,
        "vwapAveragePrice": vwapAveragePrice,
        "LTQ": ltq,
        "DecimalPrecision": decimalPrecision,
        "openPrice": openPrice,
        "LTP": ltp,
        "Ltp": scripQuoteDetailsLtp,
        "BRate": bRate,
        "symbolname": symbolname,
        "BQty": bQty,
        "LTT": ltt,
        "TickSize": tickSize,
        "Multiplier": multiplier,
        "strikeprice": strikeprice,
        "TotalSell": totalSell,
        "High": high,
        "stat": stat,
        "yearlyLowPrice": yearlyLowPrice,
        "yearlyHighPrice": yearlyHighPrice,
        "exchFeedTime": exchFeedTime,
        "BodLotQty": bodLotQty,
        "PrvClose": prvClose,
        "Change": change,
        "SRate": sRate,
        "Series": series,
        "TotalBuy": totalBuy,
        "Low": low,
        "UniqueKey": uniqueKey,
        "PerChange": perChange,
        "companyname": companyname,
        "TradeVolume": tradeVolume,
        "TSymbl": tSymbl,
        "Exp": exp,
        "LTD": ltd,
      };
}
