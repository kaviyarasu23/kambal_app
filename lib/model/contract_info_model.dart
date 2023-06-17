class GetContractInfoInput {
  GetContractInfoInput({
    required this.token,
    required this.exch,
  });

  String? token;
  String? exch;

  Map<String, dynamic> toJson() => {
        "token": token,
        "exch": exch,
      };
}


class ContractInfoRes {
  ContractInfoRes({
    required this.status,
    required this.message,
    required this.result,
  });

  String? status;
  String? message;
  List<GetContractResult>? result;

  factory ContractInfoRes.fromJson(Map<String, dynamic> json) {
    List<GetContractResult>? resultVal = [];

    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(GetContractResult.fromJson(element));
      }
    }
    return ContractInfoRes(
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

class GetContractResult {
  GetContractResult({
    required this.isin,
    required this.freezeQty,
    required this.scrips,
  });

  String? isin;
  String? freezeQty;
  List<GetContractScrip>? scrips;

  factory GetContractResult.fromJson(Map<String, dynamic> json) {
    List<GetContractScrip>? scripsVal = [];
    if (json["scrips"] != null) {
      for (var element in json["scrips"]) {
        scripsVal.add(GetContractScrip.fromJson(element));
      }
    }

    return GetContractResult(
      isin: json["isin"],
      freezeQty: json["freezeQty"],
      scrips: scripsVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "isin": isin,
        "freezeQty": freezeQty,
        "scrips": scrips == null
            ? []
            : List<dynamic>.from(scrips!.map((x) => x.toJson())),
      };
}

class GetContractScrip {
  GetContractScrip({
    required this.exchange,
    required this.token,
    required this.tradingSymbol,
    required this.lotSize,
    required this.tickSize,
    required this.symbol,
    required this.formattedInsName,
    required this.pdc,
    required this.insType,
    this.expiry = "",
    this.ltp = "0.00",
    this.change = "0.00",
    this.close = "0.00",
    this.perChange = "0.00",
    this.freezeQty = "0",
  });

  String? exchange;
  String? token;
  String? tradingSymbol;
  String? lotSize;
  String? tickSize;
  String? symbol;
  String? formattedInsName;
  String? pdc;
  String? insType;
  String? expiry;
  String? ltp;
  String? close;
  String? change;
  String? perChange;
  String? freezeQty;
  factory GetContractScrip.fromJson(Map<String, dynamic> json) {
    String closeVal = "0.00";
    String changeval = "0.00";
    String perChangeval = "0.00";
    return GetContractScrip(
      exchange: json["exchange"],
      token: json["token"],
      tradingSymbol: json["tradingSymbol"],
      lotSize: json["lotSize"],
      tickSize: json["tickSize"],
      symbol: json["symbol"],
      formattedInsName: json["formattedInsName"],
      pdc: (json["pdc"] ?? '0.00'),
      insType: json["insType"],
      ltp: (json["ltp"] ?? '0.00').toString(),
      freezeQty: (json["freezeQty"] ?? '').toString(),
      expiry: (json["expiry"] ?? '').toString(),
      change: changeval,
      close: closeVal,
      perChange: perChangeval,
    );
  }

  Map<String, dynamic> toJson() => {
        "exchange": exchange,
        "token": token,
        "tradingSymbol": tradingSymbol,
        "lotSize": lotSize,
        "tickSize": tickSize,
        "symbol": symbol,
        "formattedInsName": formattedInsName,
        "pdc": pdc,
        "insType": insType,
        "expiry": expiry,
      };
}