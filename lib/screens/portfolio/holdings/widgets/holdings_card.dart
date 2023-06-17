import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/holding_book_model.dart';
import '../../../../model/ws_tf_feed_model.dart';
import '../../../../provider/websocket_provider.dart';
import '../../../../res/res.dart';
import '../../../../util/functions.dart';
import '../../../../util/sizer.dart';

class HoldingsCard extends ConsumerWidget {
  final Holding data;
  final bool isDarkMode;
  const HoldingsCard({
    Key? key,
    required this.data,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log("P & L:::: 11 ${data.netPnl}");
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .tfUpdate
            .stream
            .where((event) => event.tk == data.symbol![0].token),
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == data.symbol![0].token) {
              if (snapshot.data!.lp != null) {
                data.symbol![0].pdc =
                    snapshot.data!.c == null || snapshot.data!.c! == 'null'
                        ? data.symbol![0].pdc
                        : snapshot.data!.c!;
                data.symbol![0].ltp =
                    snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                        ? data.symbol![0].ltp
                        : snapshot.data!.lp!;
                data.perChange =
                    snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                        ? data.perChange
                        : snapshot.data!.pc!;
                data.change =
                    (double.parse(data.symbol![0].ltp!.replaceAll(",", "")) -
                            double.parse(data.symbol![0].pdc!))
                        .toStringAsFixed(2);
                final double _realizedPnl = double.parse(
                        checkIsInfOrNullOrNan(value: data.sellAmount ?? '0')
                            ? '0'
                            : data.sellAmount!) -
                    (double.parse(checkIsInfOrNullOrNan(
                                value: data.buyPrice ?? '0.00')
                            ? '0'
                            : data.buyPrice!) *
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.tradedQty ?? '0')
                                ? '0'
                                : data.tradedQty!));
                final double _unrealizedPnl = (double.parse(
                            checkIsInfOrNullOrNan(value: data.netQty ?? '0')
                                ? '0'
                                : data.netQty!) -
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.tradedQty ?? '0')
                                ? '0'
                                : data.tradedQty!)) *
                    (double.parse(checkIsInfOrNullOrNan(
                                value: data.symbol![0].ltp ?? '0.00')
                            ? '0.00'
                            : data.symbol![0].ltp!) -
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.buyPrice ?? '0.00')
                                ? '0.00'
                                : data.buyPrice!));

                final double _pnlVal = _realizedPnl + _unrealizedPnl;

                final double _pnlChangeVal = (double.parse(
                        checkIsInfOrNullOrNan(
                                value: data.symbol![0].ltp ?? '0.00')
                            ? '0.00'
                            : data.symbol![0].ltp!) -
                    double.parse(
                        checkIsInfOrNullOrNan(value: data.buyPrice ?? '0.00')
                            ? '0.00'
                            : data.buyPrice!));
                final double _pnlPercentageChangeVal = ((_pnlChangeVal /
                        double.parse(checkIsInfOrNullOrNan(
                                value: data.buyPrice ?? '0.00')
                            ? '0.00'
                            : data.buyPrice!)) *
                    100);

                final String pnl = _pnlVal.toStringAsFixed(2);
                final String pnlPercentageChange =
                    _pnlPercentageChangeVal.toStringAsFixed(2);
                log("P & L::::${pnl}");

                final double _realizedDaysPnl = double.parse(
                        checkIsInfOrNullOrNan(value: data.sellAmount ?? '0.00')
                            ? '0.00'
                            : data.sellAmount!) -
                    (double.parse(checkIsInfOrNullOrNan(
                                value: data.symbol![0].pdc ?? '0.00')
                            ? '0.00'
                            : data.symbol![0].pdc!) *
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.tradedQty ?? '0')
                                ? '0'
                                : data.tradedQty!));
                final double _unrealizedDaysPnl = (double.parse(
                            checkIsInfOrNullOrNan(value: data.netQty ?? '0')
                                ? '0'
                                : data.netQty!) -
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.tradedQty ?? '0')
                                ? '0'
                                : data.tradedQty!)) *
                    (double.parse(checkIsInfOrNullOrNan(
                                value: data.symbol![0].ltp ?? '0.00')
                            ? '0.00'
                            : data.symbol![0].ltp!) -
                        double.parse(
                            checkIsInfOrNullOrNan(value: data.symbol![0].pdc ?? '0.00')
                                ? '0.00'
                                : data.symbol![0].pdc!));
                final double _daysPnl = _realizedDaysPnl + _unrealizedDaysPnl;

                data.dayPnl = _daysPnl.toStringAsFixed(2);
                data.netPnl = pnl;
                data.netPnlPerChange = pnlPercentageChange;
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
                      child: Text(
                        data.symbol!.isNotEmpty
                            ? data.symbol![0].tradingSymbol!.toUpperCase()
                            : "",
                        style: textStyles.kTextFourteenW500.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorBlack,
                        ),
                      ),
                    ),
                    Text(
                      data.netPnl ?? "",
                      style: textStyles.kTextFourteenW500.copyWith(
                        color: isNumberNegative(data.netPnl!)
                            ? colors.kColorRed
                            : colors.kColorGreen,
                      ),
                    ),
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
                            color: isDarkMode
                                ? colors.kColorBottomWhiteTextDarkTheme
                                : colors.kColorGreyText,
                          ),
                        ),
                        Text(
                          data.netQty!,
                          style: textStyles.kTextElevenW400.copyWith(
                            color: isNumberNegative(data.netQty!)
                                ? colors.kColorRed
                                : colors.kColorGreen,
                          ),
                        ),
                        Sizer.qtrHorizontal(),
                        Text(
                          "Sellable Qty.",
                          style: textStyles.kTextElevenW400.copyWith(
                            color: isDarkMode
                                ? colors.kColorBottomWhiteTextDarkTheme
                                : colors.kColorGreyText,
                          ),
                        ),
                        Text(
                          "${data.sellableQty!}",
                          style: textStyles.kTextElevenW400.copyWith(
                            color: isNumberNegative(data.sellableQty!)
                                ? colors.kColorRed
                                : colors.kColorGreen,
                          ),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${checkIsInfOrNullOrNan(value: data.netPnlPerChange!) ? '0.00' : data.netPnlPerChange!} %",
                          style: textStyles.kTextElevenW400.copyWith(
                            color: isNumberNegative(data.netPnlPerChange!)
                                ? colors.kColorRed
                                : colors.kColorGreen,
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
                          "Buy Avg. ",
                          style: textStyles.kTextTenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorGreyText),
                        ),
                        Text(
                          checkIsInfOrNullOrNan(value: data.buyPrice!) ? '0.00' : data.buyPrice!,
                          style: textStyles.kTextTenW400.copyWith(
                            color: isDarkMode
                                ? colors.kColorBottomWhiteTextDarkTheme
                                : colors.kColorBlack,
                          ),
                        ),
                        Sizer.halfHorizontal(),
                        Text(
                          "Invested : ",
                          style: textStyles.kTextTenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorGreyText),
                        ),
                        Text(
                          checkIsInfOrNullOrNan(value: data.invest!) ? '0.00' : data.invest!,
                          style: textStyles.kTextTenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorBlack),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "LTP",
                          style: textStyles.kTextTenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorBottomWhiteTextDarkTheme
                                  : colors.kColorGreyText),
                        ),
                        Sizer.halfHorizontal(),
                        Text(
                          data.symbol![0].ltp!,
                          style: textStyles.kTextTenW400.copyWith(
                            color: isDarkMode
                                ? colors.kColorBottomWhiteTextDarkTheme
                                : colors.kColorBlack,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
