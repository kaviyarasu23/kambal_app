import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import '../../../res/res.dart';

class BottomNavigationBarMain extends ConsumerWidget {
  const BottomNavigationBarMain({
    Key? key,
    required this.currentIndex,
    required this.onMenuItemTap,
  }) : super(key: key);

  final int currentIndex;
  final Function(int index) onMenuItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Builder(builder: (context) {
      return BottomNavigationBar(
        backgroundColor: isDarkMode ? colors.kColorBlack : colors.kColorBlueBgLight,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: colors.kColorBlue,
        selectedFontSize: sizes.text_12,
        unselectedFontSize: sizes.text_12,
        unselectedItemColor:
            isDarkMode ? colors.kColorWhite60 : colors.kColorGreyText,
        iconSize: sizes.text_16,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? SvgPicture.asset(
                    assets.watchlistIcon,
                    color: colors.kColorBlue,
                    // height: 20,
                    // width: 16,
                  )
                : SvgPicture.asset(
                    assets.watchlistIcon,
                    // height: 20,
                    // width: 16,
                    color: isDarkMode
                        ? colors.kColorWhite.withOpacity(0.8)
                        : colors.kColorBlack.withOpacity(0.7),
                  ),
            backgroundColor: Colors.blue,
            label: ('watchlist').tr(),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? SvgPicture.asset(
                    assets.ordersIcon,
                    color: colors.kColorBlue,
                    // height: 22,
                  )
                : SvgPicture.asset(
                    assets.ordersIcon,
                    // height: 22,
                    color: isDarkMode
                        ? colors.kColorWhite.withOpacity(0.8)
                        : colors.kColorBlack.withOpacity(0.7),
                  ),
            backgroundColor: Colors.blue,
            label: ('order').tr(),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? SvgPicture.asset(
                    assets.dashboardIcon,
                    color: colors.kColorBlue,
                    // height: 22,
                  )
                : SvgPicture.asset(
                    assets.dashboardIcon,
                    // height: 22,
                    color: isDarkMode
                        ? colors.kColorWhite.withOpacity(0.8)
                        : colors.kColorBlack.withOpacity(0.7),
                  ),
            backgroundColor: Colors.blue,
            label: ('home').tr(),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? SvgPicture.asset(
                    assets.portfolioIcon,
                    color: colors.kColorBlue,
                    // height: 22,
                  )
                : SvgPicture.asset(
                    assets.portfolioIcon,
                    // height: 22,
                    color: isDarkMode
                        ? colors.kColorWhite.withOpacity(0.8)
                        : colors.kColorBlack.withOpacity(0.7),
                  ),
            backgroundColor: Colors.blue,
            label: ('portfolio').tr(),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? SvgPicture.asset(
                    assets.accountSettingIcon,
                    color: colors.kColorBlue,
                    // height: 20,
                  )
                : SvgPicture.asset(
                    assets.accountSettingIcon,
                    // height: 20,
                    color: isDarkMode
                        ? colors.kColorWhite.withOpacity(0.8)
                        : colors.kColorBlack.withOpacity(0.7),
                  ),
            backgroundColor: Colors.blue,
            label: ('account').tr(),
            tooltip: '',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onMenuItemTap,
      );
    });
  }
}
