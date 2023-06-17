class MDdata {
  String? openinterest;
  String? trend;
  String? sQty3;
  String? sQty4;
  String? sQty5;
  String? sQty1;
  String? sQty2;
  String? bOrders2;
  String? highrate;
  String? bOrders1;
  String? sPrice1;
  String? sPrice2;
  String? sPrice3;
  String? tradingSymbol;
  String? bOrders5;
  String? triggerpercent;
  String? sPrice4;
  String? bOrders4;
  String? sPrice5;
  String? bOrders3;
  String? totalsellqty;
  String? lowercircuitlimit;
  String? volume;
  String? corporateaction;
  String? companyname;
  String? bPrice5;
  String? bPrice3;
  String? bPrice4;
  String? yearlylowprice;
  String? bPrice1;
  String? bPrice2;
  String? abschange;
  String? symbol;
  String? symbolName;
  String? ltp;
  String? openrate;
  String? lasttradedtime;
  String? bQty1;
  String? bQty2;
  String? bQty3;
  String? yearlyhighprice;
  String? sOrders5;
  String? sOrders4;
  String? sOrders3;
  String? value;
  String? sOrders2;
  String? sOrders1;
  String? spotprice;
  String? lasttradedqty;
  String? stat;
  String? previouscloserate;
  String? totalbuyqty;
  String? bQty4;
  String? bQty5;
  String? exchg;
  String? weightedavg;
  String? highercircuitlimit;
  String? series;
  String? perChange;
  String? lowrate;
  String? tickSize;
  String? lotSize;
  String? token;
  String? tickSizeDiv;
  String? fTime;
  String? expiry;
  String? change;
  int? afterPoint;

  MDdata({
    this.openinterest = "0",
    this.trend = "0",
    this.sQty3 = "0",
    this.sQty4 = "0",
    this.sQty5 = "0",
    this.sQty1 = "0",
    this.sQty2 = "0",
    this.bOrders2 = "0",
    this.highrate = "0",
    this.bOrders1 = "0",
    this.sPrice1 = "0",
    this.sPrice2 = "0",
    this.sPrice3 = "0",
    this.tradingSymbol = "0",
    this.bOrders5 = "0",
    this.triggerpercent = "0",
    this.sPrice4 = "0",
    this.bOrders4 = "0",
    this.sPrice5 = "0",
    this.bOrders3 = "0",
    this.totalsellqty = "0",
    this.lowercircuitlimit = "0",
    this.volume = "0",
    this.corporateaction = "0",
    this.companyname = "0",
    this.bPrice5 = "0",
    this.bPrice3 = "0",
    this.bPrice4 = "0",
    this.yearlylowprice = "0",
    this.bPrice1 = "0",
    this.bPrice2 = "0",
    this.abschange = "0",
    this.symbol = "0",
    this.symbolName = "0",
    this.ltp = "0",
    this.openrate = "0",
    this.lasttradedtime = "0",
    this.bQty1 = "0",
    this.bQty2 = "0",
    this.bQty3 = "0",
    this.yearlyhighprice = "0",
    this.sOrders5 = "0",
    this.sOrders4 = "0",
    this.sOrders3 = "0",
    this.value = "0",
    this.sOrders2 = "0",
    this.sOrders1 = "0",
    this.spotprice = "0",
    this.lasttradedqty = "0",
    this.stat = "0",
    this.previouscloserate = "0",
    this.totalbuyqty = "0",
    this.bQty4 = "0",
    this.bQty5 = "0",
    this.exchg = "0",
    this.weightedavg = "0",
    this.highercircuitlimit = "0",
    this.series = "0",
    this.perChange = "0",
    this.lotSize = "0",
    this.tickSize = "0",
    this.lowrate = "0",
    this.token = "0",
    this.tickSizeDiv = "0",
    this.fTime = "0",
    this.expiry = "",
    this.change = "0.00",
    this.afterPoint = 2,
  });

  factory MDdata.fromJson(Map<String, dynamic> json) {
    String tickSizeVal = "0.0";
    String lotSizeVal = "0";
    String tokenVal = "0";
    String tickSizeDivVal = "0";
    try {
      tickSizeVal = (json['tickSize'] ?? "0.0").toString();
    } catch (e) {
      tickSizeVal = "0.0";
    }
    try {
      lotSizeVal = (json['lotSize'] ?? "0").toString();
    } catch (e) {
      lotSizeVal = "0";
    }
    try {
      tokenVal = (json['token'] ?? "0").toString();
    } catch (e) {
      tokenVal = "0";
    }
    try {
      tickSizeDivVal = (json['tickSizeDiv'] ?? "0").toString();
    } catch (e) {
      tickSizeDivVal = "0";
    }
    int afterPointVal =
        (json['Exchg'] ?? "").toString().toLowerCase() == 'cds' ||
                (json['Exchg'] ?? "").toString().toLowerCase() == 'bcd'
            ? 4
            : 2;
    return MDdata(
      openinterest:
          (json['openinterest'] ?? '0').toString().replaceAll(",", ""),
      trend: (json['trend'] == null || json['trend'] == "null"
              ? '0'
              : json['trend'])
          .toString(),
      sQty3: (json['SQty3'] == null || json['SQty3'] == "null"
              ? '0'
              : json['SQty3'])
          .toString(),
      sQty4: (json['SQty4'] == null || json['SQty4'] == "null"
              ? '0'
              : json['SQty4'])
          .toString(),
      sQty5: (json['SQty5'] == null || json['SQty5'] == "null"
              ? '0'
              : json['SQty5'])
          .toString(),
      sQty1: (json['SQty1'] == null || json['SQty1'] == "null"
              ? '0'
              : json['SQty1'])
          .toString(),
      sQty2: (json['SQty2'] == null || json['SQty2'] == "null"
              ? '0'
              : json['SQty2'])
          .toString(),
      bOrders2: (json['BOrders2'] == null || json['BOrders2'] == "null"
              ? '0'
              : json['BOrders2'])
          .toString(),
      highrate: (json['highrate'] == null || json['highrate'] == "null"
              ? '0'
              : json['highrate'])
          .toString(),
      bOrders1: (json['BOrders1'] == null || json['BOrders1'] == "null"
              ? '0'
              : json['BOrders1'])
          .toString(),
      sPrice1: (json['SPrice1'] == null || json['SPrice1'] == "null"
              ? '0'
              : json['SPrice1'])
          .toString(),
      sPrice2: (json['SPrice2'] == null || json['SPrice2'] == "null"
              ? '0'
              : json['SPrice2'])
          .toString(),
      sPrice3: (json['SPrice3'] == null || json['SPrice3'] == "null"
              ? '0'
              : json['SPrice3'])
          .toString(),
      tradingSymbol:
          (json['TradingSymbol'] == null || json['TradingSymbol'] == "null"
                  ? '0'
                  : json['TradingSymbol'])
              .toString(),
      bOrders5: (json['BOrders5'] == null || json['BOrders5'] == "null"
              ? '0'
              : json['BOrders5'])
          .toString(),
      triggerpercent:
          (json['triggerpercent'] == null || json['triggerpercent'] == "null"
                  ? '0'
                  : json['triggerpercent'])
              .toString(),
      sPrice4: (json['SPrice4'] == null || json['SPrice4'] == "null"
              ? '0'
              : json['SPrice4'])
          .toString(),
      bOrders4: (json['BOrders4'] == null || json['BOrders4'] == "null"
              ? '0'
              : json['BOrders4'])
          .toString(),
      sPrice5: (json['SPrice5'] == null || json['SPrice5'] == "null"
              ? '0'
              : json['SPrice5'])
          .toString(),
      bOrders3: (json['BOrders3'] == null || json['BOrders3'] == "null"
              ? '0'
              : json['BOrders3'])
          .toString(),
      totalsellqty:
          (json['totalsellqty'] == null || json['totalsellqty'] == "null"
                  ? '0'
                  : json['totalsellqty'])
              .toString(),
      lowercircuitlimit: (json['lowercircuitlimit'] == null ||
                  json['lowercircuitlimit'] == "null"
              ? '0'
              : json['lowercircuitlimit'])
          .toString(),
      volume: (json['volume'] == null || json['volume'] == "null"
              ? '0'
              : json['volume'])
          .toString(),
      corporateaction:
          (json['corporateaction'] == null || json['corporateaction'] == "null"
                  ? '0'
                  : json['corporateaction'])
              .toString(),
      companyname: (json['companyname'] == null || json['companyname'] == "null"
              ? '0'
              : json['companyname'])
          .toString(),
      bPrice5: (json['BPrice5'] == null || json['BPrice5'] == "null"
              ? '0'
              : json['BPrice5'])
          .toString(),
      bPrice3: (json['BPrice3'] == null || json['BPrice3'] == "null"
              ? '0'
              : json['BPrice3'])
          .toString(),
      bPrice4: (json['BPrice4'] == null || json['BPrice4'] == "null"
              ? '0'
              : json['BPrice4'])
          .toString(),
      yearlylowprice:
          (json['yearlylowprice'] == null || json['yearlylowprice'] == 'null'
                  ? '0'
                  : json['yearlylowprice'])
              .toString(),
      bPrice1: (json['BPrice1'] == null || json['BPrice1'] == "null"
              ? '0'
              : json['BPrice1'])
          .toString(),
      bPrice2: (json['BPrice2'] == null || json['BPrice2'] == "null"
              ? '0'
              : json['BPrice2'])
          .toString(),
      abschange: (json['abschange'] == null || json['abschange'] == "null"
              ? '0'
              : json['abschange'])
          .toString(),
      symbol: (json['Symbol'] == null || json['Symbol'] == "null"
              ? '0'
              : json['Symbol'])
          .toString(),
      symbolName: (json['SymbolName'] == null || json['SymbolName'] == "null"
              ? '0'
              : json['SymbolName'])
          .toString(),
      ltp: (json['Ltp'] == null || json['Ltp'] == "null" ? '0' : json['Ltp'])
          .toString(),
      openrate: (json['openrate'] == null || json['openrate'] == "null"
              ? '0'
              : json['openrate'])
          .toString(),
      lasttradedtime:
          (json['lasttradedtime'] == null || json['lasttradedtime'] == "null"
                  ? '0'
                  : json['lasttradedtime'])
              .toString(),
      bQty1: (json['BQty1'] == null || json['BQty1'] == "null"
              ? '0'
              : json['BQty1'])
          .toString(),
      bQty2: (json['BQty2'] == null || json['BQty2'] == "null"
              ? '0'
              : json['BQty2'])
          .toString(),
      bQty3: (json['BQty3'] == null || json['BQty3'] == "null"
              ? '0'
              : json['BQty3'])
          .toString(),
      yearlyhighprice:
          (json['yearlyhighprice'] == null || json['yearlyhighprice'] == "null"
                  ? '0'
                  : json['yearlyhighprice'])
              .toString(),
      sOrders5: (json['SOrders5'] == null || json['SOrders5'] == "null"
              ? '0'
              : json['SOrders5'])
          .toString(),
      sOrders4: (json['SOrders4'] == null || json['SOrders4'] == "null"
              ? '0'
              : json['SOrders4'])
          .toString(),
      sOrders3: (json['SOrders3'] == null || json['SOrders3'] == "null"
              ? '0'
              : json['SOrders3'])
          .toString(),
      value: (json['value'] == null || json['value'] == "null"
              ? '0'
              : json['value'])
          .toString(),
      sOrders2: (json['SOrders2'] == null || json['SOrders2'] == "null"
              ? '0'
              : json['SOrders2'])
          .toString(),
      sOrders1: (json['SOrders1'] == null || json['SOrders1'] == "null"
              ? '0'
              : json['SOrders1'])
          .toString(),
      spotprice: (json['spotprice'] == null || json['spotprice'] == "null"
              ? '0'
              : json['spotprice'])
          .toString(),
      lasttradedqty:
          (json['lasttradedqty'] == null || json['lasttradedqty'] == "null"
                  ? '0'
                  : json['lasttradedqty'])
              .toString(),
      stat:
          (json['stat'] == null || json['stat'] == "null" ? '0' : json['stat'])
              .toString(),
      previouscloserate: (json['previouscloserate'] == null ||
                  json['previouscloserate'] == "null"
              ? '0'
              : json['previouscloserate'])
          .toString(),
      totalbuyqty: (json['totalbuyqty'] == null || json['totalbuyqty'] == "null"
              ? '0'
              : json['totalbuyqty'])
          .toString(),
      bQty4: (json['BQty4'] == null || json['BQty4'] == "null"
              ? '0'
              : json['BQty4'])
          .toString(),
      bQty5: (json['BQty5'] == null || json['BQty5'] == "null"
              ? '0'
              : json['BQty5'])
          .toString(),
      exchg: (json['Exchg'] == null || json['Exchg'] == "null"
              ? '0'
              : json['Exchg'])
          .toString(),
      weightedavg: (json['weightedavg'] == null || json['weightedavg'] == "null"
              ? '0'
              : json['weightedavg'])
          .toString(),
      highercircuitlimit: (json['highercircuitlimit'] == null ||
                  json['highercircuitlimit'] == "null"
              ? '0'
              : json['highercircuitlimit'])
          .toString(),
      series: (json['series'] == null || json['series'] == "null"
              ? '0'
              : json['series'])
          .toString(),
      perChange: (json['PerChange'] == null || json['PerChange'] == "null"
              ? '0'
              : json['PerChange'])
          .toString(),
      lowrate: (json['lowrate'] == null || json['lowrate'] == "null"
              ? '0'
              : json['lowrate'])
          .toString(),
      fTime: (json['ft'] == null || json['ft'] == "null" ? '0' : json['ft'])
          .toString(),
      lotSize: lotSizeVal,
      tickSize: tickSizeVal,
      token: tokenVal,
      tickSizeDiv: tickSizeDivVal,
      afterPoint: afterPointVal,
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String, dynamic>{};
    data['openinterest'] = openinterest;
    data['trend'] = trend;
    data['SQty3'] = sQty3;
    data['SQty4'] = sQty4;
    data['SQty5'] = sQty5;
    data['SQty1'] = sQty1;
    data['SQty2'] = sQty2;
    data['BOrders2'] = bOrders2;
    data['highrate'] = highrate;
    data['BOrders1'] = bOrders1;
    data['SPrice1'] = sPrice1;
    data['SPrice2'] = sPrice2;
    data['SPrice3'] = sPrice3;
    data['TradingSymbol'] = tradingSymbol;
    data['BOrders5'] = bOrders5;
    data['triggerpercent'] = triggerpercent;
    data['SPrice4'] = sPrice4;
    data['BOrders4'] = bOrders4;
    data['SPrice5'] = sPrice5;
    data['BOrders3'] = bOrders3;
    data['totalsellqty'] = totalsellqty;
    data['lowercircuitlimit'] = lowercircuitlimit;
    data['volume'] = volume;
    data['corporateaction'] = corporateaction;
    data['companyname'] = companyname;
    data['BPrice5'] = bPrice5;
    data['BPrice3'] = bPrice3;
    data['BPrice4'] = bPrice4;
    data['yearlylowprice'] = yearlylowprice;
    data['BPrice1'] = bPrice1;
    data['BPrice2'] = bPrice2;
    data['abschange'] = abschange;
    data['Symbol'] = symbol;
    data['SymbolName'] = symbolName;
    data['Ltp'] = ltp;
    data['openrate'] = openrate;
    data['lasttradedtime'] = lasttradedtime;
    data['BQty1'] = bQty1;
    data['BQty2'] = bQty2;
    data['BQty3'] = bQty3;
    data['yearlyhighprice'] = yearlyhighprice;
    data['SOrders5'] = sOrders5;
    data['SOrders4'] = sOrders4;
    data['SOrders3'] = sOrders3;
    data['value'] = value;
    data['SOrders2'] = sOrders2;
    data['SOrders1'] = sOrders1;
    data['spotprice'] = spotprice;
    data['lasttradedqty'] = lasttradedqty;
    data['stat'] = stat;
    data['previouscloserate'] = previouscloserate;
    data['totalbuyqty'] = totalbuyqty;
    data['BQty4'] = bQty4;
    data['BQty5'] = bQty5;
    data['Exchg'] = exchg;
    data['weightedavg'] = weightedavg;
    data['highercircuitlimit'] = highercircuitlimit;
    data['series'] = series;
    data['PerChange'] = perChange;
    data['lowrate'] = lowrate;
    return data;
  }

  Map<String, dynamic> toJsonChart() => {
        'o': openrate,
        'h': highrate,
        'l': lowrate,
        'c': previouscloserate,
        'v': volume,
        'lp': ltp,
        'ft': fTime,
        'tk': token,
      };
}


class BottomSheetInput {
  String scripName;
  String exchange;
  String token;
  String ltp;
  String? change;
  String pdc;
  String? perChange;
  String? transType;
  String? status;
  BottomSheetInput({
    this.change,
    required this.exchange,
    required this.ltp,
    this.perChange,
    required this.scripName,
    required this.token,
    required this.pdc,
    this.transType,
    this.status,
  });
}
