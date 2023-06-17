



import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/indian_indices_model.dart';
import '../../../model/ws_tf_feed_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../provider/websocket_provider.dart';
import '../../../res/res.dart';
import '../../../util/functions.dart';
import '../../../util/sizer.dart';

class StickyHeader extends ConsumerStatefulWidget {
  final IndianIndices data;

  const StickyHeader({Key? key, required this.data}) : super(key: key);

  @override
  StickyHeaderState createState() => StickyHeaderState();
}

class StickyHeaderState extends ConsumerState<StickyHeader>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ref.read(websocketProvider).establishConnection(
          channelInput: '${widget.data.exchange}|${widget.data.token}',
          task: 't',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return StreamBuilder(
        stream: ref
            .read(websocketProvider)
            .tfUpdate
            .stream
            .where((event) => event.tk == widget.data.token),
        builder: (_, AsyncSnapshot<TouchlineUpdateStream> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.tk == widget.data.token) {
              widget.data.open =
                  snapshot.data!.o == null || snapshot.data!.o! == 'null'
                      ? widget.data.open
                      : snapshot.data!.o!;
              widget.data.high =
                  snapshot.data!.h == null || snapshot.data!.h! == 'null'
                      ? widget.data.high
                      : snapshot.data!.h!;
              widget.data.low =
                  snapshot.data!.l == null || snapshot.data!.l! == 'null'
                      ? widget.data.low
                      : snapshot.data!.l!;
              widget.data.ltp =
                  snapshot.data!.lp == null || snapshot.data!.lp! == 'null'
                      ? widget.data.ltp
                      : snapshot.data!.lp!;
              log('LTP VAL ::: STICKY HEADER ${widget.data.ltp}');
              widget.data.perChange =
                  snapshot.data!.pc == null || snapshot.data!.pc! == 'null'
                      ? widget.data.perChange
                      : snapshot.data!.pc!;
              widget.data.pdc =
                  snapshot.data!.c == null || snapshot.data!.c! == 'null'
                      ? widget.data.pdc
                      : snapshot.data!.c!;

              widget.data.change = (double.parse(widget.data.ltp) -
                      double.parse(widget.data.pdc))
                  .toString();
            }
          }
          return InkWell(
            onTap: () {
              // final WebViewInput webViewInput = WebViewInput(
              //   title: 'CHART',
              //   isDarkMode: isDarkMode,
              //   url: "${ref.read(webViewProvider).generateChartUrl(
              //         tradingSymbol: widget.data.scripName,
              //         token: widget.data.token,
              //         exchange: widget.data.exchange,
              //         ltp: widget.data.ltp,
              //         isIndex: true,
              //       )}",
              //   isIndex: true,
              // );

              // Navigator.pushNamed(
              //   ref.read(tabControllProvider).context!,
              //   Routes.webView,
              //   arguments: webViewInput,
              // );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.scripName,
                          style: textStyles.kTextTwelveW500.copyWith(
                            color: isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorBlack,
                          ),
                        ),
                        Sizer.qtr(),
                        Row(
                          children: [
                            Text(
                              getFormatedNumValue(
                                widget.data.ltp,
                                afterPoint: 2,
                                showSign: false,
                              ),
                              style: textStyles.kTextTwelveW500.copyWith(
                                color: isNumberNegative(widget.data.perChange)
                                    ? colors.kColorRed
                                    : colors.kColorGreen,
                              ),
                            ),
                            Sizer.halfHorizontal(),
                            Text(
                              "(${widget.data.perChange} %)",
                              style: textStyles.kTextTwelveW500.copyWith(
                                color: isDarkMode
                                    ? colors.kColorBottomWhiteTextDarkTheme
                                    : colors.kColorGreyText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
