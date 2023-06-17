import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:aliceblue/provider/market_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aliceblue/util/sizer.dart';

import '../../../model/market_watch_list_model.dart';
import '../../../provider/market_helper_provider.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../../shared_widget/svg_icon_button.dart';
import '../widgets/watchlist_edit_alert.dart';

class ReOrderScreen extends ConsumerStatefulWidget {
  final int tabIndex;
  const ReOrderScreen({Key? key, required this.tabIndex}) : super(key: key);

  @override
  ReOrderScreenState createState() => ReOrderScreenState();
}

class ReOrderScreenState extends ConsumerState<ReOrderScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(marketHelperProvider).clearDeleteList();
      ref.read(marketProvider).isListOrdered();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).clearSnackBars();
          bool isMwNameChanged = ref.read(marketHelperProvider).isMwNameChange;
          bool isListChanged = ref.read(marketProvider).isListOrdered();
          bool isDeleted =
              ref.read(marketHelperProvider).deleteScripList.isNotEmpty;
          if (isMwNameChanged || isListChanged || isDeleted) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: null,
                      content: WatchListEditAlertDialogBody(
                        message: 'Do you want to save changes?',
                        status: isMwNameChanged && (isListChanged || isDeleted)
                            ? 3
                            : isMwNameChanged
                                ? 2
                                : (isListChanged || isDeleted)
                                    ? 1
                                    : 0,
                      ),
                    ));
          }
          return true;
        },
        child: Scaffold(
            backgroundColor: isDarkMode
                ? colors.kColorAppbarDarkTheme
                : colors.kColorAppbarLightTheme,
            appBar: AppBar(
              backgroundColor: isDarkMode
                  ? colors.kColorAppbarDarkTheme
                  : colors.kColorAppbarLightTheme,
              elevation: 0,
              leading: InkWell(
                onTap: () async {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  bool isMwNameChanged =
                      ref.read(marketHelperProvider).isMwNameChange;
                  bool isListChanged = ref.read(marketProvider).isListOrdered();
                  bool isDeleted =
                      ref.read(marketHelperProvider).deleteScripList.isNotEmpty;
                  if (isMwNameChanged || isListChanged || isDeleted) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              title: null,
                              content: WatchListEditAlertDialogBody(
                                message: 'Do you want to save changes?',
                                status: isMwNameChanged &&
                                        (isListChanged || isDeleted)
                                    ? 3
                                    : isMwNameChanged
                                        ? 2
                                        : (isListChanged || isDeleted)
                                            ? 1
                                            : 0,
                              ),
                            ));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.arrow_back,
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
              ),
              title: Text('Edit watchlist',
                  style: textStyles.kTextSixteenW500.copyWith(
                    color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
                  )),
              actions: const [SaveButton()],
            ),
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                children: [
                  Sizer.vertical10(),
                  const WatchlistRename(),
                  Expanded(
                    child: Card(
                      color:
                          isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                      margin: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Consumer(
                              builder: (context, WidgetRef ref, _) {
                                final market = ref.watch(marketProvider);
                                int activeindex = 0;
                                List<Scrip> list = [];
                                switch (widget.tabIndex) {
                                  case 0:
                                    list = market.getMWScrip1 ?? [];
                                    break;
                                  case 1:
                                    list = market.getMWScrip2 ?? [];
                                    break;
                                  case 2:
                                    list = market.getMWScrip3 ?? [];
                                    break;
                                  case 3:
                                    list = market.getMWScrip4 ?? [];
                                    break;
                                  case 4:
                                    list = market.getMWScrip5 ?? [];
                                    break;
                                  default:
                                }
                                return Theme(
                                  data: ThemeData(
                                    canvasColor: isDarkMode
                                        ? colors.kColorLightDarkBlack
                                        : colors.kColorWhite,
                                  ),
                                  child: ReorderableListView.builder(
                                      itemBuilder: (_, int i) => Column(
                                              key: Key(i.toString()),
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: sizes.pad_6,
                                                      vertical: 08),
                                                  child: ListTile(
                                                    leading: SvgPicture.asset(
                                                      assets.dots,
                                                      color: isDarkMode
                                                          ? colors.kColorWhite
                                                          : colors.kColorBlack,
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            list[i]
                                                                .formattedInsName
                                                                .toUpperCase(),
                                                            style: textStyles
                                                                .kTextFourteenW400
                                                                .copyWith(
                                                                    color: ref
                                                                            .read(
                                                                                themeProvider)
                                                                            .isDarkMode
                                                                        ? colors
                                                                            .kColorWhite
                                                                        : colors
                                                                            .kColorBlack)),
                                                        Sizer.qtr(),
                                                        Text(
                                                            list[i]
                                                                .ex
                                                                .toUpperCase(),
                                                            style: textStyles
                                                                .kTextTwelveW400
                                                                .copyWith(
                                                                    color: ref
                                                                            .read(
                                                                                themeProvider)
                                                                            .isDarkMode
                                                                        ? colors
                                                                            .kColorWhite
                                                                        : colors
                                                                            .kColorGreyText)),
                                                      ],
                                                    ),
                                                    trailing: SvgIconButton(
                                                        onPress: () async {
                                                          MarketWatchAddScripsDatum
                                                              scripListInput =
                                                              MarketWatchAddScripsDatum(
                                                                  exch: list[i]
                                                                      .ex,
                                                                  token: list[i]
                                                                      .token);
                                                          ref
                                                              .read(
                                                                  marketHelperProvider)
                                                              .deleteScripListAdd(
                                                                mwId: market
                                                                    .getWatchList!
                                                                    .result![widget
                                                                        .tabIndex]
                                                                    .mwId!,
                                                                scripsList:
                                                                    scripListInput,
                                                                deleteScrip: [
                                                                  list[i]
                                                                ],
                                                                context:
                                                                    context,
                                                              );
                                                        },
                                                        height: 20,
                                                        color: ref
                                                                .read(
                                                                    themeProvider)
                                                                .isDarkMode
                                                            ? colors.kColorWhite
                                                            : colors
                                                                .kColorBlack,
                                                        assetLink:
                                                            assets.delete),
                                                  ),
                                                ),
                                                horizontalDividerLine(
                                                    isDarkMode),
                                              ]),
                                      itemCount: list.length,
                                      onReorder: (oldIndex, newIndex) {
                                        if (activeindex == oldIndex) {
                                          log("REORDER OLD INDEX ::: $activeindex");
                                        }
                                        log("REORDER OLD INDEX ::: $oldIndex");
                                        log("REORDER NEW INDEX ::: $newIndex");

                                        ref.read(marketProvider).reOrderList(
                                              oldIndex: oldIndex,
                                              newIndex: newIndex,
                                              tabIndex: widget.tabIndex,
                                            );
                                      }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

class WatchlistRename extends ConsumerWidget {
  const WatchlistRename({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketProvide = ref.watch(marketProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Stack(children: [
      Column(
        children: [
          Container(
            height: 25,
            color: isDarkMode
                ? colors.kColorAppbarDarkTheme
                : colors.kColorAppbarLightTheme,
          ),
          Container(
            height: 15,
            decoration: BoxDecoration(
                color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
          ),
          Container(
            color: isDarkMode ? colors.kColorBlack : colors.kColorWhite,
            height: 10,
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          // color: isDarkMode
          //     ? colors.kColorCardHeaderdarkBlack
          //     : colors.kColorAppBar,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? colors.kColorCardHeaderdarkBlack
                  : colors.kColorWhite,
              border: Border.all(
                color: colors.kColorCardHeaderdarkBlack,
                width: 0.1,
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: isDarkMode
                  ? null
                  : const [
                      BoxShadow(
                          color: Color.fromRGBO(221, 224, 255, 0.25),
                          blurRadius: 1,
                          spreadRadius: 0.1,
                          offset: Offset(0, -1)),
                      BoxShadow(
                          color: Color.fromRGBO(221, 224, 255, 0.25),
                          blurRadius: 1,
                          spreadRadius: 0.1,
                          offset: Offset(-1, 0)),
                      BoxShadow(
                          color: Color.fromRGBO(221, 224, 255, 0.25),
                          blurRadius: 1,
                          spreadRadius: 0.1,
                          offset: Offset(0, 1)),
                      BoxShadow(
                          color: Color.fromRGBO(221, 224, 255, 0.25),
                          blurRadius: 1,
                          spreadRadius: 0.1,
                          offset: Offset(1, 0)),
                    ],
            ),
            child: CustomTextFormField(
              contentPadding: 10,
              borderColor: colors.kColorCardHeaderdarkBlack,
              borderRadius: 6,
              onChanged: (value) {
                if (marketProvide.oldMwName != value) {
                  ref.read(marketHelperProvider).mwNameStatus(status: true);
                } else {
                  ref.read(marketHelperProvider).mwNameStatus(status: false);
                }
              },
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
              ],
              controller: marketProvide.watchlistRenameController,
              prefix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: sizes.pad_16,
                          right: sizes.pad_16,
                        ),
                        child: Text(
                          "Name  |",
                          style: textStyles.kTextFourteenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorWhite
                                  : colors.kColorGreyText),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              style: textStyles.kTextFourteenW400.copyWith(
                  color: isDarkMode ? colors.kColorWhite : colors.kColorBlack),
              hintStyle: textStyles.kTextFourteenW400.copyWith(
                  color: isDarkMode
                      ? colors.kColorBottomWhiteTextDarkTheme
                      : colors.kColorGreyText),
              maxCount: 25,
              focusColor: colors.kColorBlue,
              sumitField: (_) {
                if (marketProvide.oldMwName !=
                    marketProvide.watchlistRenameController.text) {
                  ref.read(marketHelperProvider).mwNameStatus(status: true);
                } else {
                  ref.read(marketHelperProvider).mwNameStatus(status: false);
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketProv = ref.watch(marketProvider);
    final watchListViewPro = ref.watch(marketHelperProvider);
    final marketHelpPro = ref.watch(marketHelperProvider);
    bool isMwNameChanged = watchListViewPro.isMwNameChange;
    bool isListChanged = marketProv.isListOrdered();
    bool isDeleted = marketHelpPro.deleteScripList.isNotEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.pad_16,
        vertical: sizes.pad_12,
      ),
      child: InkWell(
        onTap: () {
          if (isMwNameChanged || isListChanged || isDeleted) {
            ref.read(marketHelperProvider).savebutton(
                isMwNameChanged: isMwNameChanged,
                context: context,
                isDeleted: isDeleted,
                isListChanged: isListChanged);
          }
        },
        child: Opacity(
          opacity: isMwNameChanged || isListChanged || isDeleted ? 1 : 0.4,
          child: Container(
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: colors.kColorBlue),
            child: Center(
                child: marketHelpPro.loading
                    ? SizedBox(
                        height: 22,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: colors.kColorWhite,
                          strokeWidth: 1,
                        ))
                    : Text(
                        'Save',
                        style: textStyles.kTextFourteenW400
                            .copyWith(color: colors.kColorWhite),
                      )),
          ),
        ),
      ),
    );
  }
}
