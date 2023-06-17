import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/res/res.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../model/indian_indices_model.dart';
import '../../../model/market_depth_model.dart';
import '../../../model/search_scrip_data.dart';
import '../../../util/sizer.dart';
import '../../market_depth/bottom_sheet_header.dart';
import '../../market_depth/market_depth_screen.dart';

class IndexBottomSheet extends ConsumerStatefulWidget {
  final IndianIndices data;
  final bool isDarkMode;
  const IndexBottomSheet({
    Key? key,
    required this.data,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  ConsumerState<IndexBottomSheet> createState() => _IndexBottomSheetState();
}

class _IndexBottomSheetState extends ConsumerState<IndexBottomSheet> {
  late IndianIndices data;
  late bool isDarkMode;
  var child;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          color: isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: BottomSheetHeader(
              data: BottomSheetInput(
                change: data.change,
                exchange: data.exchange,
                ltp: data.ltp,
                pdc: data.pdc,
                perChange: data.perChange,
                scripName: data.scripName,
                token: data.token,
              ),
            ),
          )),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizes.pad_16, horizontal: sizes.pad_24,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // MDdata mData = MDdata(
                //   openrate: data.open,
                //   perChange: data.perChange,
                //   previouscloserate: data.pdc,
                //   token: data.token,
                //   ltp: data.ltp,
                //   highrate: data.high,
                //   lowrate: data.low,
                //   change: data.change,
                // );
                // ref.read(marketDepthProvider).setDepth(
                //       data: mData,
                //     );
                // final WebViewInput webViewInput = WebViewInput(
                //   title: 'CHART',
                //   isDarkMode: isDarkMode,
                //   url: "${ref.read(webViewProvider).generateChartUrl(
                //         tradingSymbol: data.symbol,
                //         token: data.token,
                //         exchange: "${data.exchange}",
                //         ltp: data.ltp,
                //         isIndex: true,
                //       )}",
                //   isIndex: true,
                // );

                // Navigator.pushNamed(
                //   context,
                //   Routes.webView,
                //   arguments: webViewInput,
                // );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    assets.chartIcon,
                    color: colors.kColorBlue,
                  ),
                  Sizer.qtrHorizontal(),
                  Text("View Chart",
                      style: textStyles.kTextTwelveW400.copyWith(
                        color: colors.kColorBlue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes.pad_24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: isDarkMode
                ? colors.kColorPinTextfieldDarkTheme
                : colors.kColorBlueLight,
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_16,
              vertical: sizes.pad_16,
            ),
            child: OHLC(
              data: MDdata(
                openrate: data.open,
                highrate: data.high,
                lowrate: data.low,
                previouscloserate: data.pdc,
              ),
            ),
          ),
        ),
      ),
      Sizer.vertical24(),
    ]);
  }
}

class IndexBottomSheetSearch extends ConsumerStatefulWidget {
  final SearchScripData data;
  final bool isDarkMode;
  const IndexBottomSheetSearch({
    Key? key,
    required this.data,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  ConsumerState<IndexBottomSheetSearch> createState() =>
      _IndexBottomSheetSearchState();
}

class _IndexBottomSheetSearchState
    extends ConsumerState<IndexBottomSheetSearch> {
  late SearchScripData data;
  late bool isDarkMode;
  var child;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          color: isDarkMode ? colors.kColorAppbarDarkTheme : colors.kColorWhite,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: BottomSheetHeader(
              data: BottomSheetInput(
                change: data.change,
                exchange: data.exch ?? '',
                ltp: data.ltp ?? '0.00',
                pdc: data.close ?? '',
                perChange: data.percentageChange,
                scripName: data.symbol ?? '',
                token: data.token ?? '',
              ),
            ),
          )),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: sizes.pad_16, horizontal: sizes.pad_24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // MDdata mData = MDdata(
                //   openrate: data.open,
                //   perChange: data.percentageChange,
                //   previouscloserate: data.close,
                //   token: data.token,
                //   ltp: data.ltp,
                //   highrate: data.high,
                //   lowrate: data.low,
                //   change: data.change,
                // );
                // ref.read(marketDepthProvider).setDepth(
                //       data: mData,
                //     );
                // final WebViewInput webViewInput = WebViewInput(
                //   title: 'CHART',
                //   isDarkMode: isDarkMode,
                //   url: "${ref.read(webViewProvider).generateChartUrl(
                //         tradingSymbol: data.symbol ?? '',
                //         token: data.token ?? '',
                //         exchange: "${data.exch}",
                //         ltp: data.ltp ?? '0.00',
                //         isIndex: true,
                //       )}",
                //   isIndex: true,
                // );

                // Navigator.pushNamed(
                //   context,
                //   Routes.webView,
                //   arguments: webViewInput,
                // );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    assets.chartIcon,
                    color: colors.kColorBlue,
                  ),
                  Sizer.qtrHorizontal(),
                  Text("View Chart",
                      style: textStyles.kTextTwelveW400.copyWith(
                        color: colors.kColorBlue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes.pad_24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: isDarkMode
                ? colors.kColorPinTextfieldDarkTheme
                : colors.kColorBlueLight,
            padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_16,
              vertical: sizes.pad_16,
            ),
            child: OHLC(
              data: MDdata(
                openrate: data.open,
                highrate: data.high,
                lowrate: data.low,
                previouscloserate: data.close,
              ),
            ),
          ),
        ),
      ),
      Sizer.vertical24(),
    ]);
  }
}
