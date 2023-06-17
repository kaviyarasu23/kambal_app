import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import '../../../model/market_watch_list_model.dart';
import '../../../model/ws_tf_feed_model.dart';
import '../../../provider/websocket_provider.dart';
import '../../../res/res.dart';
import '../../../util/functions.dart';
import '../../../util/sizer.dart';

class WatchListCard extends ConsumerWidget {
  final Scrip data;
  final int isBidAskEnable;
  const WatchListCard({
    Key? key,
    required this.data,
    required this.isBidAskEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .tfUpdate
            .stream
            .where((event) => event.tk == data.token),
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == data.token) {
              data.open =
                  snapshot.data!.o == null || snapshot.data!.o! == 'null'
                      ? data.open
                      : snapshot.data!.o!;
              data.high =
                  snapshot.data!.h == null || snapshot.data!.h! == 'null'
                      ? data.high
                      : snapshot.data!.h!;
              data.low = snapshot.data!.l == null || snapshot.data!.l! == 'null'
                  ? data.low
                  : snapshot.data!.l!;
              data.ltp =
                  snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                      ? data.ltp
                      : snapshot.data!.lp!;
              log('LTP VAL ::: WATCH ${data.ltp}');
              data.perChange =
                  snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                      ? data.perChange
                      : snapshot.data!.pc!;
              data.pdc = (!checkIsInfOrNullOrNanOrZero(value: data.pdc) ||
                      (snapshot.data!.c == null || snapshot.data!.c! == 'null'))
                  ? data.pdc
                  : snapshot.data!.c!;
              data.bp =
                  snapshot.data!.bp1 == null || snapshot.data!.bp1! == 'null'
                      ? data.bp
                      : snapshot.data!.bp1!;
              data.bq =
                  snapshot.data!.bq1 == null || snapshot.data!.bq1! == 'null'
                      ? data.bq
                      : snapshot.data!.bq1!;
              data.sq =
                  snapshot.data!.sq1 == null || snapshot.data!.sq1! == 'null'
                      ? data.sq
                      : snapshot.data!.sq1!;
              data.sp =
                  snapshot.data!.sp1 == null || snapshot.data!.sp1! == 'null'
                      ? data.sp
                      : snapshot.data!.sp1!;
              data.volume =
                  snapshot.data!.v == null || snapshot.data!.v! == 'null'
                      ? data.volume
                      : snapshot.data!.v!;
              data.change =
                  (double.parse(data.ltp!) - double.parse(data.pdc)).toString();
            }
          }
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              children: [
                Expanded(
                    child: Wrap(
                  children: [
                    Row(
                      children: [
                        data.ex == 'NFO'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data.formattedInsName.split(" ")[0]} ",
                                    style: textStyles.kTextFourteenW500
                                        .copyWith(
                                      color: isDarkMode
                                          ? colors.kColorWhite
                                          : colors.kColorBlack,
                                    ),
                                  ),
                                  data.splittedTagName!.isNotEmpty &&
                                          data.splittedTagName != ""
                                      ? Text(
                                          "${data.formattedInsName.split(" ")[1].replaceAll("${data.splittedTagName}", "")}",
                                          style: textStyles.kTextFourteenW500
                                              .copyWith(
                                            color: isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorBlack,
                                          ),
                                        )
                                      : Text(
                                          "${data.formattedInsName.split(" ")[1]} ",
                                          style: textStyles.kTextFourteenW500
                                              .copyWith(
                                            color: isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorBlack,
                                          ),
                                        ),
                                  Text(
                                    "${data.formattedInsName.split(" ")[2]} ${data.formattedInsName.split(" ").length > 3 ? data.formattedInsName.split(" ")[3] : ''} ${data.formattedInsName.split(" ").length > 4 ? data.formattedInsName.split(" ")[4] : ''}",
                                    style: textStyles.kTextFourteenW500
                                        .copyWith(
                                      color: isDarkMode
                                          ? colors.kColorWhite
                                          : colors.kColorBlack,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                data.formattedInsName.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: textStyles.kTextFourteenW500.copyWith(
                                  color: isDarkMode
                                      ? colors.kColorWhite
                                      : colors.kColorBlack,
                                ),
                              ),
                      ],
                    ),
                  ],
                )),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getFormatedNumValue(
                        data.ltp ?? '0.00',
                        afterPoint: data.afterPoint!,
                        showSign: false,
                      ),
                      style: textStyles.kTextFourteenW500.copyWith(
                        color: isNumberNegative(data.perChange ?? '0.00')
                            ? colors.kColorRed
                            : colors.kColorGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Sizer.half(),
            Row(
              children: [
                Expanded(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      data.isIndex! ? 'INDICES' : data.ex,
                      style: textStyles.kTextElevenW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorBottomWhiteTextDarkTheme
                            : colors.kColorGreyText,
                      ),
                    ),
                    Sizer.qtrHorizontal(),
                    if (isBidAskEnable != 1)
                      if (isBidAskEnable != 1 &&
                          data.holdQty != "null" &&
                          data.holdQty != "0" &&
                          data.holdQty!.isNotEmpty)
                        SvgPicture.asset(assets.holdBag),
                    if (isBidAskEnable != 1 &&
                        data.holdQty != "null" &&
                        data.holdQty != "0" &&
                        data.holdQty!.isNotEmpty)
                      Sizer.qtrHorizontal(),
                    if (isBidAskEnable != 1 &&
                        data.holdQty != "null" &&
                        data.holdQty != "0" &&
                        data.holdQty!.isNotEmpty)
                      Text(
                        '${data.holdQty}',
                        style: textStyles.kTextElevenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorBottomWhiteTextDarkTheme
                              : colors.kColorGreyText,
                        ),
                      ),
                    if (isBidAskEnable != 1 && !data.isIndex!)
                      Sizer.qtrHorizontal(),
                    if (isBidAskEnable == 1 && !data.isIndex!)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${data.bq} @ ${data.bp}',
                            style: textStyles.kTextElevenW400
                                .copyWith(color: colors.kColorGreen),
                          ),
                          Sizer.horizontal(),
                          Text(
                            '${data.sq} @ ${data.sp}',
                            style: textStyles.kTextElevenW400
                                .copyWith(color: colors.kColorRed),
                          ),
                          if (data.isWeekExpiry!) Sizer.halfHorizontal(),
                          if (data.isWeekExpiry!)
                            Container(
                              constraints: const BoxConstraints(
                                  minWidth: 20, minHeight: 20),
                            )
                        ],
                      ),
                    if (data.isWeekExpiry!) Sizer.halfHorizontal(),
                    if (data.isWeekExpiry!)
                      Container(
                        constraints:
                            const BoxConstraints(minWidth: 20, minHeight: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isDarkMode
                              ? colors.kColorContainerDarkTheme
                              : colors.kColorBlueLightBgDepth,
                        ),
                        child: Center(
                          child: Text(
                            'W',
                            style: textStyles
                                .kTextNineW500
                                .copyWith(
                              color: colors.kColorBlue,
                            ),
                          ),
                        ),
                      ),
                  ]),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getFormatedNumValue(data.change ?? '', afterPoint: 2),
                      style: textStyles.kTextElevenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorBottomWhiteTextDarkTheme
                              : colors.kColorGreyText),
                    ),
                    Sizer.qtrHorizontal(),
                    Text(
                      "(${getFormatedNumValue(data.perChange ?? '', afterPoint: 2)}%)",
                      style: textStyles.kTextElevenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorBottomWhiteTextDarkTheme
                              : colors.kColorGreyText),
                    )
                  ],
                )
              ],
            ),
            if (isBidAskEnable == 2 && !data.isIndex!) Sizer.half(),
            if (isBidAskEnable == 2 && !data.isIndex!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${data.bq} @ ${data.bp}",
                        style: textStyles.kTextTwelveW400
                            .copyWith(color: colors.kColorGreen),
                      ),
                      Sizer.halfHorizontal(),
                      Text(
                        "${data.sq} @ ${data.sp}",
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
          ]);
        });
  }
}

class WatchlistCardGridView extends ConsumerWidget {
  final Scrip data;

  const WatchlistCardGridView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .tfUpdate
            .stream
            .where((event) => event.tk == data.token),
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == data.token) {
              data.open =
                  snapshot.data!.o == null || snapshot.data!.o! == 'null'
                      ? data.open
                      : snapshot.data!.o!;
              data.high =
                  snapshot.data!.h == null || snapshot.data!.h! == 'null'
                      ? data.high
                      : snapshot.data!.h!;
              data.low = snapshot.data!.l == null || snapshot.data!.l! == 'null'
                  ? data.low
                  : snapshot.data!.l!;
              data.ltp =
                  snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                      ? data.ltp
                      : snapshot.data!.lp!;
              log('LTP VAL ::: WATCH ${data.ltp}');
              data.perChange =
                  snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                      ? data.perChange
                      : snapshot.data!.pc!;
              data.pdc = (!checkIsInfOrNullOrNanOrZero(value: data.pdc) ||
                      (snapshot.data!.c == null || snapshot.data!.c! == 'null'))
                  ? data.pdc
                  : snapshot.data!.c!;
              data.bp =
                  snapshot.data!.bp1 == null || snapshot.data!.bp1! == 'null'
                      ? data.bp
                      : snapshot.data!.bp1!;
              data.bq =
                  snapshot.data!.bq1 == null || snapshot.data!.bq1! == 'null'
                      ? data.bq
                      : snapshot.data!.bq1!;
              data.sq =
                  snapshot.data!.sq1 == null || snapshot.data!.sq1! == 'null'
                      ? data.sq
                      : snapshot.data!.sq1!;
              data.sp =
                  snapshot.data!.sp1 == null || snapshot.data!.sp1! == 'null'
                      ? data.sp
                      : snapshot.data!.sp1!;
              data.volume =
                  snapshot.data!.v == null || snapshot.data!.v! == 'null'
                      ? data.volume
                      : snapshot.data!.v!;
              data.change =
                  (double.parse(data.ltp!) - double.parse(data.pdc)).toString();
            }
          }
          return Container(
            decoration: BoxDecoration(
              color: isNumberNegative(data.perChange ?? '0')
                  ? isDarkMode
                      ? colors.kColorLightRedWSDarkTheme
                      : colors.kColorLightGreenLightTheme
                  : isDarkMode
                      ? colors.kColorLightGreenWSDarkTheme
                      : colors.kColorLightRedLightTheme,
              border: Border.all(
                color: isNumberNegative(data.perChange ?? '0')
                    ? colors.kColorRed
                    : colors.kColorGreen,
                width: 0.25,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_12,
                vertical: sizes.pad_12,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 29,
                            child: Text(
                              data.formattedInsName.toUpperCase(),
                              style: textStyles.kTextFourteenW500.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Sizer.vertical10(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          getFormatedNumValue(
                            data.ltp ?? '0',
                            afterPoint: 2,
                            showSign: false,
                          ),
                          style: textStyles.kTextSixW500.copyWith(
                            color: isNumberNegative(data.perChange ?? '0')
                                ? colors.kColorRed
                                : colors.kColorGreen,
                          ),
                        ),
                      ],
                    ),
                    Sizer.half(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          getFormatedNumValue(data.change ?? '0',
                              afterPoint: 2),
                          style: textStyles.kTextElevenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorGreyText),
                        ),
                        Sizer.qtrHorizontal(),
                        Text(
                          " (${getFormatedNumValue(data.perChange ?? '0', afterPoint: 2)}%)",
                          style: textStyles.kTextElevenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorGreyText),
                        ),
                      ],
                    )
                  ]),
            ),
          );
        });
  }
}
