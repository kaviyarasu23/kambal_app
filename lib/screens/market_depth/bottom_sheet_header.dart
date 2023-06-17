import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/market_depth_model.dart';
import '../../model/ws_tf_feed_model.dart';
import '../../provider/websocket_provider.dart';
import '../../res/res.dart';
import '../../shared_widget/snack_bar.dart';
import '../../util/functions.dart';
import '../../util/sizer.dart';

class BottomSheetHeader extends ConsumerWidget {
  final bool isShowAlert;
  final BottomSheetInput data;

  const BottomSheetHeader({
    Key? key,
    required this.data,
    this.isShowAlert = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    log("REDE");
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .tfUpdate
            .stream
            .where((event) => event.tk == data.token),
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == data.token) {
              data.pdc = snapshot.data!.c == null ||
                      snapshot.data!.c == 'null' ||
                      snapshot.data!.c == '0'
                  ? data.pdc
                  : snapshot.data!.c!;
              data.ltp = snapshot.data!.lp == null ||
                      snapshot.data!.lp == 'null' ||
                      snapshot.data!.lp == '0'
                  ? data.ltp
                  : snapshot.data!.lp!;
              data.change =
                  (double.parse(data.ltp) - double.parse(data.pdc)).toString();
              data.perChange = snapshot.data!.pc == null ||
                      snapshot.data!.pc == 'null' ||
                      snapshot.data!.pc == '0'
                  ? data.perChange
                  : snapshot.data!.pc!;
              log("HEADER TICK :: ${data.ltp} :: FEED ::: ${snapshot.data!.lp}");
            }
          }
          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    left: sizes.pad_16,
                    right: sizes.pad_16,
                    top: sizes.pad_16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.scripName.toUpperCase(),
                          style: textStyles.kTextFourteenW400.copyWith(
                            color: ref.read(themeProvider).isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorBlack,
                          ),
                        ),
                      ),
                      Text(
                        data.exchange.toUpperCase(),
                        style: textStyles.kTextTwelveW400.copyWith(
                          color: ref.read(themeProvider).isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorGreyDark,
                        ),
                      ),
                    ],
                  )),
              Sizer.vertical10(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  getFormatedNumValue(
                                    data.ltp,
                                    afterPoint:
                                        (data.exchange.toLowerCase() == 'cds' ||
                                                data.exchange.toLowerCase() ==
                                                    'bcd')
                                            ? 4
                                            : 2,
                                    showSign: false,
                                  ),
                                  style: textStyles.kTextTwelveW400.copyWith(
                                    color: getFormatedNumValue(
                                              data.perChange ?? "0.00",
                                              afterPoint: 2,
                                            ) ==
                                            "00.00"
                                        ? colors.kColorGreyDark
                                        : isNumberNegative(
                                                data.perChange ?? "0.00")
                                            ? colors.kColorRed
                                            : colors.kColorGreen,
                                  )),
                              Sizer.halfHorizontal(),
                              Text(
                                  "${getFormatedNumValue(
                                    data.change ?? "0.00",
                                    afterPoint: 2,
                                  )} (${getFormatedNumValue(
                                    data.perChange ?? "0.00",
                                    afterPoint: 2,
                                  )}%)",
                                  style: textStyles.kTextTwelveW400.copyWith(
                                    color: ref.read(themeProvider).isDarkMode
                                        ? colors.kColorBottomWhiteTextDarkTheme
                                        : colors.kColorGreyDark,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              data.transType != null
                                  ? Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 20,
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              data.transType!.toLowerCase() ==
                                                      'b'
                                                  ? colors.kColorGreen
                                                      .withOpacity(0.1)
                                                  : colors.kColorRed
                                                      .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Center(
                                        child: Text(
                                          "${data.transType!.toLowerCase() == 'b' ? 'BUY' : 'SELL'}",
                                          style:
                                              textStyles.kTextTenW400.copyWith(
                                            color:
                                                data.transType!.toLowerCase() ==
                                                        'b'
                                                    ? colors.kColorGreen
                                                    : colors.kColorRed,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Sizer.halfHorizontal(),
                              data.transType != null
                                  ? Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 66,
                                        maxHeight: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (data.status!.toLowerCase() ==
                                                    'open' ||
                                                data.status!.toLowerCase() ==
                                                    'trigger pending' ||
                                                data.status!.toLowerCase() ==
                                                    'pending')
                                            ? isDarkMode
                                                ? colors.kColorYelowBgLightTheme
                                                : colors.kColorYelowBgLightTheme
                                            : data.status!.toLowerCase() ==
                                                    "rejected"
                                                ? isDarkMode
                                                    ? colors
                                                        .kColorRedDarkThemeBg
                                                    : colors.kColorLightRed
                                                : data.status!.toLowerCase() ==
                                                        "complete"
                                                    ? isDarkMode
                                                        ? colors
                                                            .kColorLightGreenDarkTheme
                                                        : colors
                                                            .kColorLightGreen
                                                    : isDarkMode
                                                        ? colors
                                                            .kColorLightGreyDarkTheme
                                                        : colors
                                                            .kColorLightGrey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data.status ?? "COMPLETED",
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              textStyles.kTextTenW400.copyWith(
                                            color: (data.status!
                                                            .toLowerCase() ==
                                                        'open' ||
                                                    data.status!
                                                            .toLowerCase() ==
                                                        'trigger pending' ||
                                                    data.status!
                                                            .toLowerCase() ==
                                                        'pending')
                                                ? isDarkMode
                                                    ? colors
                                                        .kColorYellowDarkThemeText
                                                    : colors.kColorYellowSearch
                                                : data.status!
                                                            .toLowerCase() ==
                                                        "rejected"
                                                    ? isDarkMode
                                                        ? colors
                                                            .kColorRedTextDarkTheme
                                                        : colors.kColorRed
                                                    : data
                                                                .status!
                                                                .toLowerCase() ==
                                                            "complete"
                                                        ? isDarkMode
                                                            ? colors
                                                                .kColorGreenDarkTheme
                                                            : colors.kColorGreen
                                                        : isDarkMode
                                                            ? colors
                                                                .kColorGreyDarkTheme
                                                            : colors
                                                                .kColorBlack,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Sizer.halfHorizontal(),
                              Visibility(
                                visible: isShowAlert,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Navigator.pushNamed(
                                            //     context, Routes.newAlert,
                                            //     arguments: false);
                                            // ScripAlertInput input =
                                            //     ScripAlertInput(
                                            //   exch: data.exchange,
                                            //   token: data.token,
                                            //   value: data.ltp,
                                            //   scripName: data.scripName,
                                            //   perChange: data.perChange ?? "0.00",
                                            //   change: data.change ?? "0.00",
                                            //   isEdit: false,
                                            //   tradingSymbol: '',
                                            // );
                                            // ref
                                            //     .read(alertListProvider)
                                            //     .setData(input);
                                          },
                                          child: SvgPicture.asset(
                                            assets.alertIcon,
                                            height: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
              Sizer.vertical16(),
              horizontalDividerLine(ref.read(themeProvider).isDarkMode),
            ],
          );
        });
  }
}
