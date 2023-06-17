import 'dart:developer';

import 'package:aliceblue/provider/menu_provider.dart';
import 'package:aliceblue/provider/tab_controller_provider.dart';
import 'package:aliceblue/provider/web_scoket_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/theme_provider.dart';
import '../../../provider/websocket_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../market_watch/market_watch_screen.dart';
import '../../orders/order_screen.dart';
import '../../portfolio/portfolio_screen.dart';
import '../../setitngs/settings_screen.dart';
import '../bottom_tab/bottom_navigation_bar.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(tabControllProvider).setContext(cxt: context);
      ref.read(menuProvider).initialCallService();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("Life Cycle ::: $state");
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (ref.read(webscoketHelperProvider).isWebscoketConnected) {
          ref.read(websocketProvider).closeSocket();
        }

        break;
      case AppLifecycleState.resumed:
        log("APP resumed");
        ref.read(webscoketHelperProvider).heartBeatStateChange(isStart: true);
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).isDarkMode;
    final isExpanded = ref.watch(menuProvider).isExpanded;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const Expanded(child: MainBody()),
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    ref.read(menuProvider).changeExpand(false);
                  }
                });
              },
              child: IgnorePointer(
                ignoring: isExpanded,
                child:
                    Opacity(opacity: isExpanded ? 0.3 : 1, child: BottomBar()),
              ))),
    );
  }
}

class MainBody extends ConsumerWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuProvide = ref.watch(menuProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      color: isDarkMode ? colors.kColorBlack : null,
      child: InkWell(
        onTap: () {
          if (menuProvide.isExpanded) {
            menuProvide.changeExpand(false);
          }
        },
        child: IgnorePointer(
          ignoring: menuProvide.isExpanded,
          child: Opacity(
            opacity: menuProvide.isExpanded ? 0.1 : 1,
            child: Column(
              children: [
                Expanded(
                  child: menuProvide.tabIndex == 0
                      ? const MarketWatchScreen()
                      : menuProvide.tabIndex == 1
                          ? const OrderScreen()
                          : menuProvide.tabIndex == 2
                              ? const DashboardScreen()
                              : menuProvide.tabIndex == 3
                                  ? const PortfolioScreen()
                                  : menuProvide.tabIndex == 4
                                      ? const SettingsScreen()
                                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBar extends ConsumerWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(menuProvider).tabIndex;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        horizontalDividerLine(isDarkMode, height: 1.5, thickness: 1.5),
        BottomNavigationBarMain(
            currentIndex: tabIndex,
            onMenuItemTap: ((index) {
              ref.read(menuProvider).changeTabIndex(index, context);
            })),
      ],
    );
  }
}
