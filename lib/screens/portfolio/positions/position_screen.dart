import 'dart:developer';

import 'package:aliceblue/model/position_book_model.dart';
import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../provider/theme_provider.dart';
import '../../../provider/websocket_provider.dart';
import '../../../res/res.dart';
import '../../../router/route_names.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../../shared_widget/svg_icon_button.dart';
import '../../../util/functions.dart';
import '../../../util/sizer.dart';
import 'position_bottom_sheet/position_bottom_sheet.dart';
import 'widgets/position_list_card.dart';
import 'widgets/shimmer_loading_positions.dart';

class PositionScreen extends ConsumerStatefulWidget {
  const PositionScreen({super.key});

  @override
  ConsumerState<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends ConsumerState<PositionScreen> {
  @override
  Widget build(BuildContext context) {
    final positionProv = ref.watch(portfolioProvider);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: positionProv.loading
                ? ShimmerLoadingPositions()
                : PositionListView(
                    data: positionProv.isPosSearchEnable &&
                            positionProv.searchController.text.isNotEmpty
                        ? positionProv.filteredSearchItem
                        : positionProv.sortFilteredPositionItems.isNotEmpty
                            ? positionProv.sortFilteredPositionItems
                            : positionProv.positions,
                  ),
          )
        ],
      )),
    );
  }
}

class PositionListView extends ConsumerStatefulWidget {
  final List<PositionBookInfoResult> data;
  const PositionListView({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<PositionListView> createState() => _PositionListViewState();
}

class _PositionListViewState extends ConsumerState<PositionListView> {
  late List<PositionBookInfoResult> data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  void didUpdateWidget(covariant PositionListView oldWidget) {
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
    final isSearchEnable = ref.watch(portfolioProvider).isPosSearchEnable;
    final isFiltered =
        ref.watch(portfolioProvider).filteredSearchItem.isNotEmpty;
    final isFixedHeader = ref.watch(portfolioProvider).pref.isFixedHeader;
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(portfolioProvider).fetchPositions(context: context);
      },
      child: Column(
        children: [
          Expanded(
            child: data.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: [
                      if (isSearchEnable) const PositionScripSearch(),
                      NoData(
                        isNoPosition: (!isSearchEnable && !isFiltered),
                        errorMsg: (isSearchEnable || isFiltered)
                            ? 'NO RESULTS'
                            : 'NO POSITIONS',
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: isFixedHeader ? ScrollController() : null,
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    itemCount: data.length < 1 ? data.length + 1 : data.length,
                    cacheExtent: double.maxFinite,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0) PositionHeaderCard(),
                          InkWell(
                            onLongPress: () {
                              if (data[index].netQty != '0') {
                                data[index].isSelected = true;
                                Navigator.pushNamed(
                                  context,
                                  Routes.positionSquareOff,
                                );
                              }
                            },
                            onTap: () async {
                              // if (await disableFocus(context: context)) {
                              // ref.read(marketHelperProvider).getContractInfo(
                              //       context: context,
                              //       exchange: data[index].exchange ?? "",
                              //       token: data[index].token ?? "",
                              //     );
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
                                      builder: (_) => PositionsBottomSheet(
                                          data: data[index]))
                                  .whenComplete(() {
                                ref.read(websocketProvider).establishConnection(
                                      channelInput:
                                          '${data[index].exchange}|${data[index].token}',
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
                                  PositionsCard(
                                    key: Key(index.toString()),
                                    data: data[index],
                                  ),
                                  index == data.length - 1
                                      ? const SizedBox()
                                      : horizontalDividerLine(isDarkMode)
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
          )
        ],
      ),
    );
  }
}

class PositionHeaderCard extends ConsumerWidget {
  const PositionHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearchEnable = ref.watch(portfolioProvider).isPosSearchEnable;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Column(children: [
      isSearchEnable ? const PositionScripSearch() : PositionTotalPnlCard(),
      IgnorePointer(
        ignoring: false,
        child: Container(
            color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
            child: Visibility(
              visible: !isSearchEnable,
              child: SortFilterPositions(
                key: UniqueKey(),
              ),
            )),
      ),
    ]);
  }
}

class SortFilterPositions extends ConsumerWidget {
  const SortFilterPositions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = ref.watch(portfolioProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final bool isNoData = positions.positions.isNotEmpty;
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () {
              isNoData
                  ? showModalBottomSheet(
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
                          height: 400,
                          // child: PositionFilterBottomSheet(),
                        );
                      })
                  : () {};
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Opacity(
                      opacity: isNoData ? 1 : 0.4,
                      child: Padding(
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
                    ),
                    if (positions.sortFilteredPositionItems.isNotEmpty ||
                            positions.filteredSearchItem.isNotEmpty
                        // ||
                        // positions.getIsDecending != 'default' ||
                        // positions.getIsUpperPnl != 'default' ||
                        // positions.getIsUpperPrice != 'default' ||
                        // positions.getIsExch != 'default'
                        )
                      Positioned(
                        right: 5,
                        top: 6,
                        child: Container(
                          padding: EdgeInsets.all(3),
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
                  ],
                ),
                Text(
                  ('filter').tr(),
                  style: textStyles.kTextFourteenW400.copyWith(
                    fontSize: sizes.text_12,
                    color: isNoData
                        ? colors.kColorBlue
                        : colors.kColorBlue.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              positions.changeSearchPositions();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgIconButton(
                  onPress: () {
                    positions.changeSearchPositions();
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
                Padding(
                  padding: EdgeInsets.only(
                    right: sizes.pad_16,
                  ),
                  child: Text(
                    ('search').tr(),
                    style: textStyles.kTextFourteenW400.copyWith(
                        fontSize: sizes.text_12, color: colors.kColorBlue),
                  ),
                ),
              ],
            ),
          ),
        ]),
        horizontalDividerLine(isDarkMode)
      ],
    );
  }
}

class PositionScripSearch extends ConsumerWidget {
  const PositionScripSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final positionSearch = ref.watch(portfolioProvider).searchController;
    return Container(
      color: isDarkMode
          ? colors.kColorAppbarDarkTheme
          : colors.kColorAppbarLightTheme,
      child: Column(children: [
        InkWell(
          onTap: () {},
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 20,
                    color: isDarkMode
                        ? colors.kColorAppbarDarkTheme
                        : colors.kColorAppbarLightTheme,
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: isDarkMode
                            ? colors.kColorBlack40
                            : colors.kColorWhite,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                  ),
                  Container(
                    color:
                        isDarkMode ? colors.kColorBlack40 : colors.kColorWhite,
                    height: 0,
                  ),
                ],
              ),
              Positioned(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: SizedBox(
                        width: sizes.width / 1.08,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? colors.kColorAppbarDarkTheme
                                : colors.kColorWhite,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: ref.read(themeProvider).isDarkMode
                                ? null
                                : const [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(221, 224, 255, 0.25),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, -1)),
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(221, 224, 255, 0.25),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(-1, 0)),
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(221, 224, 255, 0.25),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, 1)),
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(221, 224, 255, 0.25),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(1, 0)),
                                  ],
                          ),
                          child: CustomTextFormField(
                            borderRadius: 6,
                            contentPaddingVertical: 10,
                            prefix: InkWell(
                              onTap: () {
                                ref
                                    .read(portfolioProvider)
                                    .changeSearchPositions();
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
                            isAutofocus: true,
                            textInputFormatter: [],
                            controller: positionSearch,
                            style: textStyles.kTextFourteenW400.copyWith(
                                color: ref.read(themeProvider).isDarkMode
                                    ? colors.kColorGreyText
                                    : colors.kColorBlack),

                            maxCount: 25,
                            onChanged: (value) {
                              log(value.isEmpty.toString());
                              ref
                                  .read(portfolioProvider)
                                  .searchFilter(searchContent: value);
                            },
                            hintText: "Search eg: HDFC Bank , tata",
                            hintStyle: textStyles.kTextFourteenW400.copyWith(
                                color: ref.read(themeProvider).isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack),
                            // contentPadding:
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
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
                                          return const SizedBox(
                                            height: 355,
                                            // child: PositionFilterBottomSheet(),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                              ],
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
        ),
      ]),
    );
  }
}

class PositionTotalPnlCard extends ConsumerWidget {
  const PositionTotalPnlCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
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
            // Container(
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
            //   ),
            // ),
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
              elevation: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ('totalPnl').tr(),
                        style: textStyles.kTextElevenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorBottomWhiteTextDarkTheme
                              : colors.kColorGreyText,
                        ),
                      ),
                    ],
                  ),
                  Sizer.qtr(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TotalPnlValuePosition(),
                    ],
                  ),
                  // IntrinsicHeight(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Column(
                  //         children: [
                  //           Text(
                  //             ('realizedPnl').tr(),
                  //             style: textStyles.kTextExtraTinywith400.copyWith(
                  //               color: isDarkMode
                  //                   ? colors.kColorBottomWhiteTextDarkTheme
                  //                   : colors.kColorGreyText,
                  //             ),
                  //           ),
                  //           Sizer.qtr(),
                  //           RealisedPnlValuePosition()
                  //         ],
                  //       )),
                  //       verticalDividerLine(isDarkMode),
                  //       Expanded(
                  //           child: Column(
                  //         children: [
                  //           Text(
                  //             ('unRealizedPnl').tr(),
                  //             style: textStyles.kTextExtraTinywith400.copyWith(
                  //               color: isDarkMode
                  //                   ? colors.kColorBottomWhiteTextDarkTheme
                  //                   : colors.kColorGreyText,
                  //             ),
                  //           ),
                  //           Sizer.qtr(),
                  //           UnRealisedPnlValuePosition(),
                  //         ],
                  //       )),
                  //     ],
                  //   ),
                  // ),
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

class TotalPnlValuePosition extends ConsumerWidget {
  const TotalPnlValuePosition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).positionTotalPnl.stream,
        initialData: ref.read(websocketProvider).totalPnlPos == 0.0
            ? ref.read(portfolioProvider).totalPnlPos
            : ref.read(websocketProvider).totalPnlPos,
        builder: (_, AsyncSnapshot<double> snapshot) {
          log("PNL POS ::: ${snapshot.data}");
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: isNumberNegative("${snapshot.data}"),
                child: Text(
                  '-',
                  style: textStyles.kTextSixW500.copyWith(
                    color: colors.kColorRed,
                  ),
                )),
            Icon(
              Icons.currency_rupee,
              size: 14,
              color: isNumberNegative("${snapshot.data}")
                  ? colors.kColorRed
                  : colors.kColorGreen,
            ),
            Text(
              formatCurrencyStandard(
                value: snapshot.data!.toStringAsFixed(2),
                isShowSign: false,
              ),
              style: textStyles.kTextSixteenW500.copyWith(
                color: isNumberNegative("${snapshot.data}")
                    ? colors.kColorRed
                    : colors.kColorGreen,
              ),
            )
          ]);
        });
  }
}

class RealisedPnlValuePosition extends ConsumerWidget {
  const RealisedPnlValuePosition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).reliasedPnlPos.stream,
        initialData: ref.read(websocketProvider).reliasedPnlPosition == 0.0
            ? ref.read(portfolioProvider).totalRealisedPnl
            : ref.read(websocketProvider).reliasedPnlPosition,
        builder: (_, AsyncSnapshot<double> snapshot) {
          log("PNL POS ::: ${snapshot.data}");
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: isNumberNegative("${snapshot.data}"),
                child: Text(
                  '-',
                  style: textStyles.kTextSixW500.copyWith(
                    color: colors.kColorRed,
                  ),
                )),
            Icon(
              Icons.currency_rupee,
              size: 14,
              color: isNumberNegative("${snapshot.data}")
                  ? colors.kColorRed
                  : colors.kColorGreen,
            ),
            Text(
              formatCurrencyStandard(
                value: snapshot.data!.toStringAsFixed(2),
                isShowSign: false,
              ),
              style: textStyles.kTextFourteenW500.copyWith(
                color: isNumberNegative("${snapshot.data}")
                    ? colors.kColorRed
                    : colors.kColorGreen,
              ),
            )
          ]);
        });
  }
}

class UnRealisedPnlValuePosition extends ConsumerWidget {
  const UnRealisedPnlValuePosition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).unreliasedPnlPos.stream,
        initialData: ref.read(websocketProvider).unreliasedPnlPosition == 0.0
            ? ref.read(portfolioProvider).totalUnRealisedPnl
            : ref.read(websocketProvider).unreliasedPnlPosition,
        builder: (_, AsyncSnapshot<double> snapshot) {
          log("PNL POS ::: ${snapshot.data}");
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: isNumberNegative("${snapshot.data}"),
                child: Text(
                  '-',
                  style: textStyles.kTextSixW500.copyWith(
                    color: colors.kColorRed,
                  ),
                )),
            Icon(
              Icons.currency_rupee,
              size: 14,
              color: isNumberNegative("${snapshot.data}")
                  ? colors.kColorRed
                  : colors.kColorGreen,
            ),
            Text(
              formatCurrencyStandard(
                value: snapshot.data!.toStringAsFixed(2),
                isShowSign: false,
              ),
              style: textStyles.kTextFourteenW500.copyWith(
                color: isNumberNegative("${snapshot.data}")
                    ? colors.kColorRed
                    : colors.kColorGreen,
              ),
            )
          ]);
        });
  }
}

class NoData extends ConsumerWidget {
  final String errorMsg;
  final bool isNoPosition;
  const NoData({
    Key? key,
    required this.errorMsg,
    required this.isNoPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      color: isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
      height: sizes.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isNoPosition)
            Text(
              '$errorMsg',
              style: textStyles.kTextFourteenW400,
            ),
          if (isNoPosition)
            SvgPicture.asset(
              assets.noPosHoldImage,
            ),
          if (isNoPosition) Sizer.vertical48(),
          if (isNoPosition)
            Text(
              "You have no Position yet.",
              style: textStyles.kTextSixteenW400.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? colors.kColorWhite60 : colors.kColorBlack60,
              ),
            ),
          if (isNoPosition)
            Padding(
              padding: EdgeInsets.all(sizes.pad_12),
              child: Text(
                'Start trading and your transactions will reflect here',
                textAlign: TextAlign.center,
                style: textStyles.kTextSixteenW400.copyWith(
                  color:
                      isDarkMode ? colors.kColorWhite60 : colors.kColorBlack60,
                ),
              ),
            )
        ],
      ),
    );
  }
}
