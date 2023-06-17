class DepthWSResponse {
  String? t;
  String? e;
  String? tk;
  String? pp;
  String? ls;
  String? ti;
  String? lp;
  String? pc;
  String? o;
  String? h;
  String? l;
  String? c;
  String? ap;
  String? v;
  String? ltq;
  String? ltt;
  String? tbq;
  String? tsq;
  String? bp1;
  String? bp2;
  String? bp3;
  String? bp4;
  String? bp5;
  String? sp1;
  String? sp2;
  String? sp3;
  String? sp4;
  String? sp5;
  String? bq1;
  String? bq2;
  String? bq3;
  String? bq4;
  String? bq5;
  String? sq1;
  String? sq2;
  String? sq3;
  String? sq4;
  String? sq5;
  String? bo1;
  String? bo2;
  String? bo3;
  String? bo4;
  String? bo5;
  String? so1;
  String? so2;
  String? so3;
  String? so4;
  String? so5;
  String? h52;
  String? l52;
  String? oi;
  String? lc;
  String? uc;
  String? ft;

  DepthWSResponse({
    this.ap,
    this.bo1,
    this.bo2,
    this.bo3,
    this.bo4,
    this.bo5,
    this.bp1,
    this.bp2,
    this.bp3,
    this.bp4,
    this.bp5,
    this.bq1,
    this.bq2,
    this.bq3,
    this.bq4,
    this.bq5,
    this.c,
    this.e,
    this.h,
    this.h52,
    this.l,
    this.l52,
    this.lp,
    this.ls,
    this.ltq,
    this.ltt,
    this.o,
    this.oi,
    this.pc,
    this.pp,
    this.so1,
    this.so2,
    this.so3,
    this.so4,
    this.so5,
    this.sp1,
    this.sp2,
    this.sp3,
    this.sp4,
    this.sp5,
    this.sq1,
    this.sq2,
    this.sq3,
    this.sq4,
    this.sq5,
    this.t,
    this.tbq,
    this.ti,
    this.tk,
    this.tsq,
    this.v,
    this.lc,
    this.uc,
    this.ft,
  });

  factory DepthWSResponse.fromJson(Map<String, dynamic> json) {
    final String? task = json["t"] == null || json["t"].toString() == "null"
        ? "0"
        : json["t"].toString();
    final String? exchange = json["e"] == null || json["e"].toString() == "null"
        ? "0"
        : json["e"].toString();
    final String? token = json["tk"] == null || json["tk"].toString() == "null"
        ? "0"
        : json["tk"].toString();
    final String? ltp = json["lp"] == null || json["lp"].toString() == "null"
        ? "0"
        : json["lp"].toString();
    final String? percentageChange =
        json["pc"] == null || json["pc"].toString() == "null"
            ? "0"
            : json["pc"].toString();
    final String? open = json["o"] == null || json["o"].toString() == "null"
        ? "0"
        : json["o"].toString();
    final String? high = json["h"] == null || json["h"].toString() == "null"
        ? "0"
        : json["h"].toString();
    final String? low = json["l"] == null || json["l"].toString() == "null"
        ? "0"
        : json["l"].toString();
    final String? close = json["c"] == null || json["c"].toString() == "null"
        ? "0"
        : json["c"].toString();
    final String? averageTradePrice =
        json["ap"] == null || json["ap"].toString() == "null"
            ? "0"
            : json["ap"].toString();
    final String? volume = json["v"] == null || json["v"].toString() == "null"
        ? "0"
        : json["v"].toString();
    final String? tiVal = json["lp"] == null || json["lp"].toString() == "null"
        ? "0"
        : json["lp"].toString();
    final String? bo1Val =
        json["bo1"] == null || json["bo1"].toString() == "null"
            ? "0"
            : json["bo1"].toString();
    final String? bo2Val =
        json["bo2"] == null || json["bo2"].toString() == "null"
            ? "0"
            : json["bo2"].toString();
    final String? bo3Val =
        json["bo3"] == null || json["bo3"].toString() == "null"
            ? "0"
            : json["bo3"].toString();
    final String? bo4Val =
        json["bo4"] == null || json["bo4"].toString() == "null"
            ? "0"
            : json["bo4"].toString();
    final String? bo5Val =
        json["bo5"] == null || json["bo5"].toString() == "null"
            ? "0"
            : json["bo5"].toString();
    final String? so1Val =
        json["so1"] == null || json["so1"].toString() == "null"
            ? "0"
            : json["so1"].toString();
    final String? so2Val =
        json["so2"] == null || json["so2"].toString() == "null"
            ? "0"
            : json["so2"].toString();
    final String? so3Val =
        json["so3"] == null || json["so3"].toString() == "null"
            ? "0"
            : json["so3"].toString();
    final String? so4Val =
        json["so4"] == null || json["so4"].toString() == "null"
            ? "0"
            : json["so4"].toString();
    final String? so5Val =
        json["so5"] == null || json["so5"].toString() == "null"
            ? "0"
            : json["so5"].toString();
    final String? bp1Val =
        json["bp1"] == null || json["bp1"].toString() == "null"
            ? "0"
            : json["bp1"].toString();
    final String? bp2Val =
        json["bp2"] == null || json["bp2"].toString() == "null"
            ? "0"
            : json["bp2"].toString();
    final String? bp3Val =
        json["bp3"] == null || json["bp3"].toString() == "null"
            ? "0"
            : json["bp3"].toString();
    final String? bp4Val =
        json["bp4"] == null || json["bp4"].toString() == "null"
            ? "0"
            : json["bp4"].toString();
    final String? bp5Val =
        json["bp5"] == null || json["bp5"].toString() == "null"
            ? "0"
            : json["bp5"].toString();

    final String? bq1Val =
        json["bq1"] == null || json["bq1"].toString() == "null"
            ? "0"
            : json["bq1"].toString();
    final String? bq2Val =
        json["bq2"] == null || json["bq2"].toString() == "null"
            ? "0"
            : json["bq2"].toString();
    final String? bq3Val =
        json["bq3"] == null || json["bq3"].toString() == "null"
            ? "0"
            : json["bq3"].toString();
    final String? bq4Val =
        json["bq4"] == null || json["bq4"].toString() == "null"
            ? "0"
            : json["bq4"].toString();
    final String? bq5Val =
        json["bq5"] == null || json["bq5"].toString() == "null"
            ? "0"
            : json["bq5"].toString();
    final String? lsVal = json["ls"] == null || json["ls"].toString() == "null"
        ? "0"
        : json["ls"].toString();
    final String? ltqVal =
        json["ltq"] == null || json["ltq"].toString() == "null"
            ? "0"
            : json["ltq"].toString();
    final String? lttVal =
        json["ltt"] == null || json["ltt"].toString() == "null"
            ? "0"
            : json["ltt"].toString();
    final String? sp1Val =
        json["sp1"] == null || json["sp1"].toString() == "null"
            ? "0"
            : json["sp1"].toString();
    final String? sp2Val =
        json["sp2"] == null || json["sp2"].toString() == "null"
            ? "0"
            : json["sp2"].toString();
    final String? sp3Val =
        json["sp3"] == null || json["sp3"].toString() == "null"
            ? "0"
            : json["sp3"].toString();
    final String? sp4Val =
        json["sp4"] == null || json["sp4"].toString() == "null"
            ? "0"
            : json["sp4"].toString();
    final String? sp5Val =
        json["sp5"] == null || json["sp5"].toString() == "null"
            ? "0"
            : json["sp5"].toString();
    final String? oiVal = json["oi"] == null || json["oi"].toString() == "null"
        ? "0"
        : json["oi"].toString();
    final String? ppVal = json["pp"] == null || json["pp"].toString() == "null"
        ? "0"
        : json["pp"].toString();

    final String? sq1Val =
        json["sq1"] == null || json["sq1"].toString() == "null"
            ? "0"
            : json["sq1"].toString();
    final String? sq2Val =
        json["sq2"] == null || json["sq2"].toString() == "null"
            ? "0"
            : json["sq2"].toString();
    final String? sq3Val =
        json["sq3"] == null || json["sq3"].toString() == "null"
            ? "0"
            : json["sq3"].toString();
    final String? sq4Val =
        json["sq4"] == null || json["sq4"].toString() == "null"
            ? "0"
            : json["sq4"].toString();
    final String? sq5Val =
        json["sq5"] == null || json["sq5"].toString() == "null"
            ? "0"
            : json["sq5"].toString();
    final String? h52Val =
        json["52h"] == null || json["52h"].toString() == "null"
            ? "0"
            : json["52h"].toString();
    final String? l52Val =
        json["52l"] == null || json["52l"].toString() == "null"
            ? "0"
            : json["52l"].toString();
    final String? tbqVal =
        json["tbq"] == null || json["tbq"].toString() == "null"
            ? "0"
            : json["tbq"].toString();
    final String? tsqVal =
        json["tsq"] == null || json["tsq"].toString() == "null"
            ? "0"
            : json["tsq"].toString();
    final String? lcVal = json["lc"] == null || json["lc"].toString() == "null"
        ? "0"
        : json["lc"].toString();
    final String? ucVal = json["uc"] == null || json["uc"].toString() == "null"
        ? "0"
        : json["uc"].toString();
    final String? ftVal = json["ft"] == null || json["ft"].toString() == "null"
        ? "0"
        : json["ft"].toString();

    return DepthWSResponse(
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
      ti: tiVal,
      bo1: bo1Val,
      bo2: bo2Val,
      bo3: bo3Val,
      bo4: bo4Val,
      bo5: bo5Val,
      so1: so1Val,
      so2: so2Val,
      so3: so3Val,
      so4: so4Val,
      so5: so5Val,
      bp1: bp1Val,
      bp2: bp2Val,
      bp3: bp3Val,
      bp4: bp4Val,
      bp5: bp5Val,
      bq1: bq1Val,
      bq2: bq2Val,
      bq3: bq3Val,
      bq4: bq4Val,
      bq5: bq5Val,
      ls: lsVal,
      ltq: ltqVal,
      ltt: lttVal,
      sp1: sp1Val,
      sp2: sp2Val,
      sp3: sp3Val,
      sp4: sp4Val,
      sp5: sp5Val,
      oi: oiVal,
      pp: ppVal,
      sq1: sq1Val,
      sq2: sq2Val,
      sq3: sq3Val,
      sq4: sq4Val,
      sq5: sq5Val,
      h52: h52Val,
      l52: l52Val,
      tbq: tbqVal,
      lc: lcVal,
      uc: ucVal,
      tsq: tsqVal,
      ft: ftVal,
    );
  }

  Map<String, dynamic> toJson() => {
        't': t,
        'e': e,
        'tk': tk,
        'lp': lp,
        'pc': pc,
        'o': o,
        'h': h,
        'l': l,
        'c': c,
        'ap': ap,
        'v': v,
        'ti': ti,
        'bo1': bo1,
        'bo2': bo2,
        'bo3': bo3,
        'bo4': bo4,
        'bo5': bo5,
        'so1': so1,
        'so2': so2,
        'so3': so3,
        'so4': so4,
        'so5': so5,
        'bp1': bp1,
        'bp2': bp2,
        'bp3': bp3,
        'bp4': bp4,
        'bp5': bp5,
        'bq1': bq1,
        'bq2': bq2,
        'bq3': bq3,
        'bq4': bq4,
        'bq5': bq5,
        'ls': ls,
        'ltq': ltq,
        'ltt': ltt,
        'sp1': sp1,
        'sp2': sp2,
        'sp3': sp3,
        'sp4': sp4,
        'sp5': sp5,
        'oi': oi,
        'pp': pp,
        'sq1': sq1,
        'sq2': sq2,
        'sq3': sq3,
        'sq4': sq4,
        'sq5': sq5,
        'h52': h52,
        'l52': l52,
        'tbq': tbq,
        'tsq': tsq,
        'lc': lc,
        'uc': uc,
        'ft': ft,
      };
}
