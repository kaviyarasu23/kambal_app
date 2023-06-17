import 'package:aliceblue/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../model/market_depth_model.dart';
import '../../../../model/market_watch_list_model.dart';
import '../../../../model/place_order_input_model.dart';
import '../../../../model/search_scrip_data.dart';
import '../../../../res/res.dart';
import '../../../../util/sizer.dart';
import '../../../market_depth/bottom_sheet_header.dart';
import '../../../market_depth/buy_sell_button_bottom.dart';
import '../../../market_depth/market_depth_screen.dart';

class SearchBottomSheet extends ConsumerStatefulWidget {
  final SearchScripData data;
  const SearchBottomSheet({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends ConsumerState<SearchBottomSheet> {
  late SearchScripData data;
  late Scrip scripData;
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
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SafeArea(
                child: Scaffold(
                  bottomNavigationBar: BuySellButton(
                    isBuySell: true,
                    orderWindowArguments: OrderWindowArguments(
                      token: data.token!,
                      exchange: data.exch,
                      instrument: data.formatedInstrumentName,
                      ltp: data.ltp ?? '0.00',
                      type: 'buy',
                    ),
                  ),
                  body: Container(
                    color: isDarkMode
                        ? colors.kColorDarkthemeBg
                        : colors.kColorWhite,
                    child: Column(
                      children: [
                        Container(
                          color: isDarkMode
                              ? colors.kColorBottomHeaderDark
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
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    BottomSheetHeader(
                                      data: BottomSheetInput(
                                        change: data.change ?? '0.00',
                                        exchange: data.exch!,
                                        ltp: data.ltp!,
                                        pdc: data.close!,
                                        perChange:
                                            data.percentageChange ?? '0.00',
                                        scripName: data.formatedInstrumentName!,
                                        token: data.token!,
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
                                    vertical: sizes.pad_6,
                                    horizontal: sizes.pad_24,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // final WebViewInput webViewInput =
                                          //     WebViewInput(
                                          //         title: 'CHART',
                                          //         isDarkMode: isDarkMode,
                                          //         url:
                                          //             "${ref.read(webViewProvider).generateChartUrl(
                                          //                   tradingSymbol:
                                          //                       data.symbol!,
                                          //                   token: data.token!,
                                          //                   exchange:
                                          //                       data.exch!,
                                          //                   ltp: data.ltp!,
                                          //                 )}",
                                          //         orderWidArgs:
                                          //             OrderWindowArguments(
                                          //           exchange: data.exch,
                                          //           instrument: data.symbol,
                                          //           token: data.token!,
                                          //           ltp: data.ltp!,
                                          //           type: 'sell',
                                          //         ));

                                          // Navigator.pushNamed(
                                          //   context,
                                          //   Routes.webView,
                                          //   arguments: webViewInput,
                                          // );
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              assets.chartIcon,
                                              color: colors.kColorBlue,
                                            ),
                                            Sizer.qtrHorizontal(),
                                            Text("View Chart",
                                                style: textStyles.kTextTwelveW400
                                                    .copyWith(
                                                  color: colors.kColorBlue,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Sizer.horizontal(),
                                      InkWell(
                                        onTap: () {
                                          MoreInfoModelArgs args =
                                              MoreInfoModelArgs(
                                            change: data.change!,
                                            ltp: data.ltp!,
                                            percentageChange:
                                                data.percentageChange!,
                                            close: "0.00",
                                            symbol: data.symbol!,
                                            isFromDashBoard: false,
                                            scripName: data.symbol!,
                                            orderWindowArguments:
                                                OrderWindowArguments(
                                              exchange: data.exch,
                                              instrument: data.symbol,
                                              token: data.token!,
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
                                          style: textStyles.kTextTwelveW400.copyWith(
                                              color: colors.kColorBlue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Sizer.vertical16(),
                                const HeadingWidget(
                                  title: 'Market Depth',
                                ),
                                MarketDepth(
                                  controller: controller,
                                  dp: MDdata(
                                    ltp: data.ltp,
                                    lowrate: data.low,
                                    highrate: data.high,
                                    openrate: data.open,
                                    previouscloserate: data.close,
                                    token: data.token,
                                    exchg: data.exch,
                                    symbolName: data.formatedInstrumentName,
                                  ),
                                ),
                                Sizer.vertical32(),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return child;
        });
  }
}
