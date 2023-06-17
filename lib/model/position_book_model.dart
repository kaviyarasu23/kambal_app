// To parse this JSON data, do
//
//     final positionBookInfo = positionBookInfoFromJson(jsonString);

import 'dart:convert';

PositionBookInfo positionBookInfoFromJson(String str) =>
    PositionBookInfo.fromJson(json.decode(str));

String positionBookInfoToJson(PositionBookInfo data) =>
    json.encode(data.toJson());

class PositionBookInfo {
  bool? status;
  String? message;
  List<PositionBookInfoResult>? result;

  PositionBookInfo({
    this.status,
    this.message,
    this.result,
  });

  factory PositionBookInfo.fromJson(Map<String, dynamic> json) {
    List<PositionBookInfoResult> resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(PositionBookInfoResult.fromJson(element));
      }
    }
    return PositionBookInfo(
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

class PositionBookInfoResult {
  String? displayName;
  String? tradingsymbol;
  String? token;
  String? exchange;
  String? product;
  String? netQty;
  String? netAvgPrice;
  String? buyQty;
  String? buyPrice;
  String? sellQty;
  String? sellPrice;
  String? mtm;
  String? mtmBuyPrice;
  String? mtmSellprice;
  String? pnl;
  String? realizedPnl;
  String? unrealizedPnl;
  String? multiplier;
  String? lotsize;
  String? ticksize;
  String? pdc;
  String? ltp;
  String? breakevenPrice;
  String? overnightQty;
  String? overnightPrice;
  String? orderType;
  int? sno;
  int? exitOrderIndex;
  bool? isSelected;
  String change;
  String perChange;
  String? open;
  String? high;
  String? low;
  String? volume;

  PositionBookInfoResult(
      {this.displayName,
      this.tradingsymbol,
      this.token,
      this.exchange,
      this.product,
      this.netQty,
      this.netAvgPrice,
      this.buyQty,
      this.buyPrice,
      this.sellQty,
      this.sellPrice,
      this.mtm,
      this.mtmBuyPrice,
      this.mtmSellprice,
      this.pnl,
      this.realizedPnl,
      this.unrealizedPnl,
      this.multiplier,
      this.lotsize,
      this.ticksize,
      this.pdc,
      this.ltp,
      this.breakevenPrice,
      this.overnightQty,
      this.overnightPrice,
      this.orderType,
      this.sno = 0,
      this.exitOrderIndex = 0,
      this.isSelected = false,
      this.change = "0.00",
      this.high = "0.00",
      this.low = "0.00",
      this.open = "0.00",
      this.perChange = "0.00",
      this.volume = "0.00"});

  factory PositionBookInfoResult.fromJson(Map<String, dynamic> json) {
    final String exchVal = (json["exchange"] ?? '').toString();
    final String lotSizeVal = (json["lotsize"] ?? '0').toString();
    String netQtyVal = (json["netQty"] ?? '0').toString();
    String buyQtyVal = (json["buyQty"] ?? '0').toString();
    String sellQtyVal = (json["sellQty"] ?? '0').toString();
    if (exchVal.toLowerCase() == "mcx") {
      netQtyVal = (double.parse(netQtyVal) / double.parse(lotSizeVal))
          .toStringAsFixed(0);
      buyQtyVal = (double.parse(buyQtyVal) / double.parse(lotSizeVal))
          .toStringAsFixed(0);
      sellQtyVal = (double.parse(sellQtyVal) / double.parse(lotSizeVal))
          .toStringAsFixed(0);
    }
    return PositionBookInfoResult(
      displayName: (json["displayName"] ?? '').toString(),
      tradingsymbol: (json["tradingsymbol"] ?? '').toString(),
      token: (json["token"] ?? '').toString(),
      exchange: exchVal,
      product: (json["product"] ?? '').toString(),
      netQty: netQtyVal,
      netAvgPrice: (json["netAvgPrice"] ?? '0.00').toString(),
      buyQty: buyQtyVal,
      buyPrice: (json["buyPrice"] ?? '0.00').toString(),
      sellQty: sellQtyVal,
      sellPrice: (json["sellPrice"] ?? '0.00').toString(),
      mtm: (json["mtm"] ?? '0.00').toString(),
      mtmBuyPrice: (json["mtmBuyPrice"] ?? '0.00').toString(),
      mtmSellprice: (json["mtmSellprice"] ?? '0.00').toString(),
      pnl: (json["pnl"] ?? '0.00').toString(),
      realizedPnl: (json["realizedPnl"] ?? '0.00').toString(),
      unrealizedPnl: (json["unrealizedPnl"] ?? '0.00').toString(),
      multiplier: (json["multiplier"] ?? '0').toString(),
      lotsize: lotSizeVal,
      ticksize: (json["ticksize"] ?? '0.00').toString(),
      pdc: (json["pdc"] ?? '0.00').toString(),
      ltp: (json["ltp"] ?? '0.00').toString(),
      breakevenPrice: (json["breakevenPrice"] ?? '0.00').toString(),
      overnightQty: (json["overnightQty"] ?? '0').toString(),
      overnightPrice: (json["overnightPrice"] ?? '0.00'),
      orderType: (json["orderType"] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "tradingsymbol": tradingsymbol,
        "token": token,
        "exchange": exchange,
        "product": product,
        "netQty": netQty,
        "netAvgPrice": netAvgPrice,
        "buyQty": buyQty,
        "buyPrice": buyPrice,
        "sellQty": sellQty,
        "sellPrice": sellPrice,
        "mtm": mtm,
        "mtmBuyPrice": mtmBuyPrice,
        "mtmSellprice": mtmSellprice,
        "pnl": pnl,
        "realizedPnl": realizedPnl,
        "unrealizedPnl": unrealizedPnl,
        "multiplier": multiplier,
        "lotsize": lotsize,
        "ticksize": ticksize,
        "pdc": pdc,
        "ltp": ltp,
        "breakevenPrice": breakevenPrice,
        "overnightQty": overnightQty,
        "overnightPrice": overnightPrice,
        "orderType": orderType,
      };
}

class PositionConvertInput {
  final String exchange;
  final String tradingSymbol;
  final String qty;
  final String product;
  final String prevProduct;
  final String tranType;
  final String orderSource;
  final String posType;
  PositionConvertInput({
    this.exchange = "",
    this.posType = "DAY",
    this.prevProduct = "",
    this.product = "",
    this.qty = "",
    this.tradingSymbol = "",
    this.tranType = "",
    this.orderSource = "MOB",
  });
  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "posType": posType,
        "prevProduct": prevProduct,
        "product": product,
        "qty": qty,
        "tradingSymbol": tradingSymbol,
        "transType": tranType,
        "orderSource": orderSource
      };
}
