// To parse this JSON data, do
//
//     final technicalAnalysisResponse = technicalAnalysisResponseFromJson(jsonString);

import 'dart:convert';

TechnicalAnalysisResponse technicalAnalysisResponseFromJson(String str) =>
    TechnicalAnalysisResponse.fromJson(
        json.decode(str) as Map<String, dynamic>);

String technicalAnalysisResponseToJson(TechnicalAnalysisResponse data) =>
    json.encode(data.toJson());

class TechnicalAnalysisResponse {
  TechnicalAnalysisResponse({
    required this.stat,
    required this.result,
    required this.message,
  });

  String stat;
  Result? result;
  String message;

  factory TechnicalAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      TechnicalAnalysisResponse(
        stat: json["stat"].toString(),
        result: Result.fromJson(json["result"] as Map<String, dynamic>),
        message: json["message"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "stat": stat,
        "result": result!.toJson(),
        "message": message,
      };
}

class Result {
  Result({
    required this.sma30,
    required this.stochasticsK,
    required this.sma50,
    required this.macd,
    required this.rsi,
    required this.sma15,
    required this.adxIndicator,
    required this.standardDeviationIndicator,
    required this.stochRsi,
    required this.ema50,
    required this.atrIndicator,
    required this.ema12,
    required this.pivotPoints,
    required this.ema26,
    required this.stochasticsD,
  });

  String sma30;
  String stochasticsK;
  String sma50;
  String macd;
  String rsi;
  String sma15;
  String adxIndicator;
  String standardDeviationIndicator;
  String stochRsi;
  String ema50;
  String atrIndicator;
  String ema12;
  PivotPoints pivotPoints;
  String ema26;
  String stochasticsD;

  factory Result.fromJson(Map<String, dynamic> json) {
    String adxVal = '0.00';
    try {
      adxVal = (json["adxIndicator"] ?? 0).toString();
    } catch (e) {
      adxVal = '0.00';
    }
    return Result(
      sma30: (json["sma30"] ?? 0).toString(),
      stochasticsK: (json["stochasticsK"] ?? 0).toString(),
      sma50: (json["sma50"] ?? 0).toString(),
      macd: (json["macd"] ?? 0).toString(),
      rsi: (json["rsi"] ?? 0).toString(),
      sma15: (json["sma15"] ?? 0).toString(),
      adxIndicator: adxVal,
      standardDeviationIndicator:
          (json["standardDeviationIndicator"] ?? 0).toString(),
      stochRsi: (json["stochRSI"] ?? 0).toString(),
      ema50: (json["ema50"] ?? 0).toString(),
      atrIndicator: (json["atrIndicator"] ?? 0).toString(),
      ema12: (json["ema12"] ?? 0).toString(),
      pivotPoints:
          PivotPoints.fromJson(json["pivotPoints"] as Map<String, dynamic>),
      ema26: (json["ema26"] ?? 0).toString(),
      stochasticsD: (json["stochasticsD"] ?? 0).toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "sma30": sma30,
        "stochasticsK": stochasticsK,
        "sma50": sma50,
        "macd": macd,
        "rsi": rsi,
        "sma15": sma15,
        "adxIndicator": adxIndicator,
        "standardDeviationIndicator": standardDeviationIndicator,
        "stochRSI": stochRsi,
        "ema50": ema50,
        "atrIndicator": atrIndicator,
        "ema12": ema12,
        "pivotPoints": pivotPoints.toJson(),
        "ema26": ema26,
        "stochasticsD": stochasticsD,
      };
}

class PivotPoints {
  PivotPoints({
    required this.support3,
    required this.resistance3,
    required this.pivotPoints,
    required this.resistance2,
    required this.resistance1,
    required this.support2,
    required this.support1,
  });

  String support3;
  String resistance3;
  String pivotPoints;
  String resistance2;
  String resistance1;
  String support2;
  String support1;

  factory PivotPoints.fromJson(Map<String, dynamic> json) => PivotPoints(
        support3: (json["support3"] ?? '0').toString(),
        resistance3: (json["resistance3"] ?? '0').toString(),
        pivotPoints: (json["pivotPoints"] ?? '0').toString(),
        resistance2: (json["resistance2"] ?? '0').toString(),
        resistance1: (json["resistance1"] ?? '0').toString(),
        support2: (json["support2"] ?? '0').toString(),
        support1: (json["support1"] ?? '0').toString(),
      );

  Map<String, dynamic> toJson() => {
        "support3": support3,
        "resistance3": resistance3,
        "pivotPoints": pivotPoints,
        "resistance2": resistance2,
        "resistance1": resistance1,
        "support2": support2,
        "support1": support1,
      };
}

class TechnicalAnalysisInput {
  TechnicalAnalysisInput({required this.exch, required this.token});

  String exch;
  String token;

  Map<String, dynamic> toJson() => {'exch': exch, 'token': token};
}
