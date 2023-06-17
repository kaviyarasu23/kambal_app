import 'dart:developer';

import 'package:aliceblue/model/position_book_model.dart';
import 'package:aliceblue/provider/service_support_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/provider/websocket_provider.dart';

import '../../../../model/ws_tf_feed_model.dart';
import '../../../../res/res.dart';
import '../../../../util/functions.dart';
import '../../../../util/sizer.dart';
class PositionsCard extends ConsumerWidget {
  final PositionBookInfoResult data;
  const PositionsCard({
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
              if (snapshot.data!.lp != null) {
                data.pdc =
                    snapshot.data!.c == null || snapshot.data!.c! == 'null'
                        ? data.pdc
                        : snapshot.data!.c!;
                data.open =
                    snapshot.data!.o == null || snapshot.data!.o! == 'null'
                        ? data.open
                        : snapshot.data!.o!;
                data.high =
                    snapshot.data!.h == null || snapshot.data!.h! == 'null'
                        ? data.high
                        : snapshot.data!.h!;
                data.low =
                    snapshot.data!.l == null || snapshot.data!.l! == 'null'
                        ? data.low
                        : snapshot.data!.l!;
                data.ltp =
                    snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                        ? data.ltp
                        : snapshot.data!.lp!;
                data.volume =
                    snapshot.data!.v == null || snapshot.data!.v! == 'null'
                        ? data.volume
                        : snapshot.data!.v!;
                data.perChange =
                    snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                        ? data.perChange
                        : snapshot.data!.pc!;
                data.change = (double.parse(data.ltp!.replaceAll(",", "")) -
                        double.parse(data.pdc!.replaceAll(",", "")))
                    .toStringAsFixed(2);
                log("PNL LTP POS :: ${data.ltp} CHANGE :: ${data.change} :: PerChange :: ${data.perChange}");
                String pnlVal = (ref
                            .read(serviceSupportProvider)
                            .realisedProfitLoss(data: data) +
                        ref
                            .read(serviceSupportProvider)
                            .unRealisedProfitLoss(data: data))
                    .toStringAsFixed(2);
                String mtmVal = (ref
                            .read(serviceSupportProvider)
                            .realisedProfitLoss(
                              data: data,
                              isTodayPnl: true,
                            ) +
                        ref.read(serviceSupportProvider).unRealisedProfitLoss(
                              data: data,
                              isTodayPnl: true,
                            ))
                    .toStringAsFixed(2);
                data.pnl = pnlVal;
                data.mtm = mtmVal;
                log("POSITION TOTAL PNL CAL ::: INDI ::: $pnlVal");
              }
            }
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_16,
              vertical: sizes.pad_16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            data.displayName!.toUpperCase(),
                            style: textStyles.kTextFourteenW500.copyWith(
                              color: data.netQty != '0'
                                  ? isDarkMode
                                      ? colors.kColorWhite
                                      : colors.kColorBlack
                                  : isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                          .withOpacity(0.7)
                                      : colors.kColorGreyFade,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatCurrencyStandard(value: data.pnl!),
                      style: textStyles.kTextFourteenW500.copyWith(
                        color: isNumberNegative(data.pnl!)
                            ? colors.kColorRed
                            : colors.kColorGreen,
                      ),
                    )
                  ],
                ),
                Sizer.half(),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Qty. ",
                          style: textStyles.kTextElevenW400.copyWith(
                            color: data.netQty.toString() == "0"
                                ? isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                        .withOpacity(0.7)
                                    : colors.kColorGreyFade
                                : isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorBlack,
                          ),
                        ),
                        Text(
                          data.netQty!,
                          style: textStyles.kTextElevenW400.copyWith(
                              color: data.netQty.toString() == "0"
                                  ? isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                          .withOpacity(0.7)
                                      : colors.kColorGreyFade
                                  : isNumberNegative(data.netQty!)
                                      ? colors.kColorRed
                                      : colors.kColorGreen),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        data.product.toString().toUpperCase() == "BO"
                            ? Container(
                                width: 22,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: data.netQty == "0"
                                        ? colors.kColorWhite
                                        : colors.kColorIntradayButton
                                            .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sizes.pad_4,
                                        vertical: sizes.pad_4),
                                    child: Text(
                                      "BO",
                                      style: textStyles
                                          .kTextEightW400
                                          .copyWith(
                                        color: data.netQty == "0"
                                            ? colors.kColorGreyFade
                                            : colors.kColorIntradayButton,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Sizer.qtrHorizontal(),
                        Container(
                          width: 66,
                          height: 20,
                          decoration: BoxDecoration(
                              color: data.netQty == "0"
                                  ? isDarkMode
                                      ? colors
                                          .kColorPositionalContainerDarkTheme
                                          .withOpacity(0.1)
                                      : colors.kColorWhite
                                  : colors.kColorBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: sizes.pad_4,
                                  vertical: sizes.pad_4),
                              child: Text(
                                data.product!.toLowerCase() == "cnc"
                                    ? "HOLDINGS"
                                    : data.product!.toLowerCase() == "nrml"
                                        ? "POSITIONAL"
                                        : data.product!.toLowerCase() == "mis"
                                            ? "INTRADAY"
                                            : "",
                                style: textStyles.kTextEightW400
                                    .copyWith(
                                  color: data.netQty == "0"
                                      ? colors.kColorGreyFade
                                      : colors.kColorBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Sizer.vertical10(),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.exchange!,
                          style: textStyles.kTextElevenW400.copyWith(
                              color: data.netQty.toString() == "0"
                                  ? isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                          .withOpacity(0.7)
                                      : colors.kColorGreyFade
                                  : isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                      : colors.kColorGreyText),
                        ),
                        Sizer.horizontal(),
                        Visibility(
                          visible: data.netQty.toString() != "0",
                          child: Text(
                            "Avg. ",
                            style: textStyles.kTextElevenW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText),
                          ),
                        ),
                        Visibility(
                          visible: data.netQty.toString() != "0",
                          child: Text(
                            isNumberNegative(data.netQty!)
                                ? data.netAvgPrice!
                                : data.netAvgPrice!,
                            style: textStyles.kTextElevenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorBlack,
                            ),
                          ),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "LTP",
                          style: textStyles.kTextElevenW400.copyWith(
                              color: data.netQty.toString() == "0"
                                  ? isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                          .withOpacity(0.7)
                                      : colors.kColorGreyFade
                                  : isDarkMode
                                      ? colors.kColorBottomWhiteTextDarkTheme
                                      : colors.kColorGreyText),
                        ),
                        Sizer.halfHorizontal(),
                        Text(
                          data.ltp!,
                          style: textStyles.kTextElevenW400.copyWith(
                            color: data.netQty.toString() == "0"
                                ? isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                        .withOpacity(0.7)
                                    : colors.kColorGreyFade
                                : isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
