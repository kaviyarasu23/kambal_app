import 'dart:developer';

import 'package:aliceblue/model/position_book_model.dart';
import 'package:aliceblue/provider/menu_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/indian_indices_model.dart';
import '../../model/market_depth_model.dart';
import '../../model/ws_df_feed_model.dart';
import '../../provider/market_depth_provider.dart';
import '../../provider/tab_controller_provider.dart';
import '../../provider/theme_provider.dart';
import '../../provider/websocket_provider.dart';
import '../../res/res.dart';
import '../../shared_widget/custom_button.dart';
import '../../shared_widget/custom_long_button.dart';
import '../../shared_widget/snack_bar.dart';
import '../../util/functions.dart';
import '../../util/sizer.dart';
import '../portfolio/positions/position_convert/convert_positions_alter_dialog.dart';

/// Market Depth bottom sheet info
///
///
///

class MarketDepth extends ConsumerStatefulWidget {
  final MDdata dp;
  final PositionBookInfoResult? positionsData;
  final ScrollController controller;
  const MarketDepth({
    Key? key,
    required this.dp,
    required this.controller,
    this.positionsData = null,
  }) : super(key: key);

  @override
  ConsumerState<MarketDepth> createState() => _MarketDepthState();
}

class _MarketDepthState extends ConsumerState<MarketDepth> {
  late MDdata dp;
  late PositionBookInfoResult? positionsData;
  bool isAck = true;
  int afterPoint = 2;

  @override
  void initState() {
    super.initState();
    dp = widget.dp;
    positionsData = widget.positionsData;
    log("POSITION IS NULL :: ${positionsData != null}");
    afterPoint = dp.exchg!.toLowerCase() == 'cds' ? 4 : 2;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(websocketProvider).establishConnection(
            channelInput: '${dp.exchg}|${dp.token}',
            task: 'd',
          );
    });
  }

  void addWSAck(DepthWSResponse first) {
    dp.bOrders1 =
        (first.bo1 != null && first.bo1 != 'null') ? first.bo1 : dp.bOrders1;
    dp.bPrice1 =
        (first.bp1 != null && first.bp1 != "null") ? first.bp1 : dp.bPrice1;
    dp.bQty1 =
        (first.bq1 != null && first.bq1 != "null") ? first.bq1 : dp.bQty1;

    dp.sQty1 =
        (first.sq1 != null && first.sq1 != "null") ? first.sq1 : dp.sQty1;
    dp.sOrders1 =
        (first.so1 != null && first.so1 != "null") ? first.so1 : dp.sOrders1;
    dp.sPrice1 =
        (first.sp1 != null && first.sp1 != "null") ? first.sp1 : dp.sPrice1;
    dp.bOrders2 =
        (first.bo2 != null && first.bo2 != "null") ? first.bo2 : dp.bOrders2;
    dp.bPrice2 =
        (first.bp2 != null && first.bp2 != "null") ? first.bp2 : dp.bPrice2;
    dp.bQty2 =
        (first.bq2 != null && first.bq2 != "null") ? first.bq2 : dp.bQty2;
    dp.sQty2 =
        (first.sq2 != null && first.sq2 != "null") ? first.sq2 : dp.sQty2;
    dp.sOrders2 =
        (first.so2 != null && first.so2 != "null") ? first.so2 : dp.sOrders2;
    dp.sPrice2 =
        (first.sp2 != null && first.sp2 != "null") ? first.sp2 : dp.sPrice2;
    dp.bOrders3 =
        (first.bo3 != null && first.bo3 != "null") ? first.bo3 : dp.bOrders3;
    dp.bPrice3 =
        (first.bp3 != null && first.bp3 != "null") ? first.bp3 : dp.bPrice3;
    dp.bQty3 =
        (first.bq3 != null && first.bq3 != "null") ? first.bq3 : dp.bQty3;
    dp.sQty3 =
        (first.sq3 != null && first.sq3 != "null") ? first.sq3 : dp.sQty3;
    dp.sOrders3 =
        (first.so3 != null && first.so3 != "null") ? first.so3 : dp.sOrders3;
    dp.sPrice3 =
        (first.sp3 != null && first.sp3 != "null") ? first.sp3 : dp.sPrice3;
    dp.bOrders4 =
        (first.bo4 != null && first.bo4 != "null") ? first.bo4 : dp.bOrders4;
    dp.bPrice4 =
        (first.bp4 != null && first.bp4 != "null") ? first.bp4 : dp.bPrice4;
    dp.bQty4 =
        (first.bq4 != null && first.bq4 != "null") ? first.bq4 : dp.bQty4;
    dp.sQty4 =
        (first.sq4 != null && first.sq4 != "null") ? first.sq4 : dp.sQty4;
    dp.sOrders4 =
        (first.so4 != null && first.so4 != "null") ? first.so4 : dp.sOrders4;
    dp.sPrice4 =
        (first.sp4 != null && first.sp4 != "null") ? first.sp4 : dp.sPrice4;
    dp.bOrders5 =
        (first.bo5 != null && first.bo5 != "null") ? first.bo5 : dp.bOrders5;
    dp.bPrice5 =
        (first.bp5 != null && first.bp5 != "null") ? first.bp5 : dp.bPrice5;
    dp.bQty5 =
        (first.bq5 != null && first.bq5 != "null") ? first.bq5 : dp.bQty5;
    dp.sQty5 =
        (first.sq5 != null && first.sq5 != "null") ? first.sq5 : dp.sQty5;
    dp.sOrders5 =
        (first.so5 != null && first.so5 != "null") ? first.so5 : dp.sOrders5;
    dp.sPrice5 =
        (first.sp5 != null && first.sp5 != "null") ? first.sp5 : dp.sPrice5;
    dp.totalbuyqty =
        (first.tbq != null && first.tbq != "null") ? first.tbq : dp.totalbuyqty;
    dp.totalsellqty = (first.tsq != null && first.tsq != "null")
        ? first.tsq
        : dp.totalsellqty;

    dp.volume = (first.v != null && first.v != "null") ? first.v : dp.volume;

    dp.openinterest =
        (first.oi != null && first.oi != "null") ? first.oi : dp.openinterest;
    dp.yearlyhighprice = (first.h52 != null && first.h52 != "null")
        ? first.h52
        : dp.yearlyhighprice;
    dp.yearlylowprice = (first.l52 != null && first.l52 != "null")
        ? first.l52
        : dp.yearlylowprice;
    dp.lasttradedqty = (first.ltq != null && first.ltq != 'null')
        ? first.ltq
        : dp.lasttradedqty;
    dp.lowercircuitlimit = (first.lc != null && first.lc != 'null')
        ? first.lc
        : dp.lowercircuitlimit;
    dp.highercircuitlimit = (first.uc != null && first.uc != 'null')
        ? first.uc
        : dp.highercircuitlimit;
    dp.lasttradedtime = (first.ltt != null && first.ltt != "null")
        ? first.ltt ?? dp.lasttradedtime
        : dp.lasttradedtime;
    dp.perChange =
        (first.pc != null && first.pc != 'null') ? first.pc : dp.perChange;
    dp.ltp = (first.lp != null && first.lp != 'null') ? first.lp : dp.ltp;
    dp.highrate =
        (first.h != null && first.h != 'null') ? first.h : dp.highrate;
    dp.lowrate = (first.l != null && first.l != 'null') ? first.l : dp.lowrate;
    dp.openrate =
        (first.o != null && first.o != 'null') ? first.o : dp.openrate;
    dp.previouscloserate =
        (first.c != null && first.c != 'null') ? first.c : dp.previouscloserate;
    dp.weightedavg =
        (first.ap != null && first.ap != 'null') ? first.ap : dp.weightedavg;
    dp.fTime = (first.ft != null && first.ft != 'null') ? first.ft : dp.fTime;
  }

  void addWSDataToDP(DepthWSResponse first) {
    // log('DF ::: TBQ ${first.tbq} TSQ ${first.tsq}');
    // log('DF ::: FD ${first.ltt} TOKEN :::: ${first.tk} VOLUME ::::: ${first.v}');
    // log('LTP ::::: ${first.lp}');
    dp.bOrders1 = (first.bo1 != null &&
            first.bo1 != '0' &&
            first.bo1 != '0.00' &&
            first.bo1 != '00.00' &&
            first.bo1 != 'null')
        ? first.bo1
        : dp.bOrders1;
    dp.bPrice1 = (first.bp1 != null &&
            first.bp1 != "0" &&
            first.bp1 != "0.00" &&
            first.bp1 != "00.00" &&
            first.bp1 != "null")
        ? first.bp1
        : dp.bPrice1;
    dp.bQty1 = (first.bq1 != null && first.bq1 != "0" && first.bq1 != "null")
        ? first.bq1
        : dp.bQty1;

    dp.sQty1 = (first.sq1 != null && first.sq1 != "0" && first.sq1 != "null")
        ? first.sq1
        : dp.sQty1;
    dp.sOrders1 = (first.so1 != null && first.so1 != "0" && first.so1 != "null")
        ? first.so1
        : dp.sOrders1;
    dp.sPrice1 = (first.sp1 != null &&
            first.sp1 != "0" &&
            first.sp1 != "0.00" &&
            first.sp1 != "00.00" &&
            first.sp1 != "null")
        ? first.sp1
        : dp.sPrice1;
    dp.bOrders2 = (first.bo2 != null && first.bo2 != "0" && first.bo2 != "null")
        ? first.bo2
        : dp.bOrders2;
    dp.bPrice2 = (first.bp2 != "0" &&
            first.bp2 != "0.00" &&
            first.bp2 != "00.00" &&
            first.bp2 != "null")
        ? first.bp2
        : dp.bPrice2;
    dp.bQty2 = (first.bq2 != null && first.bq2 != "0" && first.bq2 != "null")
        ? first.bq2
        : dp.bQty2;
    dp.sQty2 = (first.sq2 != null && first.sq2 != "0" && first.sq2 != "null")
        ? first.sq2
        : dp.sQty2;
    dp.sOrders2 = (first.so2 != null && first.so2 != "0" && first.so2 != "null")
        ? first.so2
        : dp.sOrders2;
    dp.sPrice2 = (first.sp2 != null &&
            first.sp2 != "0" &&
            first.sp2 != "0.00" &&
            first.sp2 != "00.00" &&
            first.sp2 != "null")
        ? first.sp2
        : dp.sPrice2;
    dp.bOrders3 = (first.bo3 != null && first.bo3 != "0" && first.bo3 != "null")
        ? first.bo3
        : dp.bOrders3;
    dp.bPrice3 = (first.bp3 != null &&
            first.bp3 != "0" &&
            first.bp3 != "0.00" &&
            first.bp3 != "00.00" &&
            first.bp3 != "null")
        ? first.bp3
        : dp.bPrice3;
    dp.bQty3 = (first.bq3 != null && first.bq3 != "0" && first.bq3 != "null")
        ? first.bq3
        : dp.bQty3;
    dp.sQty3 = (first.sq3 != null && first.sq3 != "0" && first.sq3 != "null")
        ? first.sq3
        : dp.sQty3;
    dp.sOrders3 = (first.so3 != null && first.so3 != "0" && first.so3 != "null")
        ? first.so3
        : dp.sOrders3;
    dp.sPrice3 = (first.sp3 != null &&
            first.sp3 != "0" &&
            first.sp3 != "0.00" &&
            first.sp3 != "00.00" &&
            first.sp3 != "null")
        ? first.sp3
        : dp.sPrice3;
    dp.bOrders4 = (first.bo4 != null && first.bo4 != "0" && first.bo4 != "null")
        ? first.bo4
        : dp.bOrders4;
    dp.bPrice4 = (first.bp4 != null &&
            first.bp4 != "0" &&
            first.bp4 != "0.00" &&
            first.bp4 != "00.00" &&
            first.bp4 != "null")
        ? first.bp4
        : dp.bPrice4;
    dp.bQty4 = (first.bq4 != null && first.bq4 != "0" && first.bq4 != "null")
        ? first.bq4
        : dp.bQty4;
    dp.sQty4 = (first.sq4 != null && first.sq4 != "0" && first.sq4 != "null")
        ? first.sq4
        : dp.sQty4;
    dp.sOrders4 = (first.so4 != null && first.so4 != "0" && first.so4 != "null")
        ? first.so4
        : dp.sOrders4;
    dp.sPrice4 = (first.sp4 != null &&
            first.sp4 != "0" &&
            first.sp4 != "0.00" &&
            first.sp4 != "00.00" &&
            first.sp4 != "null")
        ? first.sp4
        : dp.sPrice4;
    dp.bOrders5 = (first.bo5 != null && first.bo5 != "0" && first.bo5 != "null")
        ? first.bo5
        : dp.bOrders5;
    dp.bPrice5 = (first.bp5 != null &&
            first.bp5 != "0" &&
            first.bp5 != "0.00" &&
            first.bp5 != "00.00" &&
            first.bp5 != "null")
        ? first.bp5
        : dp.bPrice5;
    dp.bQty5 = (first.bq5 != null && first.bq5 != "0" && first.bq5 != "null")
        ? first.bq5
        : dp.bQty5;
    dp.sQty5 = (first.sq5 != null && first.sq5 != "0" && first.sq5 != "null")
        ? first.sq5
        : dp.sQty5;
    dp.sOrders5 = (first.so5 != null && first.so5 != "0" && first.so5 != "null")
        ? first.so5
        : dp.sOrders5;
    dp.sPrice5 = (first.sp5 != null &&
            first.sp5 != "0" &&
            first.sp5 != "0.00" &&
            first.sp5 != "00.00" &&
            first.sp5 != "null")
        ? first.sp5
        : dp.sPrice5;
    dp.totalbuyqty = (first.tbq != null &&
            first.tbq != "0" &&
            first.tbq != "00" &&
            first.tbq != "null")
        ? first.tbq
        : dp.totalbuyqty;
    dp.totalsellqty = (first.tsq != null &&
            first.tsq != "0" &&
            first.tsq != "00" &&
            first.tsq != "null")
        ? first.tsq
        : dp.totalsellqty;

    dp.volume = (first.v != null &&
            first.v != "0" &&
            first.v != "0.00" &&
            first.v != "00.00" &&
            first.v != "null")
        ? first.v
        : dp.volume;

    dp.openinterest = (first.oi != null &&
            first.oi != "0" &&
            first.oi != "null" &&
            first.oi != "00" &&
            first.oi != "00.00" &&
            first.oi != "0.00")
        ? first.oi
        : dp.openinterest;
    dp.yearlyhighprice = (first.h52 != null &&
            first.h52 != "0" &&
            first.h52 != "00.00" &&
            first.h52 != "0.00" &&
            first.h52 != "null" &&
            first.h52 != "00")
        ? first.h52
        : dp.yearlyhighprice;
    dp.yearlylowprice = (first.l52 != null &&
            first.l52 != "0" &&
            first.l52 != "0.00" &&
            first.l52 != "00.00" &&
            first.l52 != "null" &&
            first.l52 != "00")
        ? first.l52
        : dp.yearlylowprice;
    dp.lasttradedqty = (first.ltq != null &&
            first.ltq != '0' &&
            first.ltq != 'null' &&
            first.ltq != '00')
        ? first.ltq
        : dp.lasttradedqty;
    dp.lowercircuitlimit = (first.lc != null &&
            first.lc != '0' &&
            first.lc != 'null' &&
            first.lc != '00.00' &&
            first.lc != '0.00')
        ? first.lc
        : dp.lowercircuitlimit;
    dp.highercircuitlimit = (first.uc != null &&
            first.uc != '0' &&
            first.uc != 'null' &&
            first.uc != '00.00' &&
            first.uc != '0.00')
        ? first.uc
        : dp.highercircuitlimit;
    dp.lasttradedtime =
        (first.ltt != null && first.ltt != "null" && first.ltt != "0")
            ? first.ltt ?? dp.lasttradedtime
            : dp.lasttradedtime;
    dp.perChange = (first.pc != null &&
            first.pc != '00.00' &&
            first.pc != '0' &&
            first.pc != 'null')
        ? first.pc
        : dp.perChange;
    dp.ltp = (first.lp != null &&
            first.lp != '00.00' &&
            first.lp != '0.00' &&
            first.lp != '0' &&
            first.lp != 'null')
        ? first.lp
        : dp.ltp;
    dp.highrate = (first.h != null &&
            first.h != '00.00' &&
            first.h != '0.00' &&
            first.h != '0' &&
            first.h != 'null')
        ? first.h
        : dp.highrate;
    dp.lowrate = (first.l != null &&
            first.l != '00.00' &&
            first.l != '0.00' &&
            first.l != 'null' &&
            first.l != '0')
        ? first.l
        : dp.lowrate;
    dp.openrate = (first.o != null &&
            first.o != '00.00' &&
            first.o != '0.00' &&
            first.o != '0' &&
            first.o != 'null')
        ? first.o
        : dp.openrate;
    dp.previouscloserate = (first.c != null &&
            first.c != '0' &&
            first.c != '0.00' &&
            first.c != '00.00' &&
            first.c != 'null')
        ? first.c
        : dp.previouscloserate;
    dp.weightedavg = (first.ap != null &&
            first.ap != '0' &&
            first.ap != '0.00' &&
            first.ap != '00.00' &&
            first.ap != 'null')
        ? first.ap
        : dp.weightedavg;
    dp.fTime = (first.ft != null &&
            first.ft != "0" &&
            first.ft != "00" &&
            first.ft != "null")
        ? first.ft
        : dp.fTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).isDarkMode;
    final spotIndicesHeader = ref.watch(tabControllProvider).spotIndicesHeader;
    // final market = ref.watch(marketProvider);
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .dfUpdate
            .stream
            .where((event) => event.tk == dp.token),
        builder: (_, AsyncSnapshot<DepthWSResponse> snapDP) {
          if (snapDP.data != null) {
            if (isAck) {
              addWSAck(snapDP.data!);
              isAck = false;
            } else {
              isAck = false;
              addWSDataToDP(
                snapDP.data!,
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ref.read(marketDepthProvider).setDepth(data: dp);
            });
          }
          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    left: sizes.pad_40,
                    right: sizes.pad_16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Sizer.half(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Table(
                              defaultColumnWidth:
                                  const IntrinsicColumnWidth(flex: 1),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: sizes.pad_6),
                                      child: Text(
                                        "Bid",
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: sizes.pad_6),
                                      child: Text(
                                        "Orders",
                                        textAlign: TextAlign.center,
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: sizes.pad_6),
                                      child: Text(
                                        "Qty",
                                        textAlign: TextAlign.end,
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                mdRowBuy(
                                  bp: "${dp.bPrice1}",
                                  bq: "${dp.bQty1}",
                                  bno: "${dp.bOrders1}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowBuy(
                                  bp: "${dp.bPrice2}",
                                  bq: "${dp.bQty2}",
                                  bno: "${dp.bOrders2}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowBuy(
                                  bp: "${dp.bPrice3}",
                                  bq: "${dp.bQty3}",
                                  bno: "${dp.bOrders3}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowBuy(
                                  bp: "${dp.bPrice4}",
                                  bq: "${dp.bQty4}",
                                  bno: "${dp.bOrders4}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowBuy(
                                  bp: "${dp.bPrice5}",
                                  bq: "${dp.bQty5}",
                                  bno: "${dp.bOrders5}",
                                  afterPoint: afterPoint,
                                ),
                              ],
                            ),
                          ),
                          Sizer.horizontal(),
                          Expanded(
                            child: Table(
                              defaultColumnWidth:
                                  const IntrinsicColumnWidth(flex: 1),
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: sizes.pad_6),
                                      child: Text(
                                        "Offer",
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: sizes.pad_6,
                                      ),
                                      child: Text(
                                        "Orders",
                                        textAlign: TextAlign.center,
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: sizes.pad_6),
                                      child: Text(
                                        "Qty",
                                        textAlign: TextAlign.end,
                                        style:
                                            textStyles.kTextElevenW400.copyWith(
                                          color: theme
                                              ? colors
                                                  .kColorBottomWhiteTextDarkTheme
                                              : colors.kColorGreyText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                mdRowSell(
                                  sp: "${dp.sPrice1}",
                                  sq: "${dp.sQty1}",
                                  sno: "${dp.sOrders1}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowSell(
                                  sp: "${dp.sPrice2}",
                                  sq: "${dp.sQty2}",
                                  sno: "${dp.sOrders2}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowSell(
                                  sp: "${dp.sPrice3}",
                                  sq: "${dp.sQty3}",
                                  sno: "${dp.sOrders3}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowSell(
                                  sp: "${dp.sPrice4}",
                                  sq: "${dp.sQty4}",
                                  sno: "${dp.sOrders4}",
                                  afterPoint: afterPoint,
                                ),
                                mdRowSell(
                                  sp: "${dp.sPrice5}",
                                  sq: "${dp.sQty5}",
                                  sno: "${dp.sOrders5}",
                                  afterPoint: afterPoint,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total",
                                style: textStyles.kTextElevenW400.copyWith(
                                  color: colors.kColorGreen,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                double.parse(
                                  dp.totalbuyqty ?? "0",
                                ).toStringAsFixed(0),
                                textAlign: TextAlign.end,
                                style: textStyles.kTextElevenW400.copyWith(
                                  color: colors.kColorGreen,
                                ),
                              ),
                            ),
                            Sizer.horizontal(),
                            Expanded(
                              child: Text(
                                "Total",
                                style: textStyles.kTextElevenW400.copyWith(
                                  color: colors.kColorRed,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                double.parse(
                                  dp.totalsellqty ?? "0",
                                ).toStringAsFixed(0),
                                textAlign: TextAlign.end,
                                style: textStyles.kTextElevenW400.copyWith(
                                  color: colors.kColorRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Sizer.half(),
                    ],
                  )),
              Sizer.vertical16(),
              // DepthTotalPercentageBox(
              //   askTotal: dp.totalsellqty ?? '0',
              //   bidTotal: dp.totalbuyqty ?? '0',
              //   token: dp.token!,
              // ),
              // Sizer.vertical32(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.pad_16,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: theme
                        ? colors.kColorPinTextfieldDarkTheme
                        : colors.kColorBlueLight,
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.pad_16,
                      vertical: sizes.pad_16,
                    ),
                    child: OHLC(data: dp),
                  ),
                ),
              ),
              HighLowIndicator(
                token: dp.token!,
                high: dp.highrate ?? '0',
                low: dp.lowrate ?? '0',
                ltp: dp.ltp ?? '0',
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.pad_24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              '${dp.highrate}',
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: colors.kColorGreen,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Sizer.halfHorizontal(),
                            Text(
                              ('daysHigh').tr(),
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: theme
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              ('daysLow').tr(),
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: theme
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Sizer.halfHorizontal(),
                            Text(
                              '${dp.lowrate}',
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: colors.kColorRed,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Sizer.vertical32(),
              ExtraInfo(
                data: dp,
              ),
              Sizer.vertical10(),
              if (positionsData != null) Sizer.vertical24(),
              if (positionsData != null)
                PositionBottomInfo(
                  data: positionsData!,
                  isDarkMode: theme,
                ),
              Sizer.vertical32(),
              HeadingWidget(
                title: ('scripDetails').tr(),
              ),
              Sizer.vertical16(),
              DepthInfo(
                title: ('volume').tr(),
                value: formatCurrencyStandard(value: dp.volume ?? '0'),
                isBg: true,
              ),
              DepthInfo(
                title: ('avgTradePrice').tr(),
                value: getFormatedNumValue(
                  dp.ltp ?? '0',
                  afterPoint: 2,
                  showSign: false,
                ),
              ),
              DepthInfo(
                title: ('lastTradedQty').tr(),
                value: dp.lasttradedqty ?? '0',
                isBg: true,
              ),
              DepthInfo(
                title: ('lastTradedAt').tr(),
                value: dp.lasttradedtime ?? '',
                isBg: false,
              ),
              DepthInfo(
                title: ('lowerCircuit').tr(),
                value: getFormatedNumValue(
                  dp.lowercircuitlimit ?? '0',
                  afterPoint: 2,
                  showSign: false,
                ),
                isBg: true,
              ),
              DepthInfo(
                title: ('upperCircuit').tr(),
                value: getFormatedNumValue(
                  dp.highercircuitlimit ?? '0',
                  afterPoint: 2,
                  showSign: false,
                ),
                isBg: false,
              ),
              Sizer.vertical20(),
              HeadingWidget(
                title: ('Order History').tr(),
              ),
              Sizer.vertical10(),
              // OrderHistoryInfo(controller: widget.controller),
              // Sizer.vertical24(),
              HeadingWidget(
                title: ('apps').tr(),
              ),
              Sizer.vertical24(),
              ShowAppsList(
                asset: assets.technicalIcon,
                title: ('technicals').tr(),
              ),
              Sizer.vertical16(),
              Visibility(
                visible: dp.exchg!.toLowerCase() == 'nfo',
                child: ShowAppsList(
                  asset: assets.optionChainIcon,
                  title: ('optionChain').tr(),
                  onTap: () {
                    log("Option chain symbol ::: ${dp.symbolName!.contains(" ") ? dp.symbolName!.split(" ")[0] : dp.symbolName}");
                    // Navigator.pushNamed(
                    //   context,
                    //   Routes.optionChain,
                    //   arguments:
                    //       "${dp.symbolName!.contains(" ") ? dp.symbolName!.split(" ")[0] : dp.symbolName}",
                    // );
                  },
                ),
              ),
              Visibility(
                visible: dp.exchg!.toLowerCase() == 'nfo',
                child: Sizer.vertical16(),
              ),
              Visibility(
                visible: (dp.exchg!.toLowerCase() == 'nse' ||
                    dp.exchg!.toLowerCase() == 'bse'),
                child: ShowAppsList(
                  asset: assets.smallcase_logo,
                  title: ('fundamental').tr(),
                  onTap: () {
                    log("Fundamental ::: ${dp.symbolName}");
                    // WebViewInput args = WebViewInput(
                    //   url:
                    //       'https://stocks.tickertape.in/${dp.symbolName!.toLowerCase().contains('-') ? dp.symbolName!.split("-")[0] : widget.dp.symbolName}?broker=aliceblue',
                    //   // theme: theme,
                    //   title: 'Fundamentals',
                    // );
                    // Navigator.pushNamed(
                    //   context,
                    //   Routes.webView,
                    //   arguments: args,
                    // );
                  },
                ),
              ),
              Visibility(
                  visible: (dp.exchg!.toLowerCase() == 'nse' ||
                      dp.exchg!.toLowerCase() == 'bse'),
                  child: Sizer.vertical16()),
              horizontalDividerLine(theme),
              Sizer.vertical24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HeadingWidget(
                      title: ('pinToHead').tr(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.pad_16,
                    ),
                    child: Row(
                      children: [
                        SpotBox(
                          Label: ("spot1").tr(),
                          isSelected:
                              spotIndicesHeader[0].token.toLowerCase() ==
                                  widget.dp.token!.toLowerCase(),
                          ontap: () {
                            ref.read(tabControllProvider).changeSpotIndex(
                                value: IndianIndices(
                                  symbol: widget.dp.symbol!,
                                  exchange: widget.dp.exchg!,
                                  scripName: widget.dp.symbolName!,
                                  token: widget.dp.token!,
                                  ltp: widget.dp.ltp ?? '0.00',
                                  change: widget.dp.perChange ?? '0.00',
                                  perChange: widget.dp.perChange ?? '0.00',
                                ),
                                index: 0);
                            // log("${market.spotSelected}");
                            ref.read(menuProvider).changeExpand(
                                !ref.read(menuProvider).isExpanded);
                            Navigator.pop(context);
                          },
                          dp: dp,
                        ),
                        Sizer.halfHorizontal(),
                        SpotBox(
                          Label: ("spot2").tr(),
                          isSelected:
                              spotIndicesHeader[0].token.toLowerCase() ==
                                  dp.token!.toLowerCase(),
                          ontap: () {
                            // ref.read(tabControllProvider).changeSpotValue(
                            //     value: !market.pref.spot1val);
                            ref.read(tabControllProvider).changeSpotIndex(
                                value: IndianIndices(
                                    symbol: widget.dp.symbol!,
                                    exchange: dp.exchg!,
                                    scripName: dp.symbolName!,
                                    token: dp.token!,
                                    ltp: dp.ltp ?? '0.00',
                                    change: dp.perChange ?? '0.00',
                                    perChange: dp.perChange ?? '0.00'),
                                index: 1);
                            ref.read(menuProvider).changeExpand(
                                !ref.read(menuProvider).isExpanded);
                            Navigator.pop(context);
                          },
                          dp: dp,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}

TableRow mdRowBuy({
  required String? bp,
  required String? bq,
  required String? bno,
  required int afterPoint,
}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          double.parse(bp ?? "0").toStringAsFixed(afterPoint),
          maxLines: 1,
          style: textStyles.kTextElevenW400.copyWith(
            color: colors.kColorGreen,
            letterSpacing: 0.3,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_6,
        ),
        child: Text(
          "$bno",
          textAlign: TextAlign.center,
          style: textStyles.kTextElevenW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorGreen),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          "$bq",
          textAlign: TextAlign.end,
          style: textStyles.kTextElevenW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorGreen),
        ),
      ),
    ],
  );
}

TableRow mdRowSell({
  required String? sp,
  required String? sq,
  required String? sno,
  required int afterPoint,
}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          double.parse(
            sp ?? "0",
          ).toStringAsFixed(afterPoint),
          style: textStyles.kTextElevenW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorRed),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_6,
        ),
        child: Text(
          "$sno",
          textAlign: TextAlign.center,
          style: textStyles.kTextElevenW400.copyWith(
            letterSpacing: 0.3,
            color: colors.kColorRed,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          "$sq",
          textAlign: TextAlign.end,
          style: textStyles.kTextElevenW400.copyWith(
            letterSpacing: 0.3,
            color: colors.kColorRed,
          ),
        ),
      ),
    ],
  );
}

class OHLC extends StatefulWidget {
  final MDdata data;
  const OHLC({
    super.key,
    required this.data,
  });

  @override
  State<OHLC> createState() => _OHLCState();
}

class _OHLCState extends State<OHLC> {
  late MDdata data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  void didUpdateWidget(covariant OHLC oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (data != widget.data) {
      setState(() {
        data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OHLCBox(
          title: ('open').tr(),
          value: data.openrate ?? '0.00',
        ),
        OHLCBox(
          title: ('high').tr(),
          value: data.highrate ?? '0.00',
        ),
        OHLCBox(
          title: ('low').tr(),
          value: data.lowrate ?? '0.00',
        ),
        OHLCBox(
          title: ('close').tr(),
          value: data.previouscloserate ?? '0.00',
        ),
      ],
    );
  }
}

class OHLCBox extends ConsumerWidget {
  final String title;
  final String value;
  const OHLCBox({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: textStyles.kTextTwelveW400.copyWith(
              color: isDarkMode
                  ? colors.kColorBottomWhiteTextDarkTheme
                  : colors.kColorGreyText),
        ),
        Sizer.half(),
        Text(
          getFormatedNumValue(
            value,
            afterPoint: 2,
            showSign: false,
          ),
          style: textStyles.kTextTwelveW400.copyWith(
            color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
          ),
        ),
      ],
    );
  }
}

class HighLowIndicator extends ConsumerStatefulWidget {
  final String token;
  final String high;
  final String low;
  final String ltp;
  final bool isDarkMode;
  const HighLowIndicator({
    Key? key,
    required this.token,
    required this.high,
    required this.low,
    required this.ltp,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  ConsumerState<HighLowIndicator> createState() => _HighLowIndicatorState();
}

class _HighLowIndicatorState extends ConsumerState<HighLowIndicator> {
  late String token;
  late String highVal;
  late String lowVal;
  late String ltpValue;

  String prevLtp = "";

  double high = 0;
  double low = 0;
  double ltpVal = 0;

  double highlowDiff = 0;

  double box1width = 0;
  double box2width = 0;

  bool isZeroAva = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    highVal = widget.high;
    lowVal = widget.low;
    ltpValue = widget.ltp;
    token = widget.token;
    isDarkMode = widget.isDarkMode;
    addPointCalculation();
  }

  @override
  void didUpdateWidget(covariant HighLowIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (highVal != widget.high) {
      setState(() {
        highVal = widget.high;
      });
    } else if (lowVal != widget.low) {
      setState(() {
        lowVal = widget.low;
      });
    } else if (ltpValue != widget.ltp) {
      setState(() {
        ltpValue = widget.ltp;
      });
    } else if (token != widget.token) {
      setState(() {
        token = widget.token;
      });
    } else if (isDarkMode != widget.isDarkMode) {
      setState(() {
        isDarkMode = widget.isDarkMode;
      });
    }
    addPointCalculation();
  }

  void addPointCalculation() {
    setState(() {
      high = double.parse(highVal);
      low = double.parse(lowVal);
      ltpVal = double.parse(ltpValue);
      if (high < 0 || low < 0) {
        high = 0;
        low = 0;
      }
      isZeroAva = high == 0 || low == 0 || ltpVal == 0;
      if (!isZeroAva) {
        highlowDiff = ((sizes.width - 40) / (high - low));
        box1width = highlowDiff * (high - ltpVal);
        box2width = (sizes.width - 40) - box1width;
        log("DF :: BOX 1 WIDTH ${box1width} ::: BOX 2 WIDTH ${box2width}");
      }
      isZeroAva = box1width.isInfinite ||
          box2width.isInfinite ||
          box1width.isNaN ||
          box2width.isNaN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .dfUpdate
            .stream
            .where((event) => event.tk == token),
        builder: (_, AsyncSnapshot<DepthWSResponse> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == token) {
              prevLtp = ltpValue;
              ltpValue = (snapshot.data!.lp != null &&
                      snapshot.data!.lp != '00.00' &&
                      snapshot.data!.lp != '0.00' &&
                      snapshot.data!.lp != '0' &&
                      snapshot.data!.lp != 'null')
                  ? snapshot.data!.lp ?? '0'
                  : ltpValue;
              highVal = (snapshot.data!.h != null &&
                      snapshot.data!.h != '00.00' &&
                      snapshot.data!.h != '0.00' &&
                      snapshot.data!.h != '0' &&
                      snapshot.data!.h != 'null')
                  ? snapshot.data!.h ?? '0'
                  : highVal;
              lowVal = (snapshot.data!.l != null &&
                      snapshot.data!.l != '00.00' &&
                      snapshot.data!.l != '0.00' &&
                      snapshot.data!.l != 'null' &&
                      snapshot.data!.l != '0')
                  ? snapshot.data!.l ?? '0'
                  : lowVal;
              if ((prevLtp != ltpValue) || (high == 0)) {
                addPointCalculation();
              }
            }
          }
          return Stack(
            children: [
              Column(
                children: [
                  Sizer.vertical24(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.pad_16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: box1width.isNaN ||
                                  isZeroAva ||
                                  box1width.isNegative ||
                                  box2width.isNegative
                              ? (sizes.width / 2) - 20
                              : box1width,
                          height: 1,
                          color: box1width.isNaN ||
                                  isZeroAva ||
                                  box1width.isNegative ||
                                  box2width.isNegative
                              ? isDarkMode
                                  ? colors.kColorWhite60
                                  : colors.kColorBlack60
                              : colors.kColorGreen,
                        ),
                        Container(
                          width: box2width.isNaN ||
                                  isZeroAva ||
                                  box1width.isNegative ||
                                  box2width.isNegative
                              ? (sizes.width / 2) - 20
                              : box2width,
                          color: box2width.isNaN ||
                                  isZeroAva ||
                                  box1width.isNegative ||
                                  box2width.isNegative
                              ? isDarkMode
                                  ? colors.kColorWhite60
                                  : colors.kColorBlack60
                              : colors.kColorRed,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Sizer.vertical10(),
                ],
              ),
              Positioned(
                top: 20,
                left: isZeroAva ? 16 : box1width + 15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: colors.kColorBlue,
                    height: 10,
                    width: 10,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class DepthInfo extends ConsumerWidget {
  final bool isBg;
  final String title;
  final String value;
  final bool? accountScreen;
  const DepthInfo({
    Key? key,
    this.isBg = false,
    required this.title,
    required this.value,
    this.accountScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Container(
      color: isBg
          ? isDarkMode
              ? colors.kColorPinTextfieldDarkTheme
              : accountScreen == true
                  ? colors.kColorLightBlueBg
                  : colors.kColorBlueLightBgDepth
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes.pad_16,
          vertical: sizes.pad_8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyles.kTextFourteenW400.copyWith(
                color: isDarkMode
                    ? colors.kColorBottomWhiteTextDarkTheme
                    : colors.kColorGreyText,
              ),
            ),
            Text(
              value,
              style: textStyles.kTextFourteenW400.copyWith(
                color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PositionBottomInfo extends StatelessWidget {
  final PositionBookInfoResult data;
  final bool isDarkMode;
  const PositionBottomInfo({
    Key? key,
    required this.data,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DepthInfo(
          title: "Buy Price",
          value: data.buyPrice!,
          isBg: true,
        ),
        DepthInfo(title: "Sell Price", value: data.sellQty!),
        DepthInfo(
          title: "Net Qty.",
          value: data.netQty!,
          isBg: true,
        ),
        DepthInfo(title: "Carry forward Qty.", value: data.buyQty!),
        // DepthInfo(
        //   title: "Day's P&L",
        //   value: data.!,
        //   isBg: true,
        // ),
        DepthInfo(
          title: "Total P&L",
          value: data.mtm!,
          isBg: true,
        ),
        Visibility(
          visible: data.netQty != "0",
          child: PositionsConvert(
            data: data,
          ),
        ),
        Sizer.vertical10(),
        PositionBuySellInfo(
          isDarkMode: isDarkMode,
          price: data.buyPrice!,
          qty: data.buyQty!,
          type: 'Buy',
          value: data.buyPrice!,
        ),
        Sizer.vertical10(),
        PositionBuySellInfo(
          isDarkMode: isDarkMode,
          price: data.sellPrice!,
          qty: data.sellQty!,
          type: 'Sell',
          value: data.sellPrice!,
        ),
      ],
    );
  }
}

// Position Buy Sell Info

class PositionBuySellInfo extends StatelessWidget {
  final String type;
  final String qty;
  final String price;
  final String value;
  final bool isDarkMode;
  const PositionBuySellInfo({
    Key? key,
    required this.type,
    required this.price,
    required this.qty,
    required this.value,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                ("${type.toLowerCase() == 'buy' ? 'buyBottomPos' : 'sellBottomPos'}")
                    .tr(),
                style: textStyles.kTextTwelveW500.copyWith(
                  color: isDarkMode
                      ? colors.kColorWhite
                      : colors.kColorProfileName,
                ),
              )
            ],
          ),
          Sizer.half(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_8,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: isDarkMode
                    ? colors.kColorPinTextfieldDarkTheme
                    : colors.kColorBlueLight,
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.pad_16,
                  vertical: sizes.pad_16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$type Qty.",
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyDark,
                              ),
                            ),
                          ],
                        ),
                        Sizer.half(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${qty}',
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorProfileName,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$type Price",
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyDark,
                              ),
                            ),
                          ],
                        ),
                        Sizer.half(),
                        Row(
                          children: [
                            Text(
                              '$price',
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorProfileName,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "$type Value",
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyDark,
                              ),
                            ),
                          ],
                        ),
                        Sizer.half(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$value',
                              style: textStyles.kTextTwelveW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorProfileName,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Position Convert
///
///
///

class PositionsConvert extends ConsumerWidget {
  final PositionBookInfoResult data;
  const PositionsConvert({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.pad_16,
      ),
      child: Column(
        children: [
          Sizer.vertical10(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: sizes.pad_16,
            ),
            child: CustomLongButton(
                height: 48,
                borderRadius: 8,
                color: colors.kColorBlue,
                label: ('convertPosition').tr(),
                labelStyle: textStyles.kTextFourteenW700
                    .copyWith(color: colors.kColorWhite),
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        // insetPadding:EdgeInsets.symmetric(horizontal: sizes.regularPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        title: PositionConvertAlertDialogHeader(
                          data: data,
                        ),
                        content: PositionConvertAlertDialogBody(
                          data: data,
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class HeadingWidget extends ConsumerWidget {
  final String title;
  const HeadingWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
              ),
              child: Text(title,
                  style: textStyles.kTextTwelveW500.copyWith(
                    color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
                  )),
            ),
          ],
        ),
        Column(
          children: [],
        )
      ],
    );
  }
}

class ExtraInfo extends ConsumerWidget {
  final MDdata data;
  const ExtraInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, Routes.newAlert,
                  //     arguments: false);
                  // ScripAlertInput input = ScripAlertInput(
                  //   exch: data.exch,
                  //   token: data.token,
                  //   value: data.ltp,
                  //   scripName: data.scripName,
                  //   perChange: data.perChange,
                  //   change: data.change,
                  //   isEdit: false,
                  //   tradingSymbol: '',
                  // );
                  // ref.read(alertListProvider).setData(input);
                },
                child: ExtraInfoBoxInfo(
                  asset: assets.alertIcon,
                  title: 'Alert',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: ExtraInfoBoxInfo(
                  asset: assets.gttOrderIcon,
                  title: 'GTT',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            if (data.exchg!.toLowerCase() == "nse" ||
                data.exchg!.toLowerCase() == "bse")
              Expanded(
                child: InkWell(
                  onTap: () {
                    // WebViewInput args = WebViewInput(
                    //   url:
                    //       'https://stocks.tickertape.in/${data.scripName.toLowerCase().contains('-') ? data.scripName.split("-")[0] : data.scripName}?broker=aliceblue',
                    //   // theme: theme,
                    //   title: 'Fundamentals',
                    // );
                    // Navigator.pushNamed(
                    //   context,
                    //   Routes.webView,
                    //   arguments: args,
                    // );
                  },
                  child: ExtraInfoBoxInfo(
                    asset: assets.smallcase_logo,
                    title: ('fundamental').tr(),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: ExtraInfoBoxInfo(
                  asset: assets.technicalIcon,
                  title: ('technicals').tr(),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ExtraInfoBoxInfo extends ConsumerWidget {
  final String asset;
  final String title;
  final double? width;
  final double? height;
  final bool isShowBorder;
  const ExtraInfoBoxInfo({
    Key? key,
    required this.asset,
    required this.title,
    this.height,
    this.width,
    this.isShowBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Column(
      children: [
        SvgPicture.asset(
          asset,
          color: colors.kColorBlue,
          width: width,
          height: height,
        ),
        Sizer.half(),
        Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: textStyles.kTextFourteenW400.copyWith(
            color: isDarkMode
                ? colors.kColorBottomWhiteTextDarkTheme
                : colors.kColorGreyText,
          ),
        ),
      ],
    );
  }
}

class ShowAppsList extends ConsumerWidget {
  final String asset;
  final String title;
  final VoidCallback? onTap;

  const ShowAppsList({
    Key? key,
    required this.asset,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizes.pad_16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                asset,
              ),
            ),
            Sizer.horizontal(),
            Text(
              title,
              style: textStyles.kTextTwelveW400.copyWith(
                  color: isDarkMode
                      ? colors.kColorBottomWhiteTextDarkTheme
                      : colors.kColorBlack),
            ),
          ],
        ),
      ),
    );
  }
}

class SpotBox extends ConsumerWidget {
  final MDdata dp;
  final String Label;
  final bool isSelected;
  final Function ontap;
  SpotBox({
    Key? key,
    required this.dp,
    required this.Label,
    required this.isSelected,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CustomOutlineButton(
            borderRadius: 6,
            color: colors.kColorBlue,
            label: Label,
            height: 29,
            isSelected: isSelected,
            onPress: ontap),
      ],
    );
  }
}


// class OrderHistoryInfo extends ConsumerWidget {
//   final ScrollController controller;
//   const OrderHistoryInfo({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final orderHelper = ref.watch(orderHelperProvider);
//     return (orderHelper.loading ||
//             orderHelper.orderHistoryInfo == null ||
//             orderHelper.orderHistoryInfo!.result == null ||
//             orderHelper.orderHistoryInfo!.result!.isEmpty)
//         ? Container()
//         : NotificationListener<OverscrollIndicatorNotification>(
//             onNotification: (overscroll) {
//               overscroll.disallowIndicator();
//               return true;
//             },
//             child: ListView.builder(
//               itemCount: orderHelper.orderHistoryInfo!.result!.length,
//               controller: controller,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, int index) => OrderHistoryRow(
//                 showShadow: index % 2 == 0,
//                 status: checkIsInfOrNullOrNanOrZero(
//                         orderHelper.orderHistoryInfo!.result![index].status ??
//                             '')
//                     ? '--'
//                     : orderHelper.orderHistoryInfo!.result![index].status!,
//                 time: checkIsInfOrNullOrNanOrZero(
//                         orderHelper.orderHistoryInfo!.result![index].time ?? '')
//                     ? '--'
//                     : (orderHelper.orderHistoryInfo!.result![index].time!
//                                 .contains(" ") &&
//                             orderHelper.orderHistoryInfo!.result![index].time!
//                                     .split(" ")
//                                     .length >=
//                                 2)
//                         ? orderHelper.orderHistoryInfo!.result![index].time!
//                             .split(" ")[0]
//                         : orderHelper.orderHistoryInfo!.result![index].time!,
//                 value:
//                     '${checkIsInfOrNullOrNanOrZero(orderHelper.orderHistoryInfo!.result![index].fillshares ?? '') ? '--' : orderHelper.orderHistoryInfo!.result![index].fillshares} / ${checkIsInfOrNullOrNanOrZero(orderHelper.orderHistoryInfo!.result![index].quantity ?? '') ? '--' : orderHelper.orderHistoryInfo!.result![index].quantity}',
//               ),
//             ),
//           );
//   }
// }