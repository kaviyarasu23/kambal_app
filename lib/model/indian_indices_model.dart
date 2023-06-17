class IndianIndices {
  String exchange;
  String token;
  String scripName;
  String ltp;
  String pdc;
  String change;
  String perChange;
  String open;
  String high;
  String low;
  String symbol;
  String? segment;
  IndianIndices({
    required this.exchange,
    required this.token,
    required this.scripName,
    required this.symbol,
    this.segment,
    this.ltp = "0.00",
    this.pdc = "0.00",
    this.change = "0.00",
    this.perChange = "0.00",
    this.high = "0.00",
    this.low = "0.00",
    this.open = "0.00",
  });
}

List<IndianIndices> spotIndicesDefault = [
  IndianIndices(
    symbol: "",
    exchange: 'NSE',
    scripName: 'NIFTY 50',
    token: '26000',
    segment: "NSE",
  ),
  IndianIndices(
    symbol: "",
    exchange: 'NSE',
    scripName: 'NIFTY BANK',
    token: '26009',
    segment: "NSE",
  )
];
