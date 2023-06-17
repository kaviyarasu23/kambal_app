import 'package:aliceblue/provider/market_depth_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/provider/websocket_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/market_watch_list_model.dart';
import '../../model/ws_df_feed_model.dart';
import '../../router/route_names.dart';
import '../../shared_widget/custom_long_button.dart';
import '../technical/technical_info.dart';
import 'info_screen.dart';
import 'market_depth_info.dart';
import 'more_info_view_model.dart';

class MoreInfoScreen extends ConsumerStatefulWidget {
  final MoreInfoModelArgs data;
  const MoreInfoScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _MoreInfoScreenState createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends ConsumerState<MoreInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late MoreInfoModelArgs data;
  String token = "";
  String exchange = "";

  @override
  void initState() {
    super.initState();
    data = widget.data;
    data.change =
        ref.read(marketDepthProvider).depthValue?.change ?? data.change;
    data.ltp = ref.read(marketDepthProvider).depthValue?.ltp ?? data.ltp;
    data.percentageChange =
        ref.read(marketDepthProvider).depthValue?.perChange ??
            data.percentageChange;
    data.close = ref.read(marketDepthProvider).depthValue?.previouscloserate ??
        data.close;
    token = data.orderWindowArguments!.token;
    exchange = data.orderWindowArguments!.exchange!;
    configureTabs();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      ref.read(moreInfoViewProvider).changeTabIndex(
            index: controller.index,
            context: context,
          );
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(moreInfoViewProvider).getSecurityInfoDetails(
            symbol: token,
            exchange: exchange,
            context: context,
          );
    });
  }

  configureTabs() {
    ref
        .read(moreInfoViewProvider)
        .setMoreInfoArgs(args: widget.data, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
      final moreInfoViewProvide = ref.watch(moreInfoViewProvider);
      final theme = ref.watch(themeProvider);
      return Scaffold(
        backgroundColor:
            theme.isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
        body: SafeArea(
          child: Stack(children: [
            Column(
              children: [
                MoreInfoHeader(
                  data: widget.data,
                  token: token,
                  exchange: exchange,
                ),
                TabBar(
                    controller: controller,
                    isScrollable: false,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: textStyles.kTextFourteenW400,
                    unselectedLabelColor: colors.kColorSubhead,
                    labelColor: colors.kColorBlue,
                    indicatorWeight: 3,
                    indicatorColor: colors.kColorBlue,
                    tabs: moreInfoViewProvide.getMoreInfoHeadList
                        .map((e) => Tab(
                              text: e,
                            ))
                        .toList()),
                Expanded(
                    child: TabBarView(
                  controller: controller,
                  children: [
                    Column(
                      children: [
                        Divider(
                          color: colors.kColorBlueLight,
                          height: 1,
                          thickness: 1,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            cacheExtent: double.maxFinite,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: [
                              MarketDepthInfo(
                                data: widget.data,
                              ),
                              Sizer.vertical64(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(children: [
                      Divider(
                        color: colors.kColorBlueLight,
                        height: 1,
                        thickness: 1,
                      ),
                      Expanded(
                          child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              children: [
                            Padding(
                              padding: EdgeInsets.all(sizes.pad_16,),
                              child: const Technical(),
                            ),
                            Sizer.vertical64(),
                          ]))
                    ]),
                    Column(
                      children: [
                        Divider(
                          color: colors.kColorBlueLight,
                          height: 1,
                          thickness: 1,
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: [
                              const InfoScreen(),
                              Sizer.vertical64(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
            moreInfoViewProvide.getIndex == 3
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(),
                    ],
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color: colors.kColorWhite,
                        child: BuySellButton(
                          data: data,
                        )),
                  ),
          ]),
        ),
      );
    });
  }
}

class MoreInfoHeader extends ConsumerWidget {
  final MoreInfoModelArgs data;
  final String token;
  final String exchange;
  const MoreInfoHeader({
    Key? key,
    required this.data,
    required this.token,
    required this.exchange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .dfUpdate
            .stream
            .where((event) => event.tk == token),
        builder: (_, AsyncSnapshot<DepthWSResponse> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == token) {
              data.ltp = snapshot.data!.lp == null ||
                      snapshot.data!.lp! == 'null' ||
                      snapshot.data!.lp!.isEmpty ||
                      snapshot.data!.lp == "0"
                  ? data.ltp
                  : snapshot.data!.lp!;
              data.percentageChange = snapshot.data!.pc == null ||
                      snapshot.data!.pc! == 'null' ||
                      snapshot.data!.pc! == '0'
                  ? data.percentageChange
                  : snapshot.data!.pc!;
              data.close = snapshot.data!.c == null ||
                      snapshot.data!.c! == 'null' ||
                      snapshot.data!.c! == '0'
                  ? data.close
                  : snapshot.data!.c!;
              data.change = (double.parse(data.ltp) - double.parse(data.close))
                  .toString();
            }
          }
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16, vertical: sizes.pad_6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: const Icon(Icons.arrow_back_ios_new_sharp),
                      onTap: () {
                        // if (exchange.toUpperCase() == 'NFO') {
                        //   ref
                        //       .read(helperProvider)
                        //       .requestWS(isSubscribe: false, context: context);
                        // }
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: sizes.pad_12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.scripName),
                        SizedBox(
                          height: sizes.pad_6,
                        ),
                        Row(
                          children: [
                            Text(exchange.toUpperCase(),
                                style: textStyles.kTextFourteenW400.copyWith(
                                    color: ref.read(themeProvider).isDarkMode
                                        ? colors.kColorWhite60
                                        : colors.kColorBlack60)),
                            Sizer.halfHorizontal(),
                            Text(
                                getFormatedNumValue(
                                  data.ltp,
                                  afterPoint:
                                      (exchange.toLowerCase() == 'cds' ||
                                              exchange.toLowerCase() == 'bcd')
                                          ? 4
                                          : 2,
                                  showSign: false,
                                ),
                                style: textStyles.kTextFourteenW400.copyWith(
                                  color: getFormatedNumValue(
                                            data.percentageChange,
                                            afterPoint: 2,
                                          ) ==
                                          "00.00"
                                      ? ref.read(themeProvider).isDarkMode
                                          ? colors.kColorWhite60
                                          : colors.kColorBlack60
                                      : isNumberNegative(data.percentageChange)
                                          ? colors.kColorRed
                                          : colors.kColorGreen,
                                )),
                            Sizer.halfHorizontal(),
                            Text(
                                getFormatedNumValue(
                                  data.change,
                                  afterPoint: 2,
                                  showSign: false,
                                ),
                                style: textStyles.kTextFourteenW400.copyWith(
                                    color: ref.read(themeProvider).isDarkMode
                                        ? colors.kColorWhite60
                                        : colors.kColorBlack60)),
                            Sizer.halfHorizontal(),
                            Text(
                                "(${getFormatedNumValue(
                                  data.percentageChange,
                                  afterPoint: 2,
                                  showSign: false,
                                )}%)",
                                style: textStyles.kTextFourteenW400.copyWith(
                                    color: ref.read(themeProvider).isDarkMode
                                        ? colors.kColorWhite60
                                        : colors.kColorBlack60))
                          ],
                        )
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.newAlert,
                        //   // arguments: ScripAlertInput(
                        //   //   isEdit: false,
                        //   //   change: data.change,
                        //   //   perChange: data.percentageChange,
                        //   //   symbol: data.symbol,
                        //   //   exch: exchange,
                        //   //   token: token,
                        //   //   value: data.ltp,
                        //   //   scripName: data.scripName,
                        //   // ),
                        // );
                        // ScripAlertInput input = ScripAlertInput(
                        //     exch: exchange,
                        //     token: token,
                        //     value: data.ltp,
                        //     scripName: data.scripName,
                        //     perChange: data.percentageChange,
                        //     change: data.change,
                        //     isEdit: false,
                        //     tradingSymbol: '',
                        //     );
                        // ref.read(alertListProvider).setData(input);
                      },
                      child: SvgPicture.asset(
                        assets.notificationIcon,
                        color: ref.read(themeProvider).isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorBlack,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class OptionChainBottom extends StatelessWidget {
  const OptionChainBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: colors.kColorBlue,
          padding: EdgeInsets.symmetric(vertical: sizes.pad_12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(assets.ohlcIndicatorImage),
              Sizer.horizontal(),
              Text(
                'Spot Price',
                style:
                    textStyles.kTextFourteenW400.copyWith(color: colors.kColorWhite),
              ),
              Sizer.halfHorizontal(),
              Text(
                '29,625.95',
                style:
                    textStyles.kTextFourteenW400.copyWith(color: colors.kColorWhite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuySellButton extends ConsumerWidget {
  final MoreInfoModelArgs data;
  const BuySellButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Container(
      color: theme.isDarkMode ? colors.kColorDarkthemeBg : colors.kColorWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizes.pad_20, vertical: sizes.pad_12),
        child: Row(
          children: [
            Expanded(
              child: CustomLongButton(
                  color: colors.kColorGreen,
                  borderRadius: 8,
                  label: "BUY",
                  onPress: () {
                    data.orderWindowArguments!.type = 'buy';
                    Navigator.popAndPushNamed(
                      context,
                      Routes.orderWindow,
                      arguments: data.orderWindowArguments!,
                    );
                  }),
            ),
            Sizer.horizontal(),
            Expanded(
              child: CustomLongButton(
                  color: colors.kColorRed,
                  borderRadius: 8,
                  label: "SELL",
                  onPress: () {
                    data.orderWindowArguments!.type = 'sell';
                    Navigator.popAndPushNamed(
                      context,
                      Routes.orderWindow,
                      arguments: data.orderWindowArguments!,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
