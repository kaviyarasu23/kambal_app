import '../api/core/api_links.dart';

class PlaceOrderInput {
  String exchange;
  String tradingSymbol;
  String qty;
  String price;
  String product;
  String transType;
  String priceType;
  String triggerPrice;
  String orderType;
  String ret;
  String disclosedQty;
  String mktProtection;
  String target;
  String stopLoss;
  String trailingPrice;
  String source;
  String orderNo;
  String basketId;
  PlaceOrderInput({
    this.exchange = "",
    this.price = "0",
    this.priceType = "",
    this.product = "",
    this.qty = "0",
    this.ret = "",
    this.tradingSymbol = "",
    this.transType = "",
    this.triggerPrice = "",
    this.disclosedQty = "",
    this.mktProtection = "",
    this.orderType = "",
    this.target = "",
    this.stopLoss = "",
    this.trailingPrice = "",
    this.source = ApiLinks.loginType,
    this.orderNo = "",
    this.basketId = "",
  });

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "tradingSymbol": tradingSymbol,
        "qty": qty,
        "price": price,
        "product": product,
        "transType": transType,
        "priceType": priceType,
        "triggerPrice": triggerPrice,
        "ret": ret,
        "disclosedQty": disclosedQty,
        "mktProtection": mktProtection,
        "target": target,
        "stopLoss": stopLoss,
        "trailingPrice": trailingPrice,
        "orderType": orderType,
        "source": source,
        if (orderNo.isNotEmpty) "orderNo": orderNo,
        if (basketId.isNotEmpty) "basketId": basketId,
      };
}

/// Modify Order Input
/// 
/// 
/// 

class ModifyOrderInput {
  String exchange;
  String tradingSymbol;
  String qty;
  String price;
  String transType;
  String priceType;
  String triggerPrice;
  String ret;
  String disclosedQty;
  String mktProtection;
  String target;
  String stopLoss;
  String trailingPrice;
  String orderNo;
  String basketId;
  ModifyOrderInput({
    this.exchange = "",
    this.price = "0.00",
    this.priceType = "",
    this.qty = "0",
    this.ret = "",
    this.tradingSymbol = "",
    this.transType = "",
    this.triggerPrice = "0.00",
    this.disclosedQty = "",
    this.mktProtection = "",
    this.target = "",
    this.stopLoss = "",
    this.trailingPrice = "",
    this.orderNo = "",
    this.basketId = "",
  });

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "tradingSymbol": tradingSymbol,
        "qty": qty,
        "price": price,
        "transType": transType,
        "priceType": priceType,
        "triggerPrice": triggerPrice,
        "ret": ret,
        "disclosedQty": disclosedQty,
        "mktProtection": mktProtection,
        "target": target,
        "stopLoss": stopLoss,
        "trailingPrice": trailingPrice,
        if (orderNo.isNotEmpty) "orderNo": orderNo,
        if (basketId.isNotEmpty) "basketId": basketId,
      };
}


/// Cancel Order Input
/// 
/// 
/// 

class CancelOrderInput {
  final String orderNo;
  CancelOrderInput({
    this.orderNo = "",
  });
  Map<String, dynamic> toJson() => {
        "orderNo": orderNo,
      };
}


/// Basket Scrip Add Input
/// 
/// 
/// 

class BasketScripAddInput {
  BasketScripAddInput({
    this.basketId,
    this.scrips,
  });

  int? basketId;
  BasketScripAddInputScrips? scrips;

  factory BasketScripAddInput.fromJson(Map<String, dynamic> json) =>
      BasketScripAddInput(
        basketId: json["basketId"],
        scrips: json["scrips"] == null
            ? null
            : BasketScripAddInputScrips.fromJson(json["scrips"]),
      );

  Map<String, dynamic> toJson() => {
        "basketId": basketId,
        "scrips": scrips?.toJson(),
      };
}

class BasketScripAddInputScrips {
  BasketScripAddInputScrips({
    this.exchange,
    this.token,
    this.tradingSymbol,
    this.qty,
    this.price,
    this.expiry,
    this.product,
    this.transType,
    this.priceType,
    this.orderType,
    this.ret,
    this.triggerPrice,
    this.disclosedQty,
    this.mktProtection,
    this.target,
    this.stopLoss,
    this.trailingStopLoss,
    this.source = ApiLinks.loginType,
  });

  String? exchange;
  String? token;
  String? tradingSymbol;
  String? qty;
  String? price;
  String? expiry;
  String? product;
  String? transType;
  String? priceType;
  String? orderType;
  String? ret;
  String? triggerPrice;
  String? disclosedQty;
  String? mktProtection;
  String? target;
  String? stopLoss;
  String? trailingStopLoss;
  String? source;

  factory BasketScripAddInputScrips.fromJson(Map<String, dynamic> json) =>
      BasketScripAddInputScrips(
        exchange: json["exchange"],
        token: json["token"],
        tradingSymbol: json["tradingSymbol"],
        qty: json["qty"],
        price: json["price"],
        expiry: json["expiry"],
        product: json["product"],
        transType: json["transType"],
        priceType: json["priceType"],
        orderType: json["orderType"],
        ret: json["ret"],
        triggerPrice: json["triggerPrice"],
        disclosedQty: json["disclosedQty"],
        mktProtection: json["mktProtection"],
        target: json["target"],
        stopLoss: json["stopLoss"],
        trailingStopLoss: json["trailingStopLoss"],
      );

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "token": token,
        "tradingSymbol": tradingSymbol,
        "qty": qty,
        "price": price,
        "expiry": expiry,
        "product": product,
        "transType": transType,
        "priceType": priceType,
        "orderType": orderType,
        "ret": ret,
        "triggerPrice": triggerPrice,
        "disclosedQty": disclosedQty,
        "mktProtection": mktProtection,
        "target": target,
        "stopLoss": stopLoss,
        "trailingStopLoss": trailingStopLoss,
        "source": source,
      };
}

class OrderHistoryInput {
  final String orderNo;
  OrderHistoryInput({
    this.orderNo = "",
  });
  Map<String, dynamic> toJson() => {
        "orderNo": orderNo,
      };
}


class OrderWindowArguments {
  String? exchange;
  String? instrument;
  String? type;
  String ltp;
  String token;
  String? tradingSymbol;
  // OrderRecommendationData? recInfo;
  // RepeatOrderArgs? repeatOrderArgs;
  bool? isBasketOrder;
  OrderWindowArguments({
    this.exchange,
    this.instrument,
    this.type,
    required this.ltp,
    required this.token,
    // this.repeatOrderArgs = null,
    this.isBasketOrder = false,
    this.tradingSymbol = "",
  });
}