// To parse this JSON data, do
//
//     final securityInfo = securityInfoFromJson(jsonString);

// To parse this JSON data, do
//
//     final securityInfo = securityInfoFromJson(jsonString);

import 'dart:convert';

SecurityInfo securityInfoFromJson(String str) =>
    SecurityInfo.fromJson(json.decode(str));

String securityInfoToJson(SecurityInfo data) => json.encode(data.toJson());

class SecurityInfo {
  String? status;
  String? message;
  List<SecurityInfoResult>? result;

  SecurityInfo({
    this.status,
    this.message,
    this.result,
  });

  factory SecurityInfo.fromJson(Map<String, dynamic> json) {
    List<SecurityInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(SecurityInfoResult.fromJson(element));
      }
    }
    return SecurityInfo(
      status: json["status"],
      message: json["message"],
      result: resultVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class SecurityInfoResult {
  String? exchange;
  String? tradingSymbol;
  String? companyName;
  String? symbolName;
  String? segment;
  String? instrumentName;
  String? isin;
  String? pricePrecision;
  String? lotSize;
  String? tickSize;
  String? multiplier;
  String? tradeUnits;
  String? deliveryUnits;
  String? token;
  String? varMargin;
  String? prcftrD;
  String? expiry;
  String? strikePrice;
  String? optionType;
  String? gpNd;
  String? priceUnit;
  String? priceQuoteQty;
  String? freezeQty;
  String? scripupdateGsmInd;
  String? elmBuyMargin;
  String? elmSellMargin;
  String? additionalLongMargin;
  String? additionalShortMargin;
  String? specialLongMargin;
  String? deliveryMargin;
  String? tenderMargin;
  String? tenderStartDate;
  String? tenderEndEate;
  String? exerciseStartDate;
  String? exerciseEndDate;
  String? markettype;
  String? issuedate;
  String? listingDate;
  String? lastTradingDate;
  String? elmMargin;
  String? exposureMargin;
  String? weekly;
  String? dname;
  String? specialShortMargin;
  String? nontradableinstruments;

  String? openIntrest;
  String? instrumentType;
  String? maxOrderSize;
  String? priceDenominator;

  SecurityInfoResult({
    this.exchange,
    this.tradingSymbol,
    this.companyName,
    this.symbolName,
    this.segment,
    this.instrumentName,
    this.isin,
    this.pricePrecision,
    this.lotSize,
    this.tickSize,
    this.multiplier,
    this.tradeUnits,
    this.deliveryUnits,
    this.token,
    this.varMargin,
    this.prcftrD,
    this.expiry,
    this.strikePrice,
    this.optionType,
    this.gpNd,
    this.priceUnit,
    this.priceQuoteQty,
    this.freezeQty,
    this.scripupdateGsmInd,
    this.elmBuyMargin,
    this.elmSellMargin,
    this.additionalLongMargin,
    this.additionalShortMargin,
    this.specialLongMargin,
    this.deliveryMargin,
    this.tenderMargin,
    this.tenderStartDate,
    this.tenderEndEate,
    this.exerciseStartDate,
    this.exerciseEndDate,
    this.markettype,
    this.issuedate,
    this.listingDate,
    this.lastTradingDate,
    this.elmMargin,
    this.exposureMargin,
    this.weekly,
    this.dname,
    this.specialShortMargin,
    this.nontradableinstruments,
    this.openIntrest,
    this.instrumentType,
    this.maxOrderSize,
    this.priceDenominator,
  });

  factory SecurityInfoResult.fromJson(Map<String, dynamic> json) =>
      SecurityInfoResult(
        exchange: (json["exchange"] ?? '').toString(),
        tradingSymbol: (json["tradingSymbol"] ?? '').toString(),
        companyName: (json["companyName"] ?? '').toString(),
        symbolName: (json["symbolName"] ?? '').toString(),
        segment: (json["segment"] ?? '').toString(),
        instrumentName: (json["instrumentName"] ?? '').toString(),
        isin: (json["isin"] ?? '').toString(),
        pricePrecision: (json["pricePrecision"] ?? '').toString(),
        lotSize: (json["lotSize"] ?? '').toString(),
        tickSize: (json["tickSize"] ?? '').toString(),
        multiplier: (json["multiplier"] ?? '').toString(),
        tradeUnits: (json["tradeUnits"] ?? '').toString(),
        deliveryUnits: (json["deliveryUnits"] ?? '').toString(),
        token: (json["token"] ?? '').toString(),
        varMargin: (json["varMargin"] ?? '').toString(),
        prcftrD: (json["prcftr_d"] ?? '').toString(),
        expiry: (json["expiry"] ?? '').toString(),
        strikePrice: (json["strikePrice"] ?? '').toString(),
        optionType: (json["optionType"] ?? '').toString(),
        gpNd: (json["gp_nd"] ?? '').toString(),
        priceUnit: (json["priceUnit"] ?? '').toString(),
        priceQuoteQty: (json["priceQuoteQty"] ?? '').toString(),
        freezeQty: (json["freezeQty"] ?? '').toString(),
        scripupdateGsmInd: (json["scripupdateGsmInd"] ?? '').toString(),
        elmBuyMargin: (json["elmBuyMargin"] ?? '').toString(),
        elmSellMargin: (json["elmSellMargin"] ?? '').toString(),
        additionalLongMargin: (json["additionalLongMargin"] ?? '').toString(),
        additionalShortMargin: (json["additionalShortMargin"] ?? '').toString(),
        specialLongMargin: (json["specialLongMargin"] ?? '').toString(),
        deliveryMargin: (json["deliveryMargin"] ?? '').toString(),
        tenderMargin: (json["tenderMargin"] ?? '').toString(),
        tenderStartDate: (json["tenderStartDate"] ?? '').toString(),
        tenderEndEate: (json["tenderEndEate"] ?? '').toString(),
        exerciseStartDate: (json["exerciseStartDate"] ?? '').toString(),
        exerciseEndDate: (json["exerciseEndDate"] ?? '').toString(),
        markettype: (json["markettype"] ?? '').toString(),
        issuedate: (json["issuedate"] ?? '').toString(),
        listingDate: (json["listingDate"] ?? '').toString(),
        lastTradingDate: (json["lastTradingDate"] ?? '').toString(),
        elmMargin: (json["elmMargin"] ?? '').toString(),
        exposureMargin: (json["exposureMargin"] ?? '').toString(),
        weekly: (json["weekly"] ?? '').toString(),
        dname: (json["dname"] ?? '').toString(),
        specialShortMargin: (json["specialShortMargin"] ?? '').toString(),
        nontradableinstruments:
            (json["nontradableinstruments"] ?? '').toString(),
        openIntrest: (json["openIntrest"] ?? '').toString(),
        instrumentType: (json["instrumentType"] ?? '').toString(),
        maxOrderSize : (json["maxOrderSize"] ?? '').toString(),
        priceDenominator : (json["priceDenominator"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "tradingSymbol": tradingSymbol,
        "companyName": companyName,
        "symbolName": symbolName,
        "segment": segment,
        "instrumentName": instrumentName,
        "isin": isin,
        "pricePrecision": pricePrecision,
        "lotSize": lotSize,
        "tickSize": tickSize,
        "multiplier": multiplier,
        "tradeUnits": tradeUnits,
        "deliveryUnits": deliveryUnits,
        "token": token,
        "varMargin": varMargin,
        "prcftr_d": prcftrD,
        "expiry": expiry,
        "strikePrice": strikePrice,
        "optionType": optionType,
        "gp_nd": gpNd,
        "priceUnit": priceUnit,
        "priceQuoteQty": priceQuoteQty,
        "freezeQty": freezeQty,
        "scripupdateGsmInd": scripupdateGsmInd,
        "elmBuyMargin": elmBuyMargin,
        "elmSellMargin": elmSellMargin,
        "additionalLongMargin": additionalLongMargin,
        "additionalShortMargin": additionalShortMargin,
        "specialLongMargin": specialLongMargin,
        "deliveryMargin": deliveryMargin,
        "tenderMargin": tenderMargin,
        "tenderStartDate": tenderStartDate,
        "tenderEndEate": tenderEndEate,
        "exerciseStartDate": exerciseStartDate,
        "exerciseEndDate": exerciseEndDate,
        "markettype": markettype,
        "issuedate": issuedate,
        "listingDate": listingDate,
        "lastTradingDate": lastTradingDate,
        "elmMargin": elmMargin,
        "exposureMargin": exposureMargin,
        "weekly": weekly,
        "dname": dname,
        "specialShortMargin": specialShortMargin,
        "nontradableinstruments": nontradableinstruments,
      };
}

class SecurityInfoInput {
  final String exch;
  final String token;
  SecurityInfoInput({
    required this.exch,
    required this.token,
  });
  Map<String, dynamic> toJson() => {
        "exch": exch,
        "token": token,
      };
}
