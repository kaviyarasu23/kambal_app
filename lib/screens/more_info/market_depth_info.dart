import 'dart:developer';

import 'package:aliceblue/provider/market_depth_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/provider/websocket_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/market_depth_model.dart';
import '../../model/market_watch_list_model.dart';
import '../../model/ws_df_feed_model.dart';

class MarketDepthInfo extends ConsumerStatefulWidget {
  final MoreInfoModelArgs data;
  const MarketDepthInfo({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _MarketDepthInfoState createState() => _MarketDepthInfoState();
}

class _MarketDepthInfoState extends ConsumerState<MarketDepthInfo> {
  late MoreInfoModelArgs data;
  late MDdata dp;
  String exchange = "";
  String token = "";
  int afterPoint = 2;
  bool isAck = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data;
      exchange = widget.data.orderWindowArguments!.exchange!;
      token = widget.data.orderWindowArguments!.token;
      afterPoint =
          (exchange.toLowerCase() == 'cds' || exchange.toLowerCase() == 'bcd')
              ? 4
              : 2;
      dp = ref.read(marketDepthProvider).depthValue ?? MDdata();
      isAck = widget.data.isDepthAck;
    });

    if (!isAck) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(websocketProvider).establishConnection(
              channelInput: '${exchange}|${token}',
              task: 'd',
            );
      });
    }
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
        (first.bp2 != "0" && first.bp2 != "null") ? first.bp2 : dp.bPrice2;
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
    dp.token = (first.tk != null &&
            first.tk != '0' &&
            first.tk != '0.00' &&
            first.tk != '00.00' &&
            first.tk != 'null')
        ? first.tk
        : dp.token;
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
    return Consumer(builder: (context, WidgetRef watch, _) {
      final theme = ref.watch(themeProvider);
      return StreamBuilder(
          stream: ref
              .read(websocketProvider)
              .dfUpdate
              .stream
              .where((event) => event.tk == token),
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
            }
            return Container(
              color: theme.isDarkMode
                  ? colors.kColorDarkthemeBg
                  : colors.kColorWhite,
              child: Column(
                children: [
                  Sizer.vertical16(),
                  Padding(
                      padding: EdgeInsets.only(
                        left: sizes.pad_24,
                        right: sizes.pad_16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                          child: Text("Bid",
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                      color: ref
                                                              .read(
                                                                  themeProvider)
                                                              .isDarkMode
                                                          ? colors.kColorWhite60
                                                          : colors
                                                              .kColorBlack60)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: sizes.pad_6),
                                          child: Text("Orders",
                                              textAlign: TextAlign.center,
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                      color: ref
                                                              .read(
                                                                  themeProvider)
                                                              .isDarkMode
                                                          ? colors.kColorWhite60
                                                          : colors
                                                              .kColorBlack60)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: sizes.pad_6),
                                          child: Text("Qty",
                                              textAlign: TextAlign.end,
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                      color: ref
                                                              .read(
                                                                  themeProvider)
                                                              .isDarkMode
                                                          ? colors.kColorWhite60
                                                          : colors
                                                              .kColorBlack60)),
                                        ),
                                      ],
                                    ),
                                    // ignore: unnecessary_string_interpolations
                                    mdRowBuy(
                                      bp: dp.bPrice1 ?? '0.00',
                                      bq: dp.bQty1 ?? '0',
                                      bno: dp.bOrders1 ?? '0.00',
                                      afterPoint: afterPoint,
                                    ),
                                    mdRowBuy(
                                      bp: dp.bPrice2 ?? '0.00',
                                      bq: dp.bQty2 ?? '0',
                                      bno: dp.bOrders2 ?? '0.00',
                                      afterPoint: afterPoint,
                                    ),
                                    mdRowBuy(
                                      bp: dp.bPrice3 ?? '0.00',
                                      bq: dp.bQty3 ?? '0',
                                      bno: dp.bOrders3 ?? '0.00',
                                      afterPoint: afterPoint,
                                    ),
                                    mdRowBuy(
                                      bp: dp.bPrice4 ?? '0.00',
                                      bq: dp.bQty4 ?? '0',
                                      bno: dp.bOrders4 ?? '0.00',
                                      afterPoint: afterPoint,
                                    ),
                                    mdRowBuy(
                                      bp: dp.bPrice5 ?? '0.00',
                                      bq: dp.bQty5 ?? '0',
                                      bno: dp.bOrders5 ?? '0.00',
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
                                          child: Text("Offer",
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                      color: ref
                                                              .read(
                                                                  themeProvider)
                                                              .isDarkMode
                                                          ? colors.kColorWhite60
                                                          : colors
                                                              .kColorBlack60)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: sizes.pad_6,
                                          ),
                                          child: Text("Orders",
                                              textAlign: TextAlign.center,
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                      color: ref
                                                              .read(
                                                                  themeProvider)
                                                              .isDarkMode
                                                          ? colors.kColorWhite60
                                                          : colors
                                                              .kColorBlack60)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: sizes.pad_6),
                                          child: Text("Qty",
                                              textAlign: TextAlign.end,
                                              style: textStyles.kTextTwelveW400
                                                  .copyWith(
                                                color: ref
                                                        .read(themeProvider)
                                                        .isDarkMode
                                                    ? colors.kColorWhite60
                                                    : colors.kColorBlack60,
                                              )),
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
                                      sp: "${dp.sPrice2}",
                                      sq: "${dp.sQty2}",
                                      sno: "${dp.sOrders2}",
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
                            padding: EdgeInsets.symmetric(
                                vertical: sizes.pad_6),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Total",
                                  style: textStyles.kTextTwelveW400.copyWith(
                                      color: colors.kColorGreenButton),
                                )),
                                Expanded(
                                    child: Text(
                                  getFormatedNumValue(
                                    dp.totalbuyqty ?? "0",
                                    showSign: false,
                                    afterPoint: 0,
                                  ),
                                  textAlign: TextAlign.end,
                                  style: textStyles.kTextTwelveW400.copyWith(
                                      letterSpacing: 0.3,
                                      color: colors.kColorGreenButton),
                                )),
                                Sizer.horizontal(),
                                Expanded(
                                    child: Text(
                                  "Total",
                                  style: textStyles.kTextTwelveW400
                                      .copyWith(color: colors.kColorRed),
                                )),
                                Expanded(
                                    child: Text(
                                  getFormatedNumValue(
                                    dp.totalsellqty ?? "0",
                                    showSign: false,
                                    afterPoint: 0,
                                  ),
                                  textAlign: TextAlign.end,
                                  style: textStyles.kTextTwelveW400.copyWith(
                                      letterSpacing: 0.3,
                                      color: colors.kColorRed),
                                )),
                              ],
                            ),
                          ),
                          Sizer.half(),
                        ],
                      )),
                  Sizer(),
                  // Sizer.vertical16(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sizes.pad_12),
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: ref.read(themeProvider).isDarkMode
                          ? colors.kColorWSCardDarkTheme
                          : colors.kcolorBlueBackgroundSearch,
                      child: Column(
                        children: [
                          Sizer.vertical16(),
                          Row(
                            children: ["Open", "High", "Low", "Close"]
                                .map((e) => Expanded(
                                      child: Text(e,
                                          textAlign: TextAlign.center,
                                          style: textStyles.kTextTwelveW400.copyWith(
                                              color: colors.kColorSubhead)),
                                    ))
                                .toList(),
                          ),
                          Sizer.vertical16(),
                          Row(
                            children: [
                              if (dp.openrate == "NA") "0" else dp.openrate,
                              if (dp.highrate == "NA") "0" else dp.highrate,
                              if (dp.lowrate == "NA") "0" else dp.lowrate,
                              if (dp.previouscloserate == "NA")
                                "0"
                              else
                                dp.previouscloserate,
                            ]
                                .map((e) => Expanded(
                                      child: Text(
                                        getFormatedNumValue(
                                          e ?? '0.00',
                                          showSign: false,
                                          afterPoint: afterPoint,
                                        ),
                                        textAlign: TextAlign.center,
                                        style: textStyles.kTextTwelveW400.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: ref
                                                    .read(themeProvider)
                                                    .isDarkMode
                                                ? colors.kColorWhite
                                                : colors.kColorBlack),
                                      ),
                                    ))
                                .toList(),
                          ),
                          Sizer.vertical16(),
                        ],
                      ),
                    ),
                  ),
                  Sizer.vertical24(),
                  HighLowIndicator(
                    high: dp.highrate!,
                    low: dp.lowrate!,
                    ltp: dp.ltp!,
                    token: token,
                    isDarkMode: theme.isDarkMode,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sizes.pad_24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\u{20B9} ${dp.lowrate ?? "0"}",
                          style: textStyles.kTextTwelveW400
                              .copyWith(color: colors.kColorRed),
                        ),
                        Text(
                          "\u{20B9} ${dp.highrate ?? "0"}",
                          style: textStyles.kTextTwelveW400.copyWith(
                            color: colors.kColorGreen,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "Today's Low / High",
                    style: textStyles.kTextTwelveW400.copyWith(
                      color: ref.read(themeProvider).isDarkMode
                          ? colors.kColorWhite60
                          : colors.kColorBlack60,
                    ),
                  ),
                  Sizer.vertical20(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sizes.pad_24),
                    child: Row(
                      children: [
                        Text(
                          'Other Details',
                          style: textStyles.kTextTwelveW400,
                        )
                      ],
                    ),
                  ),
                  Sizer.vertical16(),
                  DepthRow(
                    showShadow: false,
                    title: "Volume",
                    value: getFormatedNumValue(dp.volume ?? "0",
                        showSign: false, afterPoint: 0),
                  ),
                  if (exchange.toLowerCase() != 'nse' &&
                      exchange.toLowerCase() != 'bse')
                    DepthRow(
                        showShadow: true,
                        title: "Open Interest",
                        value: getFormatedNumValue((dp.openinterest) ?? "0",
                            showSign: false, afterPoint: 0)),
                  DepthRow(
                      showShadow: exchange.toLowerCase() != 'nse' &&
                              exchange.toLowerCase() != 'bse'
                          ? false
                          : true,
                      title: "Avg. trade price",
                      value: getFormatedNumValue(
                        dp.weightedavg.toString() == "NA"
                            ? "0"
                            : dp.weightedavg.toString(),
                        showSign: false,
                        afterPoint: afterPoint,
                      )),
                  DepthRow(
                      showShadow: exchange.toLowerCase() != 'nse' &&
                              exchange.toLowerCase() != 'bse'
                          ? true
                          : false,
                      title: "Last traded Qty",
                      value: getFormatedNumValue(dp.lasttradedqty ?? "0",
                          showSign: false, afterPoint: 0)),
                  DepthRow(
                      showShadow: exchange.toLowerCase() != 'nse' &&
                              exchange.toLowerCase() != 'bse'
                          ? false
                          : true,
                      title: "Last traded Time",
                      value: dp.lasttradedtime ?? "NA"),
                  if ((exchange.toLowerCase() != 'nse' &&
                          exchange.toLowerCase() != 'bse') &&
                      dp.expiry!.isNotEmpty)
                    DepthRow(
                      showShadow: exchange.toLowerCase() != 'nse' &&
                              exchange.toLowerCase() != 'bse'
                          ? true
                          : false,
                      title: "Expiry",
                      value: dp.expiry!,
                    ),
                ],
              ),
            );
          });
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
          getFormatedNumValue(bp ?? "0",
              showSign: false, afterPoint: afterPoint),
          maxLines: 1,
          style: textStyles.kTextTwelveW400
              .copyWith(color: colors.kColorGreenButton, letterSpacing: 0.3),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_6,
        ),
        child: Text(
          "${bno}",
          textAlign: TextAlign.center,
          style: textStyles.kTextTwelveW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorGreenButton),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          "${bq}",
          textAlign: TextAlign.end,
          style: textStyles.kTextTwelveW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorGreenButton),
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
          getFormatedNumValue(sp ?? "0",
              showSign: false, afterPoint: afterPoint),
          style: textStyles.kTextTwelveW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorRed),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_6,
        ),
        child: Text(
          "${sno}",
          textAlign: TextAlign.center,
          style: textStyles.kTextTwelveW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorRed),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
        child: Text(
          "${sq}",
          textAlign: TextAlign.end,
          style: textStyles.kTextTwelveW400
              .copyWith(letterSpacing: 0.3, color: colors.kColorRed),
        ),
      ),
    ],
  );
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
  _HighLowIndicatorState createState() => _HighLowIndicatorState();
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

  void addPointCalculation() {
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
      box2width = highlowDiff * (high - ltpVal);
      box1width = (sizes.width - 40) - box2width;
      log("DF :: BOX 1 WIDTH ${box1width} ::: BOX 2 WIDTH ${box2width}");
    }
    isZeroAva = box1width.isInfinite || box2width.isInfinite;
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
                          width: box1width.isNaN || isZeroAva
                              ? (sizes.width / 2) - 20
                              : box1width,
                          height: 1,
                          color: box1width.isNaN || isZeroAva
                              ? isDarkMode
                                  ? colors.kColorWhite60
                                  : colors.kColorBlack60
                              : colors.kColorGreenButton,
                        ),
                        Container(
                          width: box2width.isNaN || isZeroAva
                              ? (sizes.width / 2) - 20
                              : box2width,
                          color: box2width.isNaN || isZeroAva
                              ? isDarkMode
                                  ? colors.kColorWhite60
                                  : colors.kColorBlack60
                              : colors.kColorRedButton,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  Sizer.vertical10(),
                ],
              ),
              Positioned(
                top: 10,
                left: isZeroAva ? 16 : box1width + 15,
                child: Image.asset(assets.bluePin, height: 14, width: 8),
              ),
            ],
          );
        });
  }
}

class DepthRow extends ConsumerWidget {
  final String title;
  final String value;
  final bool showShadow;

  const DepthRow(
      {Key? key,
      required this.showShadow,
      required this.title,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: ref.read(themeProvider).isDarkMode
          ? colors.kColorDarkthemeBg
          : colors.kColorWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizes.pad_8, horizontal: sizes.pad_24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: textStyles.kTextTwelveW400.copyWith(
                    color: ref.read(themeProvider).isDarkMode
                        ? colors.kColorWhite70
                        : colors.kColorBlack80)),
            Text(value,
                style: textStyles.kTextTwelveW400.copyWith(
                  letterSpacing: 0.3,
                )),
          ],
        ),
      ),
    );
  }
}
