import 'dart:developer';

import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/holding_book_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../provider/websocket_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../../shared_widget/svg_icon_button.dart';
import '../../../util/functions.dart';
import '../../../util/sizer.dart';
import 'holdings_bottomsheet/holdings_bottom_sheet.dart';
import 'widgets/holdings_card.dart';
import 'widgets/holdings_filter_bottom_sheet.dart';

class HoldingsScreen extends ConsumerStatefulWidget {
  const HoldingsScreen({super.key});

  @override
  ConsumerState<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends ConsumerState<HoldingsScreen> {
  @override
  Widget build(BuildContext context) {
    final holdingData = ref.watch(portfolioProvider).holdings;
    final searchHold = ref.watch(portfolioProvider).isHoldingsSearchEnable;
    final searchHoldItem = ref.watch(portfolioProvider).holdingSearchItems;
    final isTextControllerNotEmpty =
        ref.watch(portfolioProvider).searchController.text.isNotEmpty;
    final holdFilter = ref.watch(portfolioProvider).filteredHoldItems;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: HoldingListView(
            data: searchHold && isTextControllerNotEmpty
                ? searchHoldItem
                : holdFilter.isNotEmpty
                    ? holdFilter
                    : holdingData,
          ))
        ],
      )),
    );
  }
}

class HoldingListView extends ConsumerStatefulWidget {
  final List<Holding> data;
  const HoldingListView({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<HoldingListView> createState() => _HoldingListViewState();
}

class _HoldingListViewState extends ConsumerState<HoldingListView> {
  late List<Holding> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  void didUpdateWidget(covariant HoldingListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (data != widget.data) {
      setState(() {
        data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final isFixedHeader = ref.watch(portfolioProvider).pref.isFixedHeader;
    final searchHold = ref.watch(portfolioProvider).isHoldingsSearchEnable;
    final isFilter = ref.watch(portfolioProvider).activeFilter.isNotEmpty;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(portfolioProvider).fetchHoldings(context: context);
      },
      child: Column(
        children: [
          Expanded(
            child: data.isEmpty
                ? ListView(
                    controller: isFixedHeader ? ScrollController() : null,
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: [
                      Visibility(
                          visible: searchHold,
                          child: const SearchScreenHoldings()),
                      NoData(
                        errorMsg: (searchHold || isFilter)
                            ? 'NO RESULTS'
                            : 'NO HOLDINGS',
                        isNoHoldings: (!searchHold && !isFilter),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: isFixedHeader ? ScrollController() : null,
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    cacheExtent: double.maxFinite,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0)
                            searchHold
                                ? const SearchScreenHoldings()
                                : const HeaderHoldings(),
                          if (index == 0)
                            Container(
                                color: isDarkMode
                                    ? colors.kColorBlack
                                    : colors.kColorWhite,
                                child: Visibility(
                                    visible: !searchHold,
                                    child: SortFilterHoldings())),
                          index == data.length
                              ? Sizer.vertical16()
                              : InkWell(
                                  onTap: () async {
                                    // ref
                                    //     .read(marketHelperProvider)
                                    //     .getContractInfo(
                                    //       context: context,
                                    //       exchange:
                                    //           data[index].symbol![0].exchange!,
                                    //       token: data[index].symbol![0].token!,
                                    //     );
                                    // if (await disableFocus(context: context)) {
                                    //   ref
                                    //       .read(marketHelperProvider)
                                    //       .getContractInfo(
                                    //         context: context,
                                    //         exchange:
                                    //             data[index].symbol![0].exchange ??
                                    //                 "",
                                    //         token: data[index].symbol![0].token ??
                                    //             "",
                                    //       );
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        builder: (_) => HoldingsBottomSheet(
                                              data: data[index],
                                            )).whenComplete(() {
                                      ref
                                          .read(websocketProvider)
                                          .establishConnection(
                                            channelInput:
                                                '${data[index].symbol![0].exchange}|${data[index].symbol![0].token}',
                                            task: 'ud',
                                          );
                                    });
                                    // }
                                  },
                                  child: Card(
                                    color: isDarkMode
                                        ? colors.kColorBlack
                                        : colors.kColorWhite,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: index == 0
                                          ? const Radius.circular(0)
                                          : Radius.zero,
                                      topRight: index == 0
                                          ? const Radius.circular(0)
                                          : Radius.zero,
                                      bottomLeft: index == data.length - 1
                                          ? const Radius.circular(30)
                                          : Radius.zero,
                                      bottomRight: index == data.length - 1
                                          ? const Radius.circular(30)
                                          : Radius.zero,
                                    )),
                                    margin: EdgeInsets.zero,
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        HoldingsCard(
                                          data: data[index],
                                          isDarkMode: isDarkMode,
                                        ),
                                        index == data.length - 1
                                            ? SizedBox()
                                            : Column(
                                                children: [
                                                  horizontalDividerLine(
                                                      isDarkMode),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      );
                    }),
          ),
        ],
      ),
    );
  }
}

class SearchScreenHoldings extends ConsumerWidget {
  const SearchScreenHoldings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(portfolioProvider).searchController;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: sizes.pad_8,
                horizontal: sizes.pad_12,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: sizes.width / 1.08,
                    child: CustomTextFormField(
                      borderRadius: 6,
                      prefix: InkWell(
                        onTap: () {
                          ref.read(portfolioProvider).changeSearchHoldings();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: SvgPicture.asset(
                            assets.searchIcon,
                            color: isDarkMode
                                ? colors.kColorBlue
                                : colors.kColorBlue,
                          ),
                        ),
                      ),
                      contentPaddingVertical: 10,
                      contentPadding: 10,
                      isAutofocus: true,
                      textInputFormatter: [],
                      controller: searchController,
                      style: textStyles.kTextFourteenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorGreyText
                              : colors.kColorBlack),
                      onChanged: (value) {
                        log(value.isEmpty.toString());

                        ref
                            .read(portfolioProvider)
                            .searchFilter(searchContent: value);
                      },
                      maxCount: 25,
                      hintText: "Search eg: HDFC Bank , tata",
                      hintStyle: textStyles.kTextFourteenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorBlack),
                      suffix: InkWell(
                        onTap: () async {
                          // await disableFocus(context: context);
                          await showModalBottomSheet(
                              context: context,
                              backgroundColor: isDarkMode
                                  ? colors.kColorAppbarDarkTheme
                                  : colors.kColorWhite,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                              builder: (context) {
                                return const SizedBox(
                                  height: 303,
                                  // child: HoldingFilterBottomSheet(),
                                );
                              });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 4, left: 8, right: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: isDarkMode
                                    ? colors.kColorBlueDarkBG
                                    : colors.kColorLightBlueBg,
                              ),
                              padding: EdgeInsets.all(
                                sizes.pad_8,
                              ),
                              child: SvgPicture.asset(
                                assets.filterIcon,
                                color: isDarkMode
                                    ? colors.kColorBlue
                                    : colors.kColorBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NoData extends ConsumerWidget {
  final String errorMsg;
  final bool isNoHoldings;
  const NoData({
    Key? key,
    required this.errorMsg,
    required this.isNoHoldings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Container(
      color: theme.isDarkMode
          ? colors.kOTPHeaderDarkThemeBlack
          : colors.kColorWhite,
      height: sizes.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isNoHoldings)
            Text(
              '$errorMsg',
              style: textStyles.kTextFourteenW400,
            ),
          if (isNoHoldings)
            SvgPicture.asset(
              assets.noPosHoldImage,
            ),
          if (isNoHoldings) Sizer.vertical48(),
          if (isNoHoldings)
            Text(
              "You have no Holdings yet.",
              style: textStyles.kTextSixteenW400.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode
                    ? colors.kColorWhite60
                    : colors.kColorBlack60,
              ),
            ),
          if (isNoHoldings)
            Padding(
              padding: EdgeInsets.all(sizes.pad_16),
              child: Text(
                'Start trading and your transactions will reflect here',
                textAlign: TextAlign.center,
                style: textStyles.kTextSixteenW400.copyWith(
                  color: theme.isDarkMode
                      ? colors.kColorWhite60
                      : colors.kColorBlack60,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class HeaderHoldings extends ConsumerStatefulWidget {
  const HeaderHoldings({Key? key}) : super(key: key);

  @override
  HeaderHoldingsState createState() => HeaderHoldingsState();
}

class HeaderHoldingsState extends ConsumerState<HeaderHoldings>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // final portfolio = ref.watch(portfolioProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final totalInvest = ref.watch(portfolioProvider).totalInvest;
    final totalCurrent = ref.watch(portfolioProvider).totalCurrent;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 50,
              color: isDarkMode
                  ? colors.kColorAppbarDarkTheme
                  : colors.kColorWhite,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
            ),
            Container(
              color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
              height: 20,
            ),
          ],
        ),
        Positioned(
            child: Column(
          children: [
            Sizer.half(),
            Card(
              color: isDarkMode
                  ? colors.kColorCardHeaderdarkBlack
                  : colors.kColorWhite,
              margin: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  // Sizer.qtr(),
                  Sizer.vertical10(),
                  IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizes.pad_8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ("investedValue").tr(),
                                  style: textStyles.kTextTwelveW400.copyWith(
                                    color: isDarkMode
                                        ? colors.kColorBottomWhiteTextDarkTheme
                                        : colors.kColorGreyText,
                                  ),
                                ),
                                Sizer.qtr(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Visibility(
                                        visible: isNumberNegative(
                                            totalInvest.toString()),
                                        child: Text(
                                          "-",
                                          style: textStyles.kTextFourteenW500
                                              .copyWith(
                                            color: isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorBlack,
                                          ),
                                        )),
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 13,
                                    ),
                                    Text(
                                      formatCurrencyStandard(
                                        value: totalInvest.toStringAsFixed(2),
                                        isShowSign: false,
                                      ),
                                      style:
                                          textStyles.kTextSixteenW500.copyWith(
                                        color: isDarkMode
                                            ? colors.kColorWhite
                                            : colors.kColorBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // verticalDividerLine(isDarkMode),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  ("currentValue").tr(),
                                  style: textStyles.kTextTwelveW400.copyWith(
                                    color: isDarkMode
                                        ? colors.kColorBottomWhiteTextDarkTheme
                                        : colors.kColorGreyText,
                                  ),
                                ),
                                Sizer.qtr(),
                                TotalCurrentValue(
                                  totalCurrent: totalCurrent,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Sizer.vertical10(),
                  horizontalDividerLine(isDarkMode),
                  Sizer.vertical10(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizes.pad_8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              ("netPnl").tr(),
                              style: textStyles.kTextSixteenW500.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [NetPnl(), TotalPnlPercentageValue()],
                        ),
                      ],
                    ),
                  ),

                  Sizer.vertical10(),
                ]),
              ),
            ),
          ],
        )),
      ],
    );
  }
}

// Total Current

class TotalCurrentValue extends ConsumerWidget {
  final double totalCurrent;
  const TotalCurrentValue({
    Key? key,
    required this.totalCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return StreamBuilder(
        stream: ref.read(websocketProvider).holdingsTotalCurrent.stream,
        initialData: ref.read(websocketProvider).totalCurrent == 0.0
            ? ref.read(portfolioProvider).totalCurrent
            : ref.read(websocketProvider).totalCurrent,
        builder: (_, AsyncSnapshot<double> snapshotData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: isNumberNegative(snapshotData.data!.toString()),
                  child: Text(
                    "-",
                    style: textStyles.kTextSixteenW500.copyWith(
                      color:
                          isDarkMode ? colors.kColorWhite : colors.kColorBlack,
                    ),
                  )),
              // Icon(
              //   Icons.currency_rupee,
              //   size: 13,
              // ),
              Text(
                formatCurrencyStandard(
                  value: "${snapshotData.data!.toStringAsFixed(2)}",
                  isShowSign: false,
                ),
                style: textStyles.kTextSixteenW500.copyWith(
                  color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
                ),
              ),
            ],
          );
        });
  }
}

// Net Pnl

class NetPnl extends ConsumerWidget {
  const NetPnl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).holdingsTotalPnl.stream,
        initialData: ref.read(websocketProvider).totalPnlHold == 0.0
            ? ref.read(portfolioProvider).netPnl
            : ref.read(websocketProvider).totalPnlHold,
        builder: (_, AsyncSnapshot<double> snapshotData) {
          log("PNL CHECK HOLS ::: ${snapshotData.data!}");
          return Row(
            children: [
              Visibility(
                  visible: isNumberNegative(snapshotData.data!.toString()),
                  child: Text(
                    "-",
                    style: textStyles.kTextFourteenW500.copyWith(
                      color: colors.kColorRed,
                    ),
                  )),
              // Icon(
              //   Icons.currency_rupee,
              //   size: 16,
              //   color: isNumberNegative(snapshotData.data!.toStringAsFixed(2))
              //       ? colors.kColorRed
              //       : colors.kColorGreen,
              // ),
              Text(
                "${formatCurrencyStandard(
                  value: snapshotData.data!.toStringAsFixed(2),
                  isShowSign: false,
                )}",
                style: textStyles.kTextSixteenW500.copyWith(
                  color: isNumberNegative(
                    snapshotData.data!.toStringAsFixed(2),
                  )
                      ? colors.kColorRed
                      : colors.kColorGreen,
                ),
              ),
            ],
          );
        });
  }
}

class TotalPnlPercentageValue extends ConsumerWidget {
  const TotalPnlPercentageValue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).holdingsTotalPnlPercentage.stream,
        builder: (_, AsyncSnapshot<double> snapshotData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Sizer.horizontal(),
              Text(
                "${checkIsInfOrNullOrNan(value: snapshotData.data.toString()) ? ref.read(portfolioProvider).netPnlPerChange.toStringAsFixed(2) : snapshotData.data!.toStringAsFixed(2)}%",
                style: textStyles.kTextEightW500.copyWith(
                    color: (snapshotData.data == null
                                ? ref
                                    .read(portfolioProvider)
                                    .netPnlPerChange
                                    .toStringAsFixed(2)
                                : snapshotData.data!.toStringAsFixed(2))
                            .startsWith("-")
                        ? colors.kColorRed
                        : colors.kColorGreen,
                    letterSpacing: 0.3),
              ),
            ],
          );
        });
  }
}
// Day PNL

class DayPnl extends ConsumerStatefulWidget {
  final double dayPnl;
  const DayPnl({
    Key? key,
    required this.dayPnl,
  }) : super(key: key);

  @override
  ConsumerState<DayPnl> createState() => _DayPnlState();
}

class _DayPnlState extends ConsumerState<DayPnl> {
  late double dayPnl;

  @override
  void initState() {
    super.initState();
    dayPnl = widget.dayPnl;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).holdingsTotalTodayPnl.stream,
        initialData: ref.read(websocketProvider).totalTodayPnlHold == 0.0
            ? ref.read(portfolioProvider).dayPnl
            : ref.read(websocketProvider).totalTodayPnlHold,
        builder: (_, AsyncSnapshot<double> snapshotData) {
          if (snapshotData.hasData) {
            dayPnl = snapshotData.data != null ? snapshotData.data! : dayPnl;
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible: isNumberNegative("${snapshotData.data}"),
                  child: Text(
                    '-',
                    style: textStyles.kTextThirteenW400.copyWith(
                      color: colors.kColorRed,
                    ),
                  )),
              Icon(
                Icons.currency_rupee,
                size: 13,
                color: isNumberNegative("${snapshotData.data}")
                    ? colors.kColorRed
                    : colors.kColorGreen,
              ),
              Text(
                "${formatCurrencyStandard(
                  value: dayPnl.toStringAsFixed(2),
                  isShowSign: false,
                )} ",
                style: textStyles.kTextThirteenW400.copyWith(
                  color: isNumberNegative(
                    snapshotData.data != null
                        ? snapshotData.data!.toStringAsFixed(2)
                        : dayPnl.toStringAsFixed(2),
                  )
                      ? colors.kColorRed
                      : colors.kColorGreen,
                ),
              ),
            ],
          );
        });
  }
}

// Today's PNL Percentage

class TodayPnlPerChange extends ConsumerStatefulWidget {
  final double todaysPnlPercentage;
  const TodayPnlPerChange({
    Key? key,
    required this.todaysPnlPercentage,
  }) : super(key: key);

  @override
  ConsumerState<TodayPnlPerChange> createState() => _TodayPnlPerChangeState();
}

class _TodayPnlPerChangeState extends ConsumerState<TodayPnlPerChange> {
  late double todaysPnlPercentage;

  @override
  void initState() {
    super.initState();
    todaysPnlPercentage = widget.todaysPnlPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            ref.read(websocketProvider).holdingsTotalTodayPnlPercentage.stream,
        initialData:
            ref.read(websocketProvider).totalTodayPnlPercentageHold == 0.0
                ? ref.read(portfolioProvider).dayPnlPerChange
                : ref.read(websocketProvider).totalTodayPnlPercentageHold,
        builder: (_, AsyncSnapshot<double> snapshotData) {
          if (snapshotData.hasData) {
            todaysPnlPercentage = snapshotData.data != null
                ? snapshotData.data!
                : todaysPnlPercentage;
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "(${formatCurrencyStandard(
                  value: todaysPnlPercentage.toStringAsFixed(2),
                  isShowSign: true,
                )}%)",
                style: textStyles.kTextThirteenW400.copyWith(
                  color: isNumberNegative(
                    snapshotData.data != null
                        ? snapshotData.data!.toStringAsFixed(2)
                        : todaysPnlPercentage.toStringAsFixed(2),
                  )
                      ? colors.kColorRed
                      : colors.kColorGreen,
                ),
              ),
            ],
          );
        });
  }
}

class SortFilterHoldings extends ConsumerWidget {
  const SortFilterHoldings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: isDarkMode
                              ? colors.kColorAppbarDarkTheme
                              : colors.kColorWhite,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          builder: (context) {
                            return HoldingFilterBottomSheet();
                          });
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: sizes.pad_8,
                                bottom: sizes.pad_8,
                                left: sizes.pad_16,
                                right: sizes.pad_8,
                              ),
                              child: SvgPicture.asset(
                                assets.filterIcon,
                                color: colors.kColorBlue,
                              ),
                            ),
                            Visibility(
                              visible: ref
                                  .read(portfolioProvider)
                                  .validateFilterIsActive(),
                              child: Positioned(
                                right: 3,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: colors.kColorRed,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 1,
                                    minHeight: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ('filter').tr(),
                          style: textStyles.kTextFourteenW400.copyWith(
                              fontSize: sizes.text_12,
                              color: colors.kColorBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SvgIconButton(
                onPress: () {
                  ref.read(portfolioProvider).changeSearchHoldings();
                },
                assetLink: assets.searchIcon,
                color: colors.kColorBlue,
                padding: EdgeInsets.only(
                  top: sizes.pad_8,
                  bottom: sizes.pad_8,
                  left: sizes.pad_16,
                  right: sizes.pad_8,
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(portfolioProvider).changeSearchHoldings();
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    right: sizes.pad_16,
                  ),
                  child: Text(
                    ('search').tr(),
                    style: textStyles.kTextFourteenW400.copyWith(
                        fontSize: sizes.text_12, color: colors.kColorBlue),
                  ),
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     AuthorizeHoldings(),
          //   ],
          // )
        ]),
        horizontalDividerLine(isDarkMode)
      ],
    );
  }
}
