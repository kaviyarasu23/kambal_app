import 'dart:convert';

TouchlineUpdateStream touchlineUpdateStreamFromJson(String str) =>
    TouchlineUpdateStream.fromJson(json.decode(str) as Map<String, dynamic>);

String touchlineUpdateStreamToJson(TouchlineUpdateStream data) =>
    json.encode(data.toJson());

class TouchlineUpdateStream {
  TouchlineUpdateStream({
    required this.t,
    required this.e,
    required this.tk,
    required this.lp,
    required this.pc,
    required this.o,
    required this.h,
    required this.l,
    required this.c,
    required this.ap,
    required this.v,
    required this.oi,
    this.bp1,
    this.bq1,
    this.sp1,
    this.sq1,
    this.ts,
  });

  String? t;
  String? e;
  String? tk;
  String? ts;
  String? lp;
  String? pc;
  String? o;
  String? h;
  String? l;
  String? c;
  String? ap;
  String? v;
  String? oi;
  String? bq1;
  String? bp1;
  String? sq1;
  String? sp1;

  factory TouchlineUpdateStream.fromJson(Map<String, dynamic> json) {
    final String? task = json["t"] == null || json["t"].toString() == "null"
        ? null
        : json["t"].toString();
    final String? exchange = json["e"] == null || json["e"].toString() == "null"
        ? null
        : json["e"].toString();
    final String? token = json["tk"] == null || json["tk"].toString() == "null"
        ? null
        : json["tk"].toString();
    final String? ltp = json["lp"] == null || json["lp"].toString() == "null"
        ? null
        : json["lp"].toString();
    final String? tradingSymbol =
        json["ts"] == null || json["ts"].toString() == "null"
            ? null
            : json["ts"].toString();
    final String? percentageChange =
        json["pc"] == null || json["pc"].toString() == "null"
            ? null
            : json["pc"].toString();
    final String? open = json["o"] == null || json["o"].toString() == "null"
        ? null
        : json["o"].toString();
    final String? high = json["h"] == null || json["h"].toString() == "null"
        ? null
        : json["h"].toString();
    final String? low = json["l"] == null || json["l"].toString() == "null"
        ? null
        : json["l"].toString();
    final String? close = json["c"] == null || json["c"].toString() == "null"
        ? null
        : json["c"].toString();
    final String? averageTradePrice =
        json["ap"] == null || json["ap"].toString() == "null"
            ? null
            : json["ap"].toString();
    final String? volume = json["v"] == null || json["v"].toString() == "null"
        ? null
        : json["v"].toString();
    final String? openInterest =
        json["oi"] == null || json["oi"].toString() == "null"
            ? null
            : json["oi"].toString();
    final String? bqty = json["bq1"] == null || json["bq1"].toString() == "null"
        ? null
        : json["bq1"].toString();
    final String? bPrice =
        json["bp1"] == null || json["bp1"].toString() == "null"
            ? null
            : json["bp1"].toString();
    final String? sPrice =
        json["sp1"] == null || json["sp1"].toString() == "null"
            ? null
            : json["sp1"].toString();
    final String? sQty = json["sq1"] == null || json["sq1"].toString() == "null"
        ? null
        : json["sq1"].toString();

    return TouchlineUpdateStream(
      t: task,
      e: exchange,
      tk: token,
      lp: ltp,
      pc: percentageChange,
      o: open,
      h: high,
      l: low,
      c: close,
      ap: averageTradePrice,
      v: volume,
      oi: openInterest,
      bq1: bqty,
      bp1: bPrice,
      sp1: sPrice,
      sq1: sQty,
      ts: tradingSymbol,
    );
  }

  Map<String, dynamic> toJson() => {
        "t": t,
        "e": e,
        "tk": tk,
        "lp": lp,
        "pc": pc,
        "o": o,
        "h": h,
        "l": l,
        "c": c,
        "ap": ap,
        "v": v,
      };
}
