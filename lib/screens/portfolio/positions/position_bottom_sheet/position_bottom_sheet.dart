import 'package:aliceblue/model/position_book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/market_depth_model.dart';
import '../../../../model/place_order_input_model.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../res/res.dart';
import '../../../../util/sizer.dart';
import '../../../market_depth/bottom_sheet_header.dart';
import '../../../market_depth/buy_sell_button_bottom.dart';
import '../../../market_depth/market_depth_screen.dart';
import '../../../market_depth/view_chart.dart';

class PositionsBottomSheet extends ConsumerStatefulWidget {
  final PositionBookInfoResult data;
  const PositionsBottomSheet({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<PositionsBottomSheet> createState() =>
      _PositionsbottomSheetState();
}

class _PositionsbottomSheetState extends ConsumerState<PositionsBottomSheet> {
  late PositionBookInfoResult data;
  double initialSize = 0;
  var child;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    initialSize = 335.0 / sizes.height;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;

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
                                          exchange: data.exchange!,
                                          ltp: data.ltp!,
                                          pdc: data.pdc!.isEmpty
                                              ? data.ltp ?? '0.00'
                                              : data.pdc!,
                                          scripName: data.displayName!,
                                          token: '${data.token}',
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
                                widget.data.netQty != "0"
                                    ? BuySellButton(
                                        orderWindowArguments:
                                            OrderWindowArguments(
                                          token: widget.data.token!,
                                          exchange: data.exchange,
                                          instrument: data.displayName,
                                          ltp: data.ltp!,
                                          type: 'buy',
                                        ),
                                        isBuySell: data.sellQty == "0",
                                        isAddExit: data.sellQty != "0"
                                            ? 'addPositions'
                                            : '',
                                        activePosSetClick: () {
                                          // ref
                                          //     .read(positionProvider)
                                          //     .setActivePosition(data);
                                        },
                                      )
                                    : SizedBox(),
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
                                        exchange: data.exchange,
                                        instrument: data.tradingsymbol,
                                        token: data.token!,
                                        ltp: data.ltp!,
                                        type: 'sell',
                                      )),
                                      InkWell(
                                        onTap: () {
                                          // MoreInfoModelArgs args =
                                          //     MoreInfoModelArgs(
                                          //   change: data.change,
                                          //   ltp: data.ltp!,
                                          //   percentageChange: data.perChange,
                                          //   close: "0.00",
                                          //   symbol: data.tradingsymbol!,
                                          //   isFromDashBoard: false,
                                          //   scripName: data.tradingsymbol!,
                                          //   orderWindowArguments:
                                          //       OrderWindowArguments(
                                          //     exchange: data.exchange,
                                          //     instrument: data.tradingsymbol,
                                          //     token: data.token!,
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
                                    token: '${data.token}',
                                    exchg: '${data.exchange}',
                                    ltp: '${data.ltp}',
                                    symbol: '${data.tradingsymbol}',
                                    symbolName: '${data.displayName}',
                                    change: data.change,
                                    perChange: data.perChange,
                                    previouscloserate: data.pdc,
                                    openrate: data.open,
                                    lowrate: data.open,
                                    highrate: data.high,
                                  ),
                                  positionsData: data,
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