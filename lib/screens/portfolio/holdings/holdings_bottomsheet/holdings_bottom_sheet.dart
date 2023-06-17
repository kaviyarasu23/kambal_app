import 'package:aliceblue/screens/market_depth/view_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';

import '../../../../model/holding_book_model.dart';
import '../../../../model/market_depth_model.dart';
import '../../../../model/place_order_input_model.dart';
import '../../../../util/functions.dart';
import '../../../../util/sizer.dart';
import '../../../market_depth/bottom_sheet_header.dart';
import '../../../market_depth/buy_sell_button_bottom.dart';
import '../../../market_depth/market_depth_screen.dart';

class HoldingsBottomSheet extends ConsumerStatefulWidget {
  final Holding data;
  const HoldingsBottomSheet({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<HoldingsBottomSheet> createState() =>
      _HoldingsBottomSheetState();
}

class _HoldingsBottomSheetState extends ConsumerState<HoldingsBottomSheet> {
  late Holding data;
  double initialSize = 0;
  var child;
  late bool isDarkMode;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    initialSize = 380 / sizes.height;
    isDarkMode = ref.read(themeProvider).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: initialSize,
        minChildSize: 0.25,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) {
          if (child == null) {
            child = ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: SafeArea(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor:
                        isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                    body: Container(
                        color: isDarkMode
                            ? colors.kColorBlack
                            : colors.kColorWhite,
                        child: Column(children: [
                          Container(
                            color: isDarkMode
                                ? colors.kColorAppbarDarkTheme
                                : colors.kColorWhite,
                            child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: ListView(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    controller: controller,
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      BottomSheetHeader(
                                        data: BottomSheetInput(
                                          change: data.change!,
                                          exchange: data.symbol!.isEmpty
                                              ? 'NSE'
                                              : data.symbol![0].exchange!,
                                          ltp: data.symbol![0].ltp!,
                                          pdc: data.symbol![0].pdc!,
                                          perChange: data.perChange!,
                                          scripName: data.symbol!.isEmpty
                                              ? ''
                                              : data.symbol![0].tradingSymbol!,
                                          token: data.symbol![0].token!,
                                        ),
                                      ),
                                    ])),
                          ),
                          Expanded(
                              child: ListView(
                                  controller: controller,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  children: [
                                Sizer.vertical24(),
                                BuySellButton(
                                  orderWindowArguments: OrderWindowArguments(
                                    token: "${data.symbol![0].token}",
                                    ltp: data.symbol![0].ltp ?? "0.00",
                                    exchange: data.symbol![0].exchange,
                                    instrument: data.symbol![0].tradingSymbol,
                                    type: 'buy',
                                  ),
                                  isBuySell: data.netQty == "0",
                                  isAddExit:
                                      data.netQty != "0" ? 'addHoldings' : "",
                                  activeHoldSetClick: () {
                                    // ref
                                    //     .read(holdingsProvider)
                                    //     .setActiveHoldings(data);
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: sizes.pad_6,
                                      horizontal: sizes.pad_24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ViewChart(
                                        orderWindowArguments:
                                            OrderWindowArguments(
                                          exchange: data.symbol![0].exchange,
                                          instrument:
                                              data.symbol![0].tradingSymbol,
                                          token: data.symbol![0].token!,
                                          ltp: data.symbol![0].ltp!,
                                          type: 'sell',
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // MoreInfoModelArgs args =
                                          //     MoreInfoModelArgs(
                                          //   change: data.change!,
                                          //   ltp: data.ltp!,
                                          //   percentageChange: data.perChange!,
                                          //   close: "0.00",
                                          //   symbol:
                                          //       data.symbol![0].tradingSymbol!,
                                          //   isFromDashBoard: false,
                                          //   scripName:
                                          //       data.symbol![0].tradingSymbol!,
                                          //   orderWindowArguments:
                                          //       OrderWindowArguments(
                                          //     exchange:
                                          //         data.symbol![0].exchange,
                                          //     instrument:
                                          //         data.symbol![0].tradingSymbol,
                                          //     token: data.symbol![0].token!,
                                          //     ltp: data.ltp!,
                                          //     type: 'sell',
                                          //   ),
                                          // );
                                          // Navigator.pushNamed(
                                          //   context,
                                          //   Routes.moreInfo,
                                          //   arguments: args,
                                          // );
                                        },
                                        child: Text(
                                          "More Details",
                                          style: textStyles.kTextTwelveW400.copyWith(
                                              color: colors.kColorBlue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Sizer.vertical16(),
                                HoldingsExtraInfo(
                                  data: data,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sizes.pad_16,
                                      vertical: sizes.pad_16),
                                  child: Divider(
                                    height: 2,
                                    color: colors.kColorBlack.withOpacity(0.2),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: sizes.pad_16,
                                  ),
                                  child: Text(
                                    "Market Depth",
                                    style: textStyles.kTextTwelveW500
                                        .copyWith(
                                            color: isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorBlack),
                                  ),
                                ),
                                MarketDepth(
                                  controller: controller,
                                  dp: MDdata(
                                    exchg: data.symbol![0].exchange,
                                    token: data.symbol![0].token,
                                    ltp: data.symbol![0].ltp,
                                    perChange: data.perChange,
                                    symbolName: data.symbol![0].tradingSymbol,
                                    previouscloserate: data.symbol![0].pdc,
                                    openrate: data.symbol![0].open,
                                    highrate: data.symbol![0].high,
                                    lowrate: data.symbol![0].low,
                                  ),
                                ),
                                Sizer.vertical32(),
                              ]))
                        ])),
                  ),
                ));
          }
          return child;
        });
  }
}

// Holdings Extra Info

class HoldingsExtraInfo extends StatelessWidget {
  final Holding data;
  const HoldingsExtraInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DepthInfo(
          title: "Qty",
          value: data.netQty!,
          isBg: true,
        ),
        DepthInfo(
          title: "Buy Avg.",
          value: data.buyPrice!,
        ),
        DepthInfo(
          title: "Invested Value",
          value: (double.parse(data.netQty ?? '1') *
                  double.parse(data.buyPrice ?? '0'))
              .toStringAsFixed(2),
          isBg: true,
        ),
        DepthInfo(
          title: "Current Value",
          value:
              (double.parse(data.netQty ?? '1') * double.parse(data.symbol![0].ltp ?? '0'))
                  .toStringAsFixed(2),
        ),
        DepthInfo(
          title: "Day's P&L",
          value: getFormatedNumValue(
            data.dayPnl!,
            afterPoint: 2,
          ),
          isBg: true,
        ),
        DepthInfo(
          title: "Net P&L",
          value: getFormatedNumValue(
            data.netPnl!,
            afterPoint: 2,
          ),
        ),
      ],
    );
  }
}
