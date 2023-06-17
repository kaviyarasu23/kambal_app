// To parse this JSON data, do
//
//     final holdingBookInfo = holdingBookInfoFromJson(jsonString);

import 'dart:convert';

HoldingBookInfo holdingBookInfoFromJson(String str) =>
    HoldingBookInfo.fromJson(json.decode(str));

String holdingBookInfoToJson(HoldingBookInfo data) =>
    json.encode(data.toJson());

class HoldingBookInfo {
  bool? status;
  String? message;
  List<HoldingBookInfoResult>? result;

  HoldingBookInfo({
    this.status,
    this.message,
    this.result,
  });

  factory HoldingBookInfo.fromJson(Map<String, dynamic> json) {
    List<HoldingBookInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(HoldingBookInfoResult.fromJson(element));
      }
    }

    return HoldingBookInfo(
      status: (json["status"] ?? '').toString().toLowerCase() == "ok",
      message: (json["message"] ?? '').toString(),
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

class HoldingBookInfoResult {
  bool? poa;
  String? product;
  List<Holding>? holdings;

  HoldingBookInfoResult({
    this.poa,
    this.product,
    this.holdings,
  });

  factory HoldingBookInfoResult.fromJson(Map<String, dynamic> json) {
    List<Holding>? holdingsVal = [];
    int holdScripCount = 0;
    if (json["holdings"] != null) {
      for (var element in json["holdings"]) {
        element["sno"] = holdScripCount;
        holdingsVal.add(Holding.fromJson(element));
        holdScripCount += 1;
      }
    }
    return HoldingBookInfoResult(
      poa: (json["poa"] ?? false) as bool,
      product: (json["product"] ?? '').toString(),
      holdings: holdingsVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "poa": poa,
        "product": product,
        "holdings": holdings == null
            ? []
            : List<dynamic>.from(holdings!.map((x) => x.toJson())),
      };
}

class Holding {
  String? isin;
  String? realizedPnl;
  String? unrealizedPnl;
  String? netPnl;
  String? netQty;
  String? buyPrice;
  String? holdQty;
  String? dpQty;
  String? benQty;
  String? unpledgedQty;
  String? collateralQty;
  String? brkCollQty;
  String? btstQty;
  String? usedQty;
  String? tradedQty;
  String? sellableQty;
  String? authQty;
  bool? authFlag;
  String? sellAmount;
  List<Symbol>? symbol;
  String? netPnlPerChange;
  String? invest;
  String? dayPnl;
  String? perChange;
  String? change;
  int? sno;

  Holding({
    this.isin,
    this.realizedPnl,
    this.unrealizedPnl,
    this.netPnl,
    this.netQty,
    this.buyPrice,
    this.holdQty,
    this.dpQty,
    this.benQty,
    this.unpledgedQty,
    this.collateralQty,
    this.brkCollQty,
    this.btstQty,
    this.usedQty,
    this.tradedQty,
    this.sellableQty,
    this.authQty,
    this.authFlag,
    this.sellAmount,
    this.symbol,
    this.dayPnl = "0.00",
    this.invest = "0.00",
    this.netPnlPerChange = "0.00",
    this.change = "0.00",
    this.perChange = "0.00",
    this.sno = 0,
  });

  factory Holding.fromJson(Map<String, dynamic> json) {
    List<Symbol>? symbolVal = [];
    if (json["symbol"] != null) {
      for (var element in json["symbol"]) {
        symbolVal.add(Symbol.fromJson(element));
      }
    }
    return Holding(
      isin: (json["isin"] ?? '').toString(),
      realizedPnl: (json["realizedPnl"] ?? '0.00').toString(),
      unrealizedPnl: (json["unrealizedPnl"] ?? '0.00').toString(),
      netPnl: (json["netPnl"] ?? '0.00').toString(),
      netQty: (json["netQty"] ?? '0').toString(),
      buyPrice: (json["buyPrice"] ?? '0.00').toString(),
      holdQty: (json["holdQty"] ?? '0').toString(),
      dpQty: (json["dpQty"] ?? '0').toString(),
      benQty: (json["benQty"] ?? '0').toString(),
      unpledgedQty: (json["unpledgedQty"] ?? '0').toString(),
      collateralQty: (json["collateralQty"] ?? '0').toString(),
      brkCollQty: (json["brkCollQty"] ?? '0').toString(),
      btstQty: (json["btstQty"] ?? '0').toString(),
      usedQty: (json["usedQty"] ?? '0').toString(),
      tradedQty: (json["tradedQty"] ?? '0').toString(),
      sellableQty: (json["sellableQty"] ?? '0').toString(),
      authQty: (json["authQty"] ?? '0').toString(),
      authFlag: (json["authFlag"] ?? false) as bool,
      sellAmount: (json["sellAmount"] ?? '0.00').toString(),
      symbol: symbolVal,
      sno: (json["sno"] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
        "isin": isin,
        "realizedPnl": realizedPnl,
        "unrealizedPnl": unrealizedPnl,
        "netPnl": netPnl,
        "netQty": netQty,
        "buyPrice": buyPrice,
        "holdQty": holdQty,
        "dpQty": dpQty,
        "benQty": benQty,
        "unpledgedQty": unpledgedQty,
        "collateralQty": collateralQty,
        "brkCollQty": brkCollQty,
        "btstQty": btstQty,
        "usedQty": usedQty,
        "tradedQty": tradedQty,
        "sellableQty": sellableQty,
        "authQty": authQty,
        "authFlag": authFlag,
        "sellAmount": sellAmount,
        "symbol": symbol == null
            ? []
            : List<dynamic>.from(symbol!.map((x) => x.toJson())),
      };
}

class Symbol {
  String? exchange;
  String? token;
  String? tradingSymbol;
  String? pdc;
  String? ltp;
  String? open;
  String? high;
  String? low;

  Symbol({
    this.exchange,
    this.token,
    this.tradingSymbol,
    this.pdc,
    this.ltp,
    this.high = "0.00",
    this.low = "0.00",
    this.open = "0.00",
  });

  factory Symbol.fromJson(Map<String, dynamic> json) => Symbol(
        exchange: (json["exchange"] ?? '').toString(),
        token: (json["token"] ?? '').toString(),
        tradingSymbol: (json["tradingSymbol"] ?? '').toString(),
        pdc: (json["pdc"] ?? '0.00').toString(),
        ltp: (json["ltp"] ?? '0.00').toString(),
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "token": token,
        "tradingSymbol": tradingSymbol,
        "pdc": pdc,
        "ltp": ltp,
      };
}

