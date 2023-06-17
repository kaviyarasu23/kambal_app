import 'dart:developer';

import 'package:aliceblue/provider/market_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../model/market_watch_list_model.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../../util/sizer.dart';
import 'widgets/customize_save_alert.dart';

class WatchlistFilterScreen extends ConsumerStatefulWidget {
  final Function(int val)? updateTab;
  const WatchlistFilterScreen({
    Key? key,
    this.updateTab,
  }) : super(key: key);

  @override
  ConsumerState<WatchlistFilterScreen> createState() =>
      _WatchlistFilterScreenState();
}

class _WatchlistFilterScreenState extends ConsumerState<WatchlistFilterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(marketProvider).initialFilterOption();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final marketProv = ref.watch(marketProvider);
    final exchangeList = ref.watch(marketProvider).getExchangeList;
    final marketScripType =
        ref.watch(marketProvider).dummyWatchlistScripShowModel;
    final getIsDecending = ref.watch(marketProvider).getIsDecending;
    final getIsUpperPrice = ref.watch(marketProvider).getIsUpperPrice;
    final getIsUpperPercen = ref.watch(marketProvider).getIsUpperPercen;
    log("WS VIEW ::: ${marketProv.isWSListView}");
    log("DESENDING ORDER ::: ${getIsDecending}");
    return WillPopScope(
        onWillPop: () async {
          if (ref.read(marketProvider).checkFilterChanges()) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: null,
                      content: CustomizeEditAlertDialogBody(
                        updateTab: widget.updateTab,
                        message: 'Do you want to save changes?',
                      ),
                    ));
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Manage Watchlist",
              style: textStyles.kTextSixteenW600.copyWith(
                color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
              ),
            ),
            elevation: 0.5,
          ),
          bottomNavigationBar: WatchlistFilterFooter(
            updateTab: widget.updateTab,
          ),
          body: ListView(children: [
            Sizer.vertical10(),
            WatchlistFilterDefaultTabItem(
              title: "NIFTY",
              value: marketProv.isDefaultTabNiftyEnable,
              stockCount: 50,
              icon: SvgPicture.asset(
                assets.defaultMWTabIcon,
                color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
              ),
              onTap: (bool) {
                ref.read(marketProvider).setDefaultTabChange(
                    status: bool, title: 'nifty', updateTab: widget.updateTab!);
              },
            ),
            horizontalDividerLine(isDarkMode),
            WatchlistFilterDefaultTabItem(
              title: "BANKNIFTY",
              value: marketProv.isDefaultTabBankNiftyEnable,
              stockCount: 12,
              icon: SvgPicture.asset(
                assets.defaultMWTabIcon,
                color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
              ),
              onTap: (bool) {
                ref.read(marketProvider).setDefaultTabChange(
                    status: bool,
                    title: 'banknifty',
                    updateTab: widget.updateTab!);
              },
            ),
            horizontalDividerLine(isDarkMode),
            WatchlistFilterDefaultTabItem(
              title: "SENSEX",
              value: marketProv.isDefaultTabSensexEnable,
              stockCount: 30,
              icon: SvgPicture.asset(
                assets.defaultMWTabIcon,
                color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
              ),
              onTap: (bool) {
                ref.read(marketProvider).setDefaultTabChange(
                    status: bool,
                    title: 'sensex',
                    updateTab: widget.updateTab!);
              },
            ),
            horizontalDividerLine(isDarkMode),
            Sizer.vertical10(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
                vertical: sizes.pad_12,
              ),
              child: Text(
                "Customize Watchlist View",
                style: textStyles.kTextSixteenW500,
              ),
            ),
            Wrap(
              children: [
                ViewButtonRadioItem(
                  groupValue: marketProv.wsCardType,
                  value: 0,
                  title: "Basic",
                  onTap: (value) {
                    ref
                        .read(marketProvider)
                        .changeCardType(selectedCardTypeVal: value ?? 0);
                  },
                ),
                ViewButtonRadioItem(
                  groupValue: marketProv.wsCardType,
                  value: 1,
                  title: "Depth",
                  onTap: (value) {
                    ref
                        .read(marketProvider)
                        .changeCardType(selectedCardTypeVal: value ?? 0);
                  },
                ),
                ViewButtonRadioItem(
                  groupValue: marketProv.wsCardType,
                  value: 2,
                  title: "All",
                  onTap: (value) {
                    ref
                        .read(marketProvider)
                        .changeCardType(selectedCardTypeVal: value ?? 0);
                  },
                ),
              ],
            ),
            Sizer.vertical10(),
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              child: WatchlistViewModelBox(
                data: marketScripType[marketProv.pref.wsCardType],
              ),
            ),
            Sizer.vertical20(),
            horizontalDividerLine(isDarkMode),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
                vertical: sizes.pad_12,
              ),
              child: Text(
                "Watchlist Tile",
                style: textStyles.kTextSixteenW500,
              ),
            ),
            Wrap(
              children: [
                ViewButtonRadioItem(
                  groupValue: marketProv.isWSListView ? 0 : 1,
                  value: 0,
                  title: "List",
                  onTap: (value) {
                    ref.read(marketProvider).changeView(tilesChoice: true);
                  },
                ),
                ViewButtonRadioItem(
                  groupValue: marketProv.isWSListView ? 0 : 1,
                  value: 1,
                  title: "Grid",
                  onTap: (value) {
                    ref.read(marketProvider).changeView(tilesChoice: false);
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
                vertical: sizes.pad_12,
              ),
              child: Text(
                "Filter",
                style: textStyles.kTextSixteenW500,
              ),
            ),
            Sizer.vertical10(),
            Padding(
                padding: EdgeInsets.only(left: sizes.pad_16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        for (var item in exchangeList)
                          Padding(
                            padding: EdgeInsets.only(
                                right: sizes.pad_12, bottom: sizes.pad_12),
                            child: OutlineButtonBox(
                              name: item,
                            ),
                          ),
                      ],
                    ))),
            Sizer.vertical16(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
                vertical: sizes.pad_12,
              ),
              child: Text(
                "Sort",
                style: textStyles.kTextSixteenW500,
              ),
            ),
            Sizer.vertical10(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
              child: PositionFilterSort(
                leading: getIsDecending == 'default'
                    ? Text(
                        'A-Z',
                        style: textStyles.kTextFourteenW400,
                      )
                    : Icon(
                        getIsDecending == 'up'
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: getIsDecending != 'default'
                            ? colors.kColorBlue
                            : null,
                      ),
                titleName: 'Alphabetically',
                onTap: () {
                  ref.read(marketProvider).sortAlphabets(false);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
              child: PositionFilterSort(
                leading: getIsUpperPrice == 'default'
                    ? Text(
                        'LTP',
                        style: textStyles.kTextFourteenW400,
                      )
                    : Icon(
                        getIsUpperPrice == 'up'
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: getIsUpperPrice != 'default'
                            ? colors.kColorBlue
                            : null,
                      ),
                titleName: 'Last Traded Price',
                onTap: () {
                  ref.read(marketProvider).sortLastTradePrice(false);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
              child: PositionFilterSort(
                leading: getIsUpperPercen == 'default'
                    ? Text(
                        '%',
                        style: textStyles.kTextFourteenW400,
                      )
                    : Icon(
                        getIsUpperPercen == 'up'
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: getIsUpperPercen != 'default'
                            ? colors.kColorBlue
                            : null,
                      ),
                titleName: 'Change',
                onTap: () {
                  ref.read(marketProvider).sortPercentageChange(false);
                },
              ),
            ),
            horizontalDividerLine(isDarkMode),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
                vertical: sizes.pad_12,
              ),
              child: Text(
                "Add Symbol Preference",
                style: textStyles.kTextSixteenW500,
              ),
            ),
            Sizer.vertical10(),
            Wrap(
              children: [
                ViewButtonRadioItem(
                  groupValue: marketProv.pref.isMWScripAddTop! ? 0 : 1,
                  value: 0,
                  title: "Top",
                  onTap: (value) {
                    ref.read(marketProvider).changeAddPreference(choice: true);
                  },
                ),
                ViewButtonRadioItem(
                  groupValue: marketProv.pref.isMWScripAddTop! ? 0 : 1,
                  value: 1,
                  title: "Bottom",
                  onTap: (value) {
                    ref.read(marketProvider).changeAddPreference(choice: false);
                  },
                ),
              ],
            ),
          ]),
        ));
  }
}

class WatchlistFilterDefaultTabItem extends ConsumerWidget {
  final String title;
  final Widget? icon;
  final bool value;
  final int? stockCount;
  final Function(bool)? onTap;
  const WatchlistFilterDefaultTabItem({
    Key? key,
    this.icon,
    this.onTap,
    this.stockCount,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return InkWell(
      onTap: () {
        this.onTap!(!value);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes.pad_16,
          vertical: sizes.pad_12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) Sizer.horizontal(),
                  Text(
                    '$title',
                    style: textStyles.kTextSixteenW400,
                  ),
                  if (stockCount != null) Sizer.horizontal(),
                  if (stockCount != null)
                    Container(
                      color: isDarkMode
                          ? colors.kColorWhite60
                          : colors.kColorGreyBg,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "$stockCount Stock${stockCount! > 1 ? 's' : ''}",
                          style: textStyles.kTextTwelveW400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Transform.scale(
              transformHitTests: false,
              scale: 0.5,
              alignment: Alignment.centerRight,
              child: CupertinoSwitch(
                value: value,
                activeColor: colors.kColorBlue,
                onChanged: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketwatchNameList extends ConsumerWidget {
  final String title;
  final Icon? icon;
  final int? stockCount;
  final VoidCallback? shareClick;
  final VoidCallback? editClick;
  final VoidCallback? deleteClick;

  const MarketwatchNameList({
    Key? key,
    required this.icon,
    required this.stockCount,
    required this.title,
    this.deleteClick,
    this.editClick,
    this.shareClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.pad_16,
        vertical: sizes.pad_12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) icon!,
                if (icon != null) Sizer.halfHorizontal(),
                Text(
                  '$title',
                  style: textStyles.kTextSixteenW400,
                ),
                if (stockCount != null) Sizer.horizontal(),
                if (stockCount != null)
                  Container(
                    color:
                        isDarkMode ? colors.kColorWhite60 : colors.kColorGreyBg,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "$stockCount Stock${stockCount! > 1 ? 's' : ''}",
                        style: textStyles.kTextTwelveW400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: shareClick,
            child: Icon(
              Icons.share,
              size: 16,
              color: isDarkMode ? colors.kColorWhite60 : colors.kColorBlack60,
            ),
          ),
          Sizer.horizontal(),
          InkWell(
            onTap: editClick,
            child: Icon(
              Icons.edit,
              size: 16,
              color: isDarkMode ? colors.kColorWhite60 : colors.kColorBlack60,
            ),
          ),
          Sizer.horizontal(),
          InkWell(
            onTap: deleteClick,
            child: Icon(
              Icons.delete,
              size: 16,
              color: isDarkMode ? colors.kColorWhite60 : colors.kColorBlack60,
            ),
          )
        ],
      ),
    );
  }
}

class AddWatchListRow extends ConsumerWidget {
  final bool isShowAddButton;
  const AddWatchListRow({
    Key? key,
    this.isShowAddButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: isShowAddButton,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes.pad_16,
          vertical: sizes.pad_12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 24,
              color: colors.kColorBlue,
            ),
            Sizer.halfHorizontal(),
            Text(
              "Add Watchlist",
              style: textStyles.kTextSixteenW400,
            )
          ],
        ),
      ),
    );
  }
}

class ViewButtonRadioItem extends ConsumerWidget {
  final String title;
  final int value;
  final int groupValue;
  final Function(int?)? onTap;
  const ViewButtonRadioItem({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        this.onTap!(value);
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: colors.kColorGreyText,
                ),
                child: Radio<int>(
                  value: value,
                  activeColor: colors.kColorBlue,
                  groupValue: groupValue,
                  onChanged: onTap,
                ),
              ),
              Text(
                title,
                style: textStyles.kTextFourteenW400.copyWith(
                  color: ref.read(themeProvider).isDarkMode
                      ? colors.kColorBottomWhiteTextDarkTheme
                      : colors.kColorGreyText,
                ),
              ),
            ],
          )),
    );
  }
}

class WatchlistViewModelBox extends ConsumerWidget {
  final CustomizeWatchlistModel data;
  const WatchlistViewModelBox({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedScripType = ref.watch(marketProvider).pref.wsCardType;
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.pad_16,
      ),
      child: Container(
        color: data.value == selectedScripType
            ? isDarkMode
                ? colors.kColorLightBlueDarkTheme
                : colors.kColorBlueBgLight
            : isDarkMode
                ? colors.kColorWhite30
                : colors.kColorBlack30,
        child: Padding(
          padding: EdgeInsets.all(
            sizes.pad_12,
          ),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${data.scripName}",
                    style: textStyles.kTextFourteenW500,
                  ),
                ),
                Text(
                  "${getFormatedNumValue(
                    data.ltp,
                    afterPoint: 2,
                    showSign: false,
                  )}",
                  style: textStyles.kTextFourteenW500.copyWith(
                    color: isNumberNegative(data.perChange ?? '0')
                        ? colors.kColorRed
                        : colors.kColorGreen,
                  ),
                ),
              ],
            ),
            Sizer.half(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${data.exchange}",
                      style: textStyles.kTextTwelveW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite60
                            : colors.kColorBlack60,
                      ),
                    ),
                    Sizer.half(),
                    if (data.value != 1) Sizer.halfHorizontal(),
                    if (data.value != 1)
                      SvgPicture.asset(
                        assets.portfolioIcon,
                        width: 16,
                        height: 16,
                      ),
                    if (data.value != 1) Sizer.qtrHorizontal(),
                    if (data.value != 1)
                      Text(
                        "${data.holdQty}",
                        style: textStyles.kTextTwelveW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        ),
                      ),
                    if (data.value == 1)
                      Row(
                        children: [
                          Sizer.halfHorizontal(),
                          Text(
                            "${data.bidQty} @ ${data.bidPrice}",
                            style: textStyles.kTextTwelveW400
                                .copyWith(color: colors.kColorGreen),
                          ),
                          Sizer.halfHorizontal(),
                          Text(
                            "${data.askQty} @ ${data.askPrice}",
                            style: textStyles.kTextTwelveW400
                                .copyWith(color: colors.kColorRed),
                          ),
                        ],
                      )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${data.change}",
                      style: textStyles.kTextTwelveW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite60
                            : colors.kColorBlack60,
                      ),
                    ),
                    Sizer.qtrHorizontal(),
                    Text(
                      "(${data.perChange}%)",
                      style: textStyles.kTextTwelveW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite60
                            : colors.kColorBlack60,
                      ),
                    )
                  ],
                ),
              ],
            ),
            if (data.value == 2) Sizer.half(),
            if (data.value == 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${data.bidQty} @ ${data.bidPrice}",
                        style: textStyles.kTextTwelveW400
                            .copyWith(color: colors.kColorGreen),
                      ),
                      Sizer.halfHorizontal(),
                      Text(
                        "${data.askQty} @ ${data.askPrice}",
                        style: textStyles.kTextTwelveW400
                            .copyWith(color: colors.kColorRed),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Vol : ${convertCurrencyHumanRead(value: data.volume ?? '0')}",
                        style: textStyles.kTextTwelveW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        ),
                      )
                    ],
                  ),
                ],
              ),
          ]),
        ),
      ),
    );
  }
}

class OutlineButtonBox extends ConsumerWidget {
  final String name;
  const OutlineButtonBox({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketProvide = ref.watch(marketProvider);
    final theme = ref.watch(themeProvider);
    final bool isSelected = marketProvide.checkIsFilterItemSelected(item: name);
    return SizedBox(
      height: 32,
      child: OutlinedButton(
          onPressed: () {
            marketProvide.addRemoveFilterPosition(selectedValue: name);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: 0.3,
                color: isSelected ? colors.kColorBlue : colors.kColorBlack),
            backgroundColor: isSelected
                ? colors.kColorBlue
                : theme.isDarkMode
                    ? colors.kColorGreyMidDarktheme
                    : colors.kColorWhite,
          ),
          child: Text(
            name,
            style: textStyles.kTextFourteenW400.copyWith(
                color: isSelected
                    ? colors.kColorWhite
                    : theme.isDarkMode
                        ? colors.kColorWhite
                        : colors.kColorBlack,
                fontWeight: FontWeight.w500),
          )),
    );
  }
}

class PositionFilterSort extends ConsumerWidget {
  final Widget leading;
  final String titleName;
  final Widget? trailing;
  final VoidCallback onTap;
  const PositionFilterSort({
    Key? key,
    required this.leading,
    required this.titleName,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        dense: true,
        leading: leading,
        horizontalTitleGap: 5,
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          titleName,
          style: textStyles.kTextFourteenW400,
        ),
        trailing: trailing,
      ),
    );
  }
}

class WatchlistFilterFooter extends ConsumerWidget {
  final Function(int val)? updateTab;
  const WatchlistFilterFooter({
    Key? key,
    this.updateTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_16,
            ),
            child: Row(
              children: [
                Expanded(
                    child: OutlineButtonBoxBottomBar(
                  name: 'Clear',
                  borderRadius: 8,
                  onTap: () {
                    ref.read(marketProvider).clearFilter();
                    Navigator.pop(context);
                  },
                )),
                Sizer.horizontal24(),
                Expanded(
                    child: OutlineButtonBoxBottomBar(
                  name: "Apply",
                  borderRadius: 8,
                  isSelected: true,
                  onTap: () {
                    ref.read(marketProvider).saveFilter(updateTab: updateTab);
                    Navigator.pop(context);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OutlineButtonBoxBottomBar extends ConsumerWidget {
  final String name;
  final VoidCallback? onTap;
  final bool isSelected;
  final double? borderRadius;
  const OutlineButtonBoxBottomBar({
    Key? key,
    required this.name,
    this.onTap,
    this.borderRadius,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return SizedBox(
      height: 40,
      child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
            ),
            side: BorderSide(
              width: 0.3,
              color: isSelected ? colors.kColorBlue : colors.kColorBlack,
            ),
            backgroundColor: isSelected
                ? colors.kColorBlue
                : theme.isDarkMode
                    ? colors.kColorGreyMidDarktheme
                    : colors.kColorWhite,
          ),
          child: Text(
            name,
            style: textStyles.kTextFourteenW400.copyWith(
                color: isSelected
                    ? colors.kColorWhite
                    : theme.isDarkMode
                        ? colors.kColorWhite
                        : colors.kColorBlack,
                fontWeight: FontWeight.w500),
          )),
    );
  }
}
