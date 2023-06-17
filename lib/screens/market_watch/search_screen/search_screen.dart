import 'dart:async';
import 'dart:developer';
import 'package:aliceblue/provider/market_helper_provider.dart';
import 'package:aliceblue/router/route_names.dart';
import 'package:flutter/services.dart';
import 'package:aliceblue/provider/market_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../model/market_depth_model.dart';
import '../../../model/market_watch_list_model.dart';
import '../../../model/place_order_input_model.dart';
import '../../../model/search_scrip_data.dart';
import '../../../model/ws_tf_feed_model.dart';
import '../../../provider/websocket_provider.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../market_depth/bottom_sheet_header.dart';
import '../../market_depth/market_depth_screen.dart';
import 'widgets/search_bottom_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final int tabIndex;
  const SearchScreen({Key? key, required this.tabIndex}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController controller = TextEditingController();
  bool _isSearched = false;
  var focusNode = FocusNode();
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(marketHelperProvider).disableFilterButton();
    });
    log("INDEX :: ${widget.tabIndex}");
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _isSearched = !_isSearched;
      });
    });
  }

  void searchDelay() {
    isSearch = true;
    Timer(const Duration(milliseconds: 250), () {
      isSearch = false;
      ref.read(marketHelperProvider).getSearchScrip(
          key: controller.text,
          context: context,
          exchangeItems: ref.read(marketHelperProvider).allScripSearch);
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketModel = ref.watch(marketHelperProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return WillPopScope(
      onWillPop: () async {
        ref.read(marketHelperProvider).clearSearch();
        return true;
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? colors.kColorAppbarDarkTheme
            : colors.kColorAppbarLightTheme,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 0,
            backgroundColor:
                isDarkMode ? colors.kColorBlack : colors.kColorWhite,
            bottom: PreferredSize(
              preferredSize: Size(sizes.width, -10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: isDarkMode
                                        ? colors.kColorWhite
                                        : colors.kColorBlack,
                                  ),
                                ),
                                Sizer.halfHorizontal()
                              ],
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: (sizes.width / 1.16),
                                height: 40,
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? colors.kColorAppbarDarkTheme
                                          : colors.kColorWhite,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomTextFormField(
                                      isAutofocus: true,
                                      contentPaddingVertical: 10,
                                      contentPadding: 18,
                                      borderRadius: 6,
                                      textInputFormatter: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z0-9 ]")),
                                      ],
                                      controller: controller,
                                      style: textStyles.kTextFourteenW400
                                          .copyWith(
                                              color: isDarkMode
                                                  ? colors.kColorWhite
                                                  : colors.kColorBlack),
                                      onChanged: (_) {
                                        if (controller.text.length >= 2) {
                                          ref
                                              .read(marketHelperProvider)
                                              .getSearchScrip(
                                                  key: controller.text,
                                                  context: context,
                                                  exchangeItems: ref
                                                      .read(
                                                          marketHelperProvider)
                                                      .allScripSearch);
                                        }
                                      },
                                      maxCount: 25,
                                      focusColor:
                                          colors.kColorBlack.withOpacity(0.2),
                                      sumitField: (_) {
                                        Timer(const Duration(milliseconds: 500),
                                            () {
                                          ref
                                              .read(marketHelperProvider)
                                              .getSearchScrip(
                                                  key: controller.text,
                                                  context: context,
                                                  exchangeItems: ref
                                                      .read(
                                                          marketHelperProvider)
                                                      .allScripSearch);
                                        });
                                      },
                                      hintText: "Search eg: Infy, Nifty FUT",
                                      hintStyle: textStyles.kTextFourteenW400
                                          .copyWith(
                                              color: isDarkMode
                                                  ? colors.kColorWhite
                                                  : colors.kColorBlack),
                                      enabled: true,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        }, child: Consumer(
          builder: (context, watch, _) {
            final market = ref.watch(marketProvider);
            List<Scrip> selectedScrip = [];
            switch (widget.tabIndex) {
              case 0:
                selectedScrip = market.getMWScrip1 ?? [];
                break;
              case 1:
                selectedScrip = market.getMWScrip2 ?? [];
                break;
              case 2:
                selectedScrip = market.getMWScrip3 ?? [];
                break;
              case 3:
                selectedScrip = market.getMWScrip4 ?? [];
                break;
              case 4:
                selectedScrip = market.getMWScrip5 ?? [];
                break;
            }
            return Container(
              color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
              child: market.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: market.loading
                              ? const Center(child: CircularProgressIndicator())
                              : (marketModel.searchFilterActiveName == "F&O" ||
                                          marketModel.searchFilterActiveName ==
                                              "CURRENCY" ||
                                          marketModel.searchFilterActiveName ==
                                              "STOCKS") &&
                                      controller.text.isNotEmpty &&
                                      marketModel
                                          .getfilterScripSearchResult.isEmpty
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(assets.cartEmpty,
                                                  height: 187, width: 198),
                                              Sizer.vertical20(),
                                              Text(
                                                "No result found",
                                                style: textStyles
                                                    .kTextFourteenW400
                                                    .copyWith(
                                                        color: isDarkMode
                                                            ? colors.kColorWhite
                                                            : colors
                                                                .kColorBlack),
                                              ),
                                              Sizer.vertical10(),
                                              Text(
                                                "Use valid search keys such as Infy, Nifty.",
                                                style: textStyles
                                                    .kTextTwelveW400
                                                    .copyWith(
                                                        color: isDarkMode
                                                            ? colors.kColorWhite
                                                            : colors
                                                                .kColorGreyText),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : SearchListView(
                                      data: controller.text.length < 2
                                          ? []
                                          : marketModel
                                              .getfilterScripSearchResult,
                                      selectedScrip: selectedScrip,
                                      tabIndex: widget.tabIndex,
                                    ),
                        ),
                      ],
                    ),
            );
          },
        )),
      ),
    );
  }
}

class SearchListView extends ConsumerWidget {
  final List<SearchScripData> data;
  final List<Scrip> selectedScrip;

  final int tabIndex;
  const SearchListView({
    Key? key,
    required this.data,
    required this.selectedScrip,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) => ListViewSearch(
              data: data[i],
              selectedScrip: selectedScrip,
              tabIndex: tabIndex,
              listIndex: i,
            ));
  }
}

class ListViewSearch extends ConsumerWidget {
  final SearchScripData data;
  final List<Scrip> selectedScrip;

  final int tabIndex;
  final int listIndex;
  const ListViewSearch(
      {Key? key,
      required this.data,
      required this.selectedScrip,
      required this.tabIndex,
      required this.listIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final marketPro = ref.read(marketProvider);
    final marketHelperProv = ref.read(marketHelperProvider);
    return InkWell(
      onTap: () async {
        ref.read(websocketProvider).establishConnection(
              channelInput: "${data.exch}|${data.token}",
              task: "t",
            );
        if (!data.isIndex!) {
          ref.read(websocketProvider).establishConnection(
                channelInput: "${data.exch}|${data.token}",
                task: "d",
              );
          selectedScrip.any((element) => element.token == data.token)
              ? marketHelperProv.deleteScripViaSearch(
                  context, data, selectedScrip, tabIndex, listIndex)
              : marketHelperProv.addScripViaSearch(
                  context, data, selectedScrip, tabIndex);
        } else {
          ref.read(marketHelperProvider).getContractInfo(
                context: context,
                exchange: data.exch ?? '',
                token: data.token ?? "",
              );
          await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              builder: (_) => IndianIndicesBottomSheet(data: data));
        }
      },
      child: Column(
        children: [
          ListTile(
            dense: true,
            minLeadingWidth: sizes.pad_12,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: sizes.pad_4, vertical: 4),
                  decoration: BoxDecoration(
                      color: data.exch!.toUpperCase() == 'NSE'
                          ? isDarkMode
                              ? colors.kColorBlue.withOpacity(0.3)
                              : colors.kcolorBlueBackgroundSearch
                          : data.exch!.toUpperCase() == 'BSE'
                              ? isDarkMode
                                  ? colors.kColorRed.withOpacity(0.3)
                                  : colors.kColorRedBackgroundSearch
                              : data.exch!.toUpperCase() == 'NFO' ||
                                      data.exch!.toUpperCase() == 'BFO'
                                  ? isDarkMode
                                      ? colors.kColorBlue.withOpacity(0.3)
                                      : colors.kcolorBlueBackgroundSearch
                                  : data.exch!.toUpperCase() == 'MCX'
                                      ? isDarkMode
                                          ? colors.kColorGreen.withOpacity(0.3)
                                          : colors.kColorGreenBackgroundSearch
                                      : data.exch!.toUpperCase() == 'BCD' ||
                                              data.exch!.toUpperCase() == 'CDS'
                                          ? isDarkMode
                                              ? colors.kColorYellowSearch
                                                  .withOpacity(0.3)
                                              : colors.kColorYellowSearch
                                                  .withOpacity(0.05)
                                          : data.exch!.toUpperCase() == 'BCO'
                                              ? isDarkMode
                                                  ? colors
                                                      .kcolorBlueBackgroundSearch
                                                  : colors
                                                      .kcolorBlueBackgroundSearch
                                              : colors.kColorBlue,
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    data.exch!,
                    style: textStyles.kTextTenW400.copyWith(
                        color: data.exch!.toUpperCase() == 'NSE'
                            ? isDarkMode
                                ? colors.kColorOpenButton
                                : colors.kColorOpenButton
                            : data.exch!.toUpperCase() == 'BSE'
                                ? isDarkMode
                                    ? colors.kColorRed
                                    : colors.kColorRed
                                : data.exch!.toUpperCase() == 'NFO' ||
                                        data.exch!.toUpperCase() == 'BFO'
                                    ? isDarkMode
                                        ? colors.kcolorBlueBackgroundSearch
                                        : colors.kColorBlue
                                    : data.exch!.toUpperCase() == 'MCX'
                                        ? isDarkMode
                                            ? colors.kColorGreenSearch
                                            : colors.kColorGreenSearch
                                        : data.exch!.toUpperCase() == 'BCD' ||
                                                data.exch!.toUpperCase() ==
                                                    'CDS'
                                            ? isDarkMode
                                                ? colors.kColorYellowSearch
                                                : colors.kColorYellowSearch
                                            : data.exch!.toUpperCase() == 'BCO'
                                                ? isDarkMode
                                                    ? colors.kColorOpenButton
                                                    : colors.kColorOpenButton
                                                : colors.kColorBlack),
                  ),
                ),
              ],
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    ref.read(marketHelperProvider).getContractInfo(
                          context: context,
                          exchange: data.exch ?? '',
                          token: data.token ?? "",
                        );
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: (_) => SearchBottomSheet(
                              data: data,
                            )).whenComplete(() {
                      ref.read(websocketProvider).establishConnection(
                            channelInput: "${data.exch!}|${data.token}",
                            task: "ud",
                          );
                      ref.read(websocketProvider).establishConnection(
                            channelInput: "${data.exch}|${data.token}",
                            task: "u",
                          );
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      data.exch!.toUpperCase() == 'NFO'
                          ? Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${data.formattedInsName!.split(" ")[0]} ${data.formattedInsName!.split(" ").length >= 2 ? data.splittedTagName!.isNotEmpty ? data.formattedInsName!.split(" ")[1].replaceAll("${data.splittedTagName}", "") : '${data.formattedInsName!.split(" ")[1].replaceAll("${data.splittedTagName}", "${data.splittedTagName!}")}' : ''}",
                                      style:
                                          textStyles.kTextFourteenW400.copyWith(
                                        color: isDarkMode
                                            ? colors.kColorWhite
                                            : colors.kColorBlack,
                                      ),
                                    ),
                                    WidgetSpan(
                                        child: Transform.translate(
                                            offset: const Offset(0.0, -7.0),
                                            child: Text(
                                              "${data.splittedTagName!}",
                                              style: textStyles.kTextTenW400
                                                  .copyWith(
                                                color: isDarkMode
                                                    ? colors.kColorWhite
                                                    : colors.kColorBlack,
                                              ),
                                            ))),
                                    TextSpan(
                                      text:
                                          " ${data.formattedInsName!.split(" ").length > 2 ? data.formattedInsName!.split(" ")[2] : ""} ${data.formattedInsName!.split(" ").length > 3 ? data.formattedInsName!.split(" ")[3] : ''} ${data.formattedInsName!.split(" ").length > 4 ? data.formattedInsName!.split(" ")[4] : ''}",
                                      style:
                                          textStyles.kTextFourteenW400.copyWith(
                                        color: isDarkMode
                                            ? colors.kColorWhite
                                            : colors.kColorBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(
                              data.exch!.toLowerCase() == 'nse' ||
                                      data.exch!.toLowerCase() == 'bse'
                                  ? data.symbol!.toUpperCase()
                                  : data.formattedInsName!.toUpperCase(),
                              overflow: TextOverflow.fade,
                              style: textStyles.kTextFourteenW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            subtitle: data.exch!.toLowerCase() != 'nse' &&
                    data.exch!.toLowerCase() != 'bse'
                ? data.isWeekTag!
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: sizes.pad_4),
                        child: Row(
                          children: [
                            Text(
                              "${(data.expiry != null && data.expiry!.contains("-") && data.expiry!.split("-").length == 3 && data.isMonth) ? data.expiry!.split("-")[2] : ""} ${data.formattedInsName!.split(" ")[1].replaceAll("${data.splittedTagName}", "${data.splittedTagName!}")} ${(data.formattedInsName!.split(" ").length > 2 && data.isWeek) ? data.formattedInsName!.split(" ")[2] : ''} ${data.isWeek ? 'WEEKLY' : 'MONTHLY'}  ",
                              style: textStyles.kTextElevenW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorGreyText
                                    : colors.kColorGreyText,
                              ),
                            ),
                            Visibility(
                              visible: data.isWeek,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: colors.kColorBlueWeekTagBG,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Text(
                                    '${data.weekTag}',
                                    style: textStyles.kTextEightW400.copyWith(
                                      color: colors.kColorBlue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          ref.read(marketHelperProvider).getContractInfo(
                                context: context,
                                exchange: data.exch ?? '',
                                token: data.token ?? "",
                              );
                          await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              builder: (_) => SearchBottomSheet(
                                    data: data,
                                  )).whenComplete(() {
                            ref.read(websocketProvider).establishConnection(
                                  channelInput: "${data.exch!}|${data.token}",
                                  task: "ud",
                                );
                            ref.read(websocketProvider).establishConnection(
                                  channelInput: "${data.exch}|${data.token}",
                                  task: "u",
                                );
                          });
                        },
                        child: Row(
                          children: [
                            Text(data.formattedInsName!.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: textStyles.kTextElevenW400.copyWith(
                                    color: isDarkMode
                                        ? colors.kColorGreyText
                                        : colors.kColorGreyText)),
                          ],
                        ),
                      )
                    ],
                  ),
            trailing: selectedScrip
                    .any((element) => element.token == data.token)
                ? marketHelperProv.getClickedIndexSearch
                        .any((element) => element == data.token)
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : InkWell(
                        onTap: () async {
                          ref
                              .read(marketHelperProvider)
                              .changeSearchClickIndex(value: data.token!);
                          List<MarketWatchAddScripsDatum> scripListInput = [
                            MarketWatchAddScripsDatum(
                              exch: data.exch!,
                              token: data.token!,
                            )
                          ];
                          // delete
                          await marketHelperProv.deleteScrip(
                            context: context,
                            mwId:
                                marketPro.getWatchList!.result![tabIndex].mwId!,
                            deleteScrip: [
                              selectedScrip.firstWhere(
                                  (element) => element.token == data.token!)
                            ],
                            scripsList: scripListInput,
                            index: listIndex,
                            tabIndex: tabIndex,
                            forceUpdate: true,
                          );
                          ref
                              .read(marketHelperProvider)
                              .changeSearchClickIndex(value: data.token!);
                        },
                        child: SizedBox(
                          width: 50,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: colors.kColorGreen,
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: colors.kColorGreen)),
                                child: Icon(
                                  Icons.done_outlined,
                                  size: 14,
                                  color: colors.kColorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                // ignore: unrelated_type_equality_checks
                : marketHelperProv.getClickedIndexSearch
                        .any((element) => element == data.token)
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : InkWell(
                        onTap: () async {
                          if (selectedScrip.length >= 30) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                errorSnackBar("Market Watch full"));
                            return;
                          } else {
                            if (marketPro.getWatchList == null) {
                              final stat = await marketHelperProv.createMw(
                                  context: context);
                              if (stat) {
                                await marketPro.getUserWatchlist(
                                  context: context,
                                  forceUpdate: true,
                                  tabIndex: tabIndex,
                                );
                              }
                            }
                            var seen = <String>{};
                            selectedScrip
                                .where((uniqueList) =>
                                    seen.add(uniqueList.token.toString()))
                                .toList();
                            if ((!(seen.contains(data.token)))) {
                              ref
                                  .read(marketHelperProvider)
                                  .changeSearchClickIndex(value: data.token!);
                              List<MarketWatchAddScripsDatum> scripListInput = [
                                MarketWatchAddScripsDatum(
                                  exch: data.exch!,
                                  token: data.token!,
                                )
                              ];
                              await marketHelperProv.addScrip(
                                mwId: marketPro
                                    .getWatchList!.result![tabIndex].mwId!,
                                scripsList: scripListInput,
                                tabIndex: tabIndex,
                                context: context,
                              );
                              ref
                                  .read(marketHelperProvider)
                                  .changeSearchClickIndex(value: data.token!);
                            }
                          }
                        },
                        child: SizedBox(
                            width: 50,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorGreyText)),
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                      color: isDarkMode
                                          ? colors.kColorWhite
                                          : colors.kColorGreyText,
                                    ),
                                  ),
                                ])),
                      ),
          ),
          horizontalDividerLine(isDarkMode)
        ],
      ),
    );
  }
}

class SearchFilterTabs extends ConsumerWidget {
  final String filterName;
  final Function onPress;
  const SearchFilterTabs({
    Key? key,
    required this.filterName,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketwatchProvider =
        ref.watch(marketHelperProvider).searchFilterActiveName;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizes.pad_6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: marketwatchProvider == filterName
                  ? isDarkMode
                      ? colors.kColorBlueDarkBG
                      : colors.kColorBlue
                  : isDarkMode
                      ? colors.kColorAppbarDarkTheme
                      : colors.kColorWhite,
              border: Border.all(
                color: marketwatchProvider == filterName
                    ? isDarkMode
                        ? colors.kColorBlue
                        : colors.kColorBlue
                    : isDarkMode
                        ? colors.kColorAppbarDarkTheme
                        : colors.kColorGreyLightBorder,
              ),
            ),
            child: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_12,
                vertical: sizes.pad_4,
              ),
              child: Text(
                filterName,
                style: textStyles.kTextTenW400.copyWith(
                    color: marketwatchProvider == filterName
                        ? isDarkMode
                            ? colors.kColorBlue
                            : colors.kColorWhite
                        : isDarkMode
                            ? colors.kColorBlue
                            : colors.kColorGreyText),
              ),
            )),
          ),
        ),
        onTap: () {
          ref
              .read(marketHelperProvider)
              .enableSearchFilterActiveButton(searchFilterName: filterName);
        });
  }
}

class SearchFilterTab extends ConsumerWidget {
  const SearchFilterTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketWatchProvider = ref.watch(marketHelperProvider);
    return Column(
      children: [
        if (marketWatchProvider.isSearchFilter)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchFilterTabs(
                filterName: "ALL",
                onPress: () {
                  marketWatchProvider.enableSearchFilterActiveButton(
                      searchFilterName: "ALL");
                },
              ),
              SearchFilterTabs(
                filterName: "STOCKS",
                onPress: () {
                  marketWatchProvider.enableSearchFilterActiveButton(
                      searchFilterName: "STOCKS");
                },
              ),
              SearchFilterTabs(
                filterName: "CURRENCY",
                onPress: () {
                  marketWatchProvider.enableSearchFilterActiveButton(
                      searchFilterName: "CURRENCY");
                },
              ),
              SearchFilterTabs(
                filterName: "F&O",
                onPress: () {
                  marketWatchProvider.enableSearchFilterActiveButton(
                      searchFilterName: "F&O");
                },
              ),
            ],
          ),
      ],
    );
  }
}

class IndianIndicesBottomSheet extends ConsumerStatefulWidget {
  final SearchScripData data;
  const IndianIndicesBottomSheet({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<IndianIndicesBottomSheet> createState() =>
      _IndianIndicesBottomSheetState();
}

class _IndianIndicesBottomSheetState
    extends ConsumerState<IndianIndicesBottomSheet> {
  late SearchScripData data;
  double initialSize = 0;
  var child;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    initialSize = 300.0 / sizes.height;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return DraggableScrollableSheet(
        initialChildSize: initialSize,
        minChildSize: 0.25,
        maxChildSize: 0.35,
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
                                          change: data.change!,
                                          exchange: data.exch!,
                                          ltp: data.ltp!,
                                          pdc: data.close!,
                                          perChange: data.percentageChange!,
                                          scripName:
                                              data.formatedInstrumentName!,
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: sizes.pad_16,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: sizes.pad_6,
                                        vertical: sizes.pad_6,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: sizes.pad_6,
                                                horizontal: sizes.pad_24),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // final WebViewInput
                                                    //     webViewInput =
                                                    //     WebViewInput(
                                                    //         title: 'CHART',
                                                    //         isDarkMode:
                                                    //             isDarkMode,
                                                    //         url:
                                                    //             "${ref.read(webViewProvider).generateChartUrl(
                                                    //                   tradingSymbol:
                                                    //                       data.symbol!,
                                                    //                   token: data
                                                    //                       .token!,
                                                    //                   exchange:
                                                    //                       data.exch!,
                                                    //                   ltp: data
                                                    //                       .ltp!,
                                                    //                 )}",
                                                    //         orderWidArgs:
                                                    //             OrderWindowArguments(
                                                    //           exchange:
                                                    //               data.exch,
                                                    //           instrument:
                                                    //               data.symbol,
                                                    //           token:
                                                    //               data.token!,
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
                                                        color:
                                                            colors.kColorBlue,
                                                      ),
                                                      Sizer.qtrHorizontal(),
                                                      Text("View Chart",
                                                          style: textStyles
                                                              .kTextTwelveW400
                                                              .copyWith(
                                                            color: colors
                                                                .kColorBlue,
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
                                                      percentageChange: data
                                                          .percentageChange!,
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
                                                    style: textStyles
                                                        .kTextTwelveW400
                                                        .copyWith(
                                                            color: colors
                                                                .kColorBlue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Sizer.vertical16(),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              color: isDarkMode
                                                  ? colors
                                                      .kColorPinTextfieldDarkTheme
                                                  : colors.kColorBlueLight,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: sizes.pad_16,
                                                vertical: sizes.pad_16,
                                              ),
                                              child: OHLCAck(data: data),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Sizer.vertical24(),
                              ]))
                        ])),
                  ),
                ));
          }
          return child;
        });
  }
}

class OHLCAck extends ConsumerStatefulWidget {
  final SearchScripData data;
  const OHLCAck({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  ConsumerState<OHLCAck> createState() => _OHLCAckState();
}

class _OHLCAckState extends ConsumerState<OHLCAck> {
  late SearchScripData data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(websocketProvider).establishConnection(
            channelInput: '${data.exch}|${data.token}',
            task: 't',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.read(websocketProvider).tfUpdate.stream,
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == data.token) {
              data.close =
                  snapshot.data!.c == null || snapshot.data!.c == 'null'
                      ? data.close
                      : snapshot.data!.c!;
              data.open = snapshot.data!.o == null || snapshot.data!.o == 'null'
                  ? data.open
                  : snapshot.data!.o;
              data.high = snapshot.data!.h == null || snapshot.data!.h == 'null'
                  ? data.high
                  : snapshot.data!.h;
              data.low = snapshot.data!.l == null || snapshot.data!.l == 'null'
                  ? data.low
                  : snapshot.data!.l;
              data.ltp =
                  snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                      ? data.ltp
                      : snapshot.data!.lp!;
              data.percentageChange =
                  snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                      ? data.percentageChange
                      : snapshot.data!.pc!;

              data.change = (double.parse(data.ltp!) -
                      double.parse(
                        data.close == "" ? '0' : data.close!,
                      ))
                  .toString();
              log("${data.percentageChange}");
            }
          }
          return OHLC(
            data: MDdata(
              openrate: data.open,
              highrate: data.high,
              lowrate: data.low,
              previouscloserate: data.close,
            ),
          );
        });
  }
}
