import 'dart:developer';

import 'package:aliceblue/provider/menu_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/indian_indices_model.dart';
import '../../model/market_watch_list_model.dart';
import '../../provider/market_helper_provider.dart';
import '../../provider/market_provider.dart';
import '../../provider/theme_provider.dart';
import '../../provider/websocket_provider.dart';
import '../../res/res.dart';
import '../../router/route_names.dart';
import '../../shared_widget/snack_bar.dart';
import '../../shared_widget/svg_icon_button.dart';
import '../../util/sizer.dart';
import '../menu/top_header/fixed_tab_header.dart';
import '../retry_service_screens/retry_screens.dart';
import 'widgets/index_bottom_sheet.dart';
import 'widgets/watchlist_bottom_sheet.dart';
import 'widgets/watchlist_card.dart';

class MarketWatchScreen extends ConsumerStatefulWidget {
  const MarketWatchScreen({super.key});

  @override
  ConsumerState<MarketWatchScreen> createState() => _MarketWatchScreenState();
}

class _MarketWatchScreenState extends ConsumerState<MarketWatchScreen>
    with SingleTickerProviderStateMixin {
  late TabController controllerML;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    controllerML = TabController(
      length: ref.read(marketProvider).tabs.length,
      vsync: this,
      initialIndex: ref.read(marketProvider).pref.wlTabIndex,
    );

    controllerML.addListener(() {
      if (controllerML.index != _selectedIndex) {
        setState(() {
          _selectedIndex = controllerML.index;
        });
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(marketProvider).clearFilter();
          ref.read(marketProvider).changeTabBarIndex(
                value: _selectedIndex,
                context: context,
              );
        });
      }
    });
  }

  void updateTabController(int tabLen) {
    setState(() {
      controllerML = TabController(
        length: tabLen,
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerML.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final isFixedHeader = ref.watch(marketProvider).pref.isFixedHeader;
    final isMWLoaded = ref.watch(marketProvider).getWatchList != null;
    final isExpanded = ref.watch(menuProvider).isExpanded;
    final tabs = ref.watch(marketProvider).tabs;
    final dummyTabs = ref.watch(marketProvider).dummyTabs;
    return Scaffold(
      backgroundColor:
          isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  floating: isFixedHeader ? false : true,
                  pinned: true,
                  snap: false,
                  elevation: 0,
                  backgroundColor: isDarkMode
                      ? colors.kColorAppbarDarkTheme
                      : colors.kColorAppbarLightTheme,
                  leading: isFixedHeader
                      ? null
                      : SvgIconButton(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          assetLink: assets.watchlistIcon,
                          color: isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorBlack,
                          onPress: () {},
                        ),
                  centerTitle: false,
                  titleSpacing: 0,
                  title: isFixedHeader
                      ? FixedTabHeader()
                      : Text(("watchlist").tr(),
                          style: textStyles.kTextSixteenW700.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorBlack,
                          )),
                  actions: [
                    IconButton(
                        onPressed: () {
                          ref.read(menuProvider).changeExpand(!isExpanded);
                        },
                        icon: Icon(Icons.expand_more_outlined,
                            color: isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorBlack)),
                  ],
                  bottom: ref.read(marketProvider).getWatchList != null
                      ? PreferredSize(
                          preferredSize: Size(sizes.width, 49),
                          child: Padding(
                              padding: EdgeInsets.only(top: 6.0),
                              child: TabBar(
                                  controller: controllerML,
                                  isScrollable: true,
                                  // indicatorWeight: 0,
                                  labelStyle: textStyles.kTextTwelveW500,
                                  unselectedLabelStyle:
                                      textStyles.kTextTwelveW400,
                                  labelColor: colors.kColorBlue,
                                  indicatorColor: colors.kColorBlue,
                                  unselectedLabelColor: isDarkMode
                                      ? colors.kColorWhite
                                      : colors.kColorGreyText,
                                  padding: EdgeInsets.fromLTRB(
                                    sizes.pad_12,
                                    0,
                                    sizes.pad_12,
                                    10,
                                  ),
                                  // indicator: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(
                                  //       6), // Creates border
                                  //   color: colors.kColorBlue,
                                  // ),
                                  tabs: tabs.isEmpty
                                      ? dummyTabs
                                          .map((e) => Container(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(e),
                                              )))
                                          .toList()
                                      : tabs
                                          .map(
                                            (e) => InkWell(
                                                onLongPress: () {
                                                  // controllerML.animateTo(
                                                  //     tabs.indexOf(e));
                                                  // ref
                                                  //     .read(marketProvider)
                                                  //     .changeTabBarIndex(
                                                  //       value:
                                                  //           tabs.indexOf(e),
                                                  //       context: context,
                                                  //     );
                                                  // ref
                                                  //     .read(marketProvider)
                                                  //     .marketWatchName();
                                                  // Navigator.pushNamed(
                                                  //     context,
                                                  //     Routes
                                                  //         .watchlistReorder,
                                                  //     arguments: ref
                                                  //         .read(
                                                  //             marketProvider)
                                                  //         .fetchTabIndex());
                                                },
                                                onTap: () {
                                                  ref
                                                      .read(marketProvider)
                                                      .changeTabBarIndex(
                                                        value: tabs.indexOf(e),
                                                        context: context,
                                                      );
                                                  controllerML.animateTo(
                                                      tabs.indexOf(e));
                                                },
                                                child: Container(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    e.split(":")[1],
                                                  ),
                                                ))),
                                          )
                                          .toList())))
                      : null
                  // )
                  ),
            ];
          },
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          body: isMWLoaded
              ? Container(
                  color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                  child: TabBarView(
                    controller: controllerML,
                    children: [
                      FirstScreen(updateTab: updateTabController),
                      SecondScreen(updateTab: updateTabController),
                      ThirdScreen(updateTab: updateTabController),
                      FourthScreen(updateTab: updateTabController),
                      FivthScreen(updateTab: updateTabController),
                      if (tabs.length >= 6)
                        SixthScreen(updateTab: updateTabController),
                      if (tabs.length >= 7)
                        SeventhScreen(updateTab: updateTabController),
                      if (tabs.length >= 8)
                        EighthScreen(updateTab: updateTabController),
                    ],
                  ))
              : RetryScreen(
                  isFrom: "marketWatch",
                ),
        ),
      ),
    );
  }
}

class FirstScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const FirstScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
          child: WatchListView(
              data: WatchlistViewArgs(
        data: market.filteredItems.isNotEmpty
            ? market.filteredItems
            : market.getMWScrip1 ?? [],
        tabIndex: 0,
        scripCount: market.getMWScrip1?.length ?? 0,
        isListView: market.pref.isListView!,
        wsCardType: market.pref.wsCardType,
        updateTab: updateTab,
      )))
    ]);
  }
}

class SecondScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const SecondScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip2 ?? [],
            tabIndex: 1,
            scripCount: market.getMWScrip2?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class ThirdScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const ThirdScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip3 ?? [],
            tabIndex: 2,
            scripCount: market.getMWScrip3?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class FourthScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const FourthScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip4 ?? [],
            tabIndex: 3,
            scripCount: market.getMWScrip4?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class FivthScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const FivthScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip5 ?? [],
            tabIndex: 4,
            scripCount: market.getMWScrip5?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class SixthScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const SixthScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip6 ?? [],
            tabIndex: 5,
            scripCount: market.getMWScrip6?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class SeventhScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const SeventhScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip7 ?? [],
            tabIndex: 6,
            scripCount: market.getMWScrip7?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class EighthScreen extends ConsumerWidget {
  final Function(int val) updateTab;
  const EighthScreen({
    Key? key,
    required this.updateTab,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final market = ref.watch(marketProvider);
    return Column(children: [
      Sizer.vertical10(),
      Expanded(
        child: WatchListView(
          data: WatchlistViewArgs(
            data: market.filteredItems.isNotEmpty
                ? market.filteredItems
                : market.getMWScrip8 ?? [],
            tabIndex: 7,
            scripCount: market.getMWScrip8?.length ?? 0,
            isListView: market.pref.isListView!,
            wsCardType: market.pref.wsCardType,
            updateTab: updateTab,
          ),
        ),
      )
    ]);
  }
}

class WatchListView extends ConsumerStatefulWidget {
  final WatchlistViewArgs data;
  const WatchListView({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends ConsumerState<WatchListView> {
  late WatchlistViewArgs data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(marketProvider).requestWS(
            isSubscribe: true,
            context: context,
          );
    });
  }

  @override
  void didUpdateWidget(covariant WatchListView oldWidget) {
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
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(marketProvider).getScrip(
              context: context,
              tabIndex: data.tabIndex,
            );
      },
      child: data.data.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                Column(
                  children: [
                    SearchAndFilter(
                      tabIndex: data.tabIndex,
                      isHide: true,
                      scripCount: data.scripCount,
                      updateTab: data.updateTab,
                    ),
                    SizedBox(
                      height: sizes.height / 1.45,
                      child: NoData(
                        errorMsg: 'No instruments added to the list yet.',
                      ),
                    ),
                  ],
                ),
              ],
            )
          : data.isListView
              ? ListView.builder(
                  cacheExtent: double.maxFinite,
                  addAutomaticKeepAlives: true,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: data.data.length > 30 ? 30 : data.data.length + 1,
                  itemBuilder: (context, index) {
                    return index == data.data.length
                        ? Sizer.vertical16()
                        : InkWell(
                            onLongPress: () {
                              final isPredef =
                                  ref.read(marketProvider).getWatchList !=
                                              null &&
                                          ref
                                                  .read(marketProvider)
                                                  .getWatchList!
                                                  .result !=
                                              null &&
                                          ref
                                              .read(marketProvider)
                                              .getWatchList!
                                              .result!
                                              .isNotEmpty &&
                                          (ref
                                                  .read(marketProvider)
                                                  .getWatchList!
                                                  .result!
                                                  .length >=
                                              data.tabIndex)
                                      ? ref
                                          .read(marketProvider)
                                          .getWatchList
                                          ?.result![data.tabIndex]
                                          .isPredef
                                      : false;
                              if (!isPredef!) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.watchlistReorder,
                                  arguments: data.tabIndex,
                                );
                                ref.read(marketProvider).marketWatchName();
                              }
                            },
                            onTap: () {
                              if (data.data[index].isIndex! == false) {
                                ref.read(marketHelperProvider).getContractInfo(
                                      context: context,
                                      exchange: data.data[index].ex,
                                      token: data.data[index].token,
                                    );
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
                                    builder: (_) => WatchListBottomSheet(
                                          data: data.data[index],
                                          index: data.tabIndex,
                                        )).whenComplete(() => ref
                                    .read(websocketProvider)
                                    .establishConnection(
                                      channelInput:
                                          '${data.data[index].ex}|${data.data[index].token}',
                                      task: 'ud',
                                    ));
                              } else {
                                IndianIndices indexData = IndianIndices(
                                  segment: data.data[index].segment ?? "",
                                  symbol: data.data[index].symbol,
                                  exchange: data.data[index].ex,
                                  scripName: data.data[index].formattedInsName,
                                  token: data.data[index].token,
                                  change: data.data[index].change!,
                                  high: data.data[index].high!,
                                  low: data.data[index].low!,
                                  ltp: data.data[index].ltp!,
                                  open: data.data[index].open!,
                                  pdc: data.data[index].pdc,
                                  perChange: data.data[index].perChange!,
                                );
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (_) => IndexBottomSheet(
                                          data: indexData,
                                          isDarkMode: isDarkMode,
                                        ));
                              }
                            },
                            child: Column(
                              children: [
                                if (index == 0)
                                  Column(
                                    children: [
                                      SearchAndFilter(
                                        tabIndex: data.tabIndex,
                                        scripCount: data.scripCount,
                                        isHide: false,
                                        updateTab: data.updateTab,
                                      ),
                                    ],
                                  ),
                                Card(
                                  color: isDarkMode
                                      ? colors.kColorBlack
                                      : colors.kColorWhite,
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                            top: index == 0
                                                ? sizes.pad_6
                                                : sizes.pad_16,
                                            bottom: sizes.pad_16,
                                            left: sizes.pad_16,
                                            right: sizes.pad_16,
                                          ),
                                          child: WatchListCard(
                                            key: UniqueKey(),
                                            data: data.data[index],
                                            isBidAskEnable: data.wsCardType,
                                          )),
                                    ],
                                  ),
                                ),
                                index == data.data.length - 1
                                    ? SizedBox()
                                    : horizontalDividerLine(isDarkMode)
                              ],
                            ),
                          );
                  })
              : ListView(
                  key: UniqueKey(),
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  children: [
                    Column(
                      children: [
                        Sizer.half(),
                        SearchAndFilter(
                          tabIndex: data.tabIndex,
                          isHide: false,
                          scripCount: data.scripCount,
                          updateTab: data.updateTab,
                        ),
                        Sizer.vertical10(),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: sizes.pad_16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            itemCount:
                                data.data.length > 30 ? 30 : data.data.length,
                            itemBuilder: (BuildContext context, int index) =>
                                InkWell(
                              onLongPress: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.watchlistReorder,
                                  arguments: data.tabIndex,
                                );
                                ref.read(marketProvider).marketWatchName();
                              },
                              onTap: () {
                                if (data.data[index].isIndex! == false) {
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
                                      builder: (_) => WatchListBottomSheet(
                                            index: data.tabIndex,
                                            data: data.data[index],
                                          )).whenComplete(() => ref
                                      .read(websocketProvider)
                                      .establishConnection(
                                        channelInput:
                                            '${data.data[index].ex}|${data.data[index].token}',
                                        task: 'ud',
                                      ));
                                } else {
                                  log("INDEX");
                                }
                              },
                              child: Card(
                                  elevation: 0,
                                  color: isDarkMode
                                      ? colors.kColorBlack
                                      : colors.kColorWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: WatchlistCardGridView(
                                    key: Key(index.toString()),
                                    data: data.data[index],
                                  )),
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 120,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              crossAxisCount: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}

class NoData extends ConsumerWidget {
  final String errorMsg;
  final bool isShowAddButton;
  const NoData({
    Key? key,
    required this.errorMsg,
    this.isShowAddButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final tabIndex = ref.watch(marketProvider).pref.wlTabIndex;
    return Container(
      color: theme.isDarkMode ? colors.kColorBlack : colors.kColorWhite,
      height: sizes.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assets.noMarketWatchImage,
          ),
          Sizer.vertical48(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes.pad_48),
            child: Text(
              "$errorMsg",
              textAlign: TextAlign.center,
              style: textStyles.kTextSixteenW400.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.isDarkMode
                    ? colors.kColorWhite60
                    : colors.kColorBlack60,
              ),
            ),
          ),
          Sizer.vertical24(),
          Visibility(
            visible: isShowAddButton,
            child: InkWell(
              onTap: () {
                log("TabIndex :::: ${tabIndex}");
                Navigator.pushNamed(
                  context,
                  Routes.watchlistSearch,
                  arguments: tabIndex,
                );
              },
              child: Text(
                'Add New',
                style: textStyles.kTextFourteenW400.copyWith(
                  color: colors.kColorBlueText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchAndFilter extends ConsumerWidget {
  final int tabIndex;
  final bool isHide;
  final int scripCount;
  final Function(int val)? updateTab;
  const SearchAndFilter({
    Key? key,
    required this.tabIndex,
    required this.isHide,
    this.scripCount = 0,
    this.updateTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final market = ref.watch(marketProvider);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: sizes.pad_8,
                horizontal: sizes.pad_12,
              ),
              child: InkWell(
                onTap: () {
                  final isPredef =
                      ref.read(marketProvider).getWatchList != null &&
                              ref.read(marketProvider).getWatchList!.result !=
                                  null &&
                              ref
                                  .read(marketProvider)
                                  .getWatchList!
                                  .result!
                                  .isNotEmpty &&
                              (ref
                                      .read(marketProvider)
                                      .getWatchList!
                                      .result!
                                      .length >=
                                  tabIndex)
                          ? ref
                              .read(marketProvider)
                              .getWatchList
                              ?.result![tabIndex]
                              .isPredef
                          : false;
                  if (!isPredef!) {
                    ref.read(marketHelperProvider).clearSearch();
                    Navigator.pushNamed(
                      context,
                      Routes.watchlistSearch,
                      arguments: tabIndex,
                    );
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        // borderColor: colors.kColorWhite,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorGreyText),
                            borderRadius: BorderRadius.circular(6)),
                        // borderRadius: 6,
                        // enabled: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      // vertical: 10,
                                      left: sizes.pad_12),
                                  child: SvgPicture.asset(
                                    assets.searchIcon,
                                    height: 20,
                                    color: colors.kColorBlue,
                                  ),
                                ),
                                Sizer.horizontal15(),
                                Text(
                                  ('search').tr(),
                                  style: textStyles.kTextFourteenW500.copyWith(
                                      color: isDarkMode
                                          ? colors.kColorWhite
                                          : null),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${scripCount} / ${(ref.read(marketProvider).getWatchList != null && ref.read(marketProvider).getWatchList!.result != null && ref.read(marketProvider).getWatchList!.result!.isNotEmpty && (ref.read(marketProvider).getWatchList!.result!.length >= tabIndex)) ? scripCount : "30"}",
                                  style: textStyles.kTextTwelveW400.copyWith(
                                    color: isDarkMode
                                        ? colors.kColorWhite60
                                        : colors.kColorBlack60,
                                  ),
                                ),
                                if (scripCount == 0) Sizer.halfHorizontal(),
                                isHide
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          // showModalBottomSheet(
                                          //     context: context,
                                          //     backgroundColor: isDarkMode
                                          //         ? colors.kColorAppbarDarkBlack
                                          //         : colors.kColorWhite,
                                          //     shape: const RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.only(
                                          //       topLeft: Radius.circular(20),
                                          //       topRight: Radius.circular(20),
                                          //     )),
                                          //     builder: (context) {
                                          //       return const SizedBox(
                                          //         height: 360,
                                          //         child: FilterBottomSheet(),
                                          //       );
                                          //     });

                                          Navigator.pushNamed(
                                            context,
                                            Routes.watchlistFilter,
                                            arguments: updateTab,
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: sizes.pad_16),
                                                child: SvgPicture.asset(
                                                  assets.filterIcon,
                                                  color: isDarkMode
                                                      ? colors.kColorBlue
                                                      : colors.kColorBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        if (market.filterItemsList.isNotEmpty ||
            market.filterItemsListIndex.isNotEmpty ||
            market.getIsDecending != 'default' ||
            market.getIsUpperPercen != 'default' ||
            market.getIsUpperPrice != 'default' ||
            market.getIsExch != 'default')
          Positioned(
            right: 32,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 1,
                minHeight: 1,
              ),
            ),
          )
        else
          Container()
      ],
    );
  }
}
