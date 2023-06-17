import 'dart:developer';

import 'package:aliceblue/provider/menu_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/portfolio_provider.dart';
import '../../provider/theme_provider.dart';
import '../../res/res.dart';
import '../../shared_widget/svg_icon_button.dart';
import '../menu/top_header/fixed_tab_header.dart';
import 'holdings/holdings_screen.dart';
import 'positions/position_screen.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController controllerPF;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = ref.read(portfolioProvider).pref.portfolioTabIndex;
    log("Haiii");
    controllerPF = TabController(
      length: 2,
      vsync: this,
      initialIndex: ref.read(portfolioProvider).pref.portfolioTabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controllerPF.addListener(() {
        setState(() {
          if (_selectedIndex != controllerPF.index) {
            _selectedIndex = controllerPF.index;
            ref.read(portfolioProvider).changeTabBarIndexPortfolio(
                  value: _selectedIndex,
                  context: context,
                );
          }
        });
      });

      ref.read(portfolioProvider).fetchHoldings(
            context: context,
          );
      ref.read(portfolioProvider).fetchPositions(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    final isFixedHeader = ref.watch(portfolioProvider).pref.isFixedHeader;
    final isHeaderExpanded = ref.watch(menuProvider).isExpanded;
    final portfolioTabs = ref.watch(portfolioProvider).portfolioTabs;
    return Scaffold(
      backgroundColor:
          isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          controller: ScrollController(keepScrollOffset: true),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: isFixedHeader
                    ? null
                    : SliverAppBar(
                        elevation: 0,
                        floating: !isFixedHeader,
                        pinned: true,
                        snap: !isFixedHeader,
                        backgroundColor: isDarkMode
                            ? colors.kColorAppbarDarkTheme
                            : colors.kColorAppbarLightTheme,
                        centerTitle: false,
                        titleSpacing: 0,
                        leading: isFixedHeader
                            ? null
                            : SvgIconButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                assetLink: assets.portfolioIcon,
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack,
                                onPress: () {},
                              ),
                        title: isFixedHeader
                            ? FixedTabHeader()
                            : Text(
                                ('portfolio').tr(),
                                style: textStyles.kTextSixteenW700.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? colors.kColorWhite
                                      : colors.kColorBlack,
                                ),
                              ),
                        actions: [
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(menuProvider)
                                    .changeExpand(!isHeaderExpanded);
                              },
                              icon: Icon(
                                Icons.expand_more_outlined,
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack,
                              )),
                        ],
                        bottom: PreferredSize(
                          preferredSize: Size(
                              sizes.width,
                              ref.watch(portfolioProvider).pref.userLanguage ==
                                      "தமிழ்"
                                  ? 48
                                  : 49),
                          child: Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: TabBar(
                              controller: controllerPF,
                              isScrollable: false,
                              splashFactory: NoSplash.splashFactory,
                              labelStyle: textStyles.kTextTwelveW500,
                              unselectedLabelColor: isDarkMode
                                  ? colors.kColorWhite
                                  : colors.kColorGreyText,
                              unselectedLabelStyle: textStyles.kTextTwelveW400,
                              labelColor: colors.kColorBlue,
                              indicatorSize: TabBarIndicatorSize.label,
                              // unselectedLabelColor: isDarkMode
                              //     ? colors.kColorBottomWhiteTextDarkTheme
                              //     : colors.kColorGreyText,
                              indicatorColor: colors.kColorBlue,

                              padding: EdgeInsets.fromLTRB(
                                sizes.pad_12,
                                0,
                                sizes.pad_12,
                                10,
                              ),
                              tabs: portfolioTabs
                                  .map(
                                    (e) => InkWell(
                                        onLongPress: () {},
                                        onTap: () {
                                          // ref
                                          //     .read(portfolioProvider)
                                          //     .changeSearch(context: context);
                                          // ref
                                          //     .read(portfolioProvider)
                                          //     .setInitialTabIndex(ref
                                          //         .read(portfolioProvider)
                                          //         .pref
                                          //         .portfolioTabIndex);
                                          ref
                                              .read(portfolioProvider)
                                              .changeTabBarIndexPortfolio(
                                                value: portfolioTabs.indexOf(e),
                                                context: context,
                                              );
                                          controllerPF.animateTo(
                                            portfolioTabs.indexOf(e),
                                          );
                                        },
                                        child: Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${(e.split(" ")[0]).tr()} ${e.split(" ")[1]}",
                                                style:
                                                    textStyles.kTextTwelveW500,
                                              ),
                                            ),
                                          ],
                                        ))),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
              ),
            ];
          },
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          body: Padding(
            padding: EdgeInsets.only(top: isFixedHeader ? 0 : 50),
            child: Column(
              children: [
                // Sizer.vertical10(),
                Expanded(
                  child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: controllerPF,
                      children: [HoldingsScreen(), PositionScreen()]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
