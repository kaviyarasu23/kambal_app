import 'package:aliceblue/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';

import '../../../model/market_depth_model.dart';
import '../../../model/market_watch_list_model.dart';
import '../../../model/place_order_input_model.dart';
import '../../../util/sizer.dart';
import '../../market_depth/bottom_sheet_header.dart';
import '../../market_depth/buy_sell_button_bottom.dart';
import '../../market_depth/market_depth_screen.dart';
import '../../market_depth/view_chart.dart';

class WatchListBottomSheet extends ConsumerStatefulWidget {
  final Scrip data;
  final int index;
  const WatchListBottomSheet({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  ConsumerState<WatchListBottomSheet> createState() =>
      _WatchListBottomSheetState();
}

class _WatchListBottomSheetState extends ConsumerState<WatchListBottomSheet> {
  late Scrip data;
  double initialSize = 0;
  var child;
  late bool isDarkMode;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    initialSize = 335.0 / sizes.height;
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
                    backgroundColor:
                        isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                    body: Container(
                      color:
                          isDarkMode ? colors.kColorBlack : colors.kColorWhite,
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
                                  scrollDirection: Axis.vertical,
                                  controller: controller,
                                  physics: ClampingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  children: [
                                    BottomSheetHeader(
                                      data: BottomSheetInput(
                                        change: data.change ?? '0.00',
                                        exchange: data.ex,
                                        ltp: data.ltp ?? '0.00',
                                        pdc: data.pdc,
                                        perChange: data.perChange ?? '0.00',
                                        scripName: data.formattedInsName,
                                        token: data.token,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sizes.pad_16,
                                ),
                                child: BuySellButton(
                                  orderWindowArguments: OrderWindowArguments(
                                    token: data.token,
                                    exchange: data.ex,
                                    instrument: data.formattedInsName,
                                    ltp: data.ltp ?? '',
                                    type: 'buy',
                                  ),
                                  isBuySell: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: sizes.pad_6,
                                  horizontal: sizes.pad_24,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ViewChart(
                                      orderWindowArguments:
                                          OrderWindowArguments(
                                        exchange: data.ex,
                                        instrument: data.formattedInsName,
                                        token: data.token,
                                        ltp: data.ltp!,
                                        type: 'sell',
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        MoreInfoModelArgs args =
                                            MoreInfoModelArgs(
                                          change: data.change!,
                                          ltp: data.ltp!,
                                          percentageChange: data.perChange!,
                                          close: data.pdc,
                                          symbol: data.tradingSymbol,
                                          isFromDashBoard: false,
                                          scripName: data.formattedInsName,
                                          orderWindowArguments:
                                              OrderWindowArguments(
                                            exchange: data.ex,
                                            instrument: data.formattedInsName,
                                            token: data.token,
                                            ltp: data.ltp!,
                                            type: 'sell',
                                          ),
                                        );
                                        Navigator.pushNamed(
                                          context,
                                          Routes.moreInfo,
                                          arguments: args,
                                        );
                                      },
                                      child: Text(
                                        "More Details",
                                        style: textStyles.kTextTwelveW400
                                            .copyWith(color: colors.kColorBlue),
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
                                  ("marketDepth").tr(),
                                  style: textStyles.kTextTwelveW500.copyWith(
                                      color: isDarkMode
                                          ? colors.kColorWhite
                                          : colors.kColorBlack),
                                ),
                              ),
                              MarketDepth(
                                controller: controller,
                                dp: MDdata(
                                  ltp: data.ltp,
                                  lowrate: data.low,
                                  highrate: data.high,
                                  symbol: data.tradingSymbol,
                                  openrate: data.open,
                                  previouscloserate: data.pdc,
                                  token: data.token,
                                  exchg: data.ex,
                                  symbolName: data.formattedInsName,
                                ),
                              ),
                              Sizer.vertical32(),
                            ]))
                      ]),
                    )),
              ),
            );
          }
          return child;
        });
  }
}
