import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../model/place_order_input_model.dart';
import '../../res/res.dart';
import '../../util/sizer.dart';

class ViewChart extends ConsumerStatefulWidget {
  final OrderWindowArguments orderWindowArguments;
  final bool isIndex;
  const ViewChart({
    Key? key,
    required this.orderWindowArguments,
    this.isIndex = false,
  }) : super(key: key);

  @override
  ConsumerState<ViewChart> createState() => _ViewChartState();
}

class _ViewChartState extends ConsumerState<ViewChart> {
  String tradingSymbol = '';
  bool isClicked = false;
  String exch = "";
  bool theme = false;
  bool isIndex = false;
  late OrderWindowArguments data;

  @override
  void initState() {
    super.initState();
    data = widget.orderWindowArguments;
    exch = widget.orderWindowArguments.exchange!;
    isIndex = widget.isIndex;
  }

  // void setTradingSymbol({required MarketHelperProvider marketProvide}) {
  //   theme = marketProvide.ref(themeProvider).isDarkMode;
  //   if (isIndex) {
  //     tradingSymbol = data.tradingSymbol ?? '';
  //   } else {
  //     tradingSymbol = (exch.toLowerCase() == 'nse' ||
  //             exch.toLowerCase() == 'bse')
  //         ? '${marketProvide.getMarketDepth[0].exchange!.toLowerCase() == exch.toLowerCase() ? marketProvide.getMarketDepth[0].symbol! : marketProvide.getMarketDepth[1].symbol!}'
  //         : '${marketProvide.getMarketDepth[0].tradingSymbol}';
  //   }

  //   if (isClicked) {
  //     chartView();
  //   }
  // }

  void chartView() {
    isClicked = false;
    // final WebViewInput webViewInput = WebViewInput(
    //   title: 'CHART',
    //   isDarkMode: theme,
    //   url: "${ref.read(webViewProvider).generateChartUrl(
    //         tradingSymbol: tradingSymbol,
    //         token: data.token,
    //         exchange: data.exchange!,
    //         ltp: data.ltp,
    //         isIndex: isIndex,
    //       )}",
    //   orderWidArgs: data,
    //   isIndex: isIndex,
    // );

    // Navigator.pushNamed(
    //   ref.read(tabControllProvider).context!,
    //   Routes.webView,
    //   arguments: webViewInput,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // final marketProvide = ref.watch(marketHelperProvider);
    // if ((!marketProvide.loading && marketProvide.getMarketDepth.isNotEmpty) ||
    //     (isIndex)) {
    //   WidgetsBinding.instance.addPostFrameCallback(
    //     (_) {
    //       setTradingSymbol(marketProvide: marketProvide);
    //     },
    //   );
    // }
    return InkWell(
      onTap: () {
        setState(() {
          isClicked = true;
        });
        if (tradingSymbol.isNotEmpty) {
          chartView();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}

class ViewChartWatchList extends ConsumerWidget {
  final OrderWindowArguments orderWindowArguments;
  final VoidCallback onTap;
  const ViewChartWatchList({
    Key? key,
    required this.orderWindowArguments,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          SvgPicture.asset(
            assets.chartIcon,
            color: colors.kColorBlue,
          ),
          Text(
            "View Chart",
            style: textStyles.kTextTwelveW400.copyWith(
              color: colors.kColorBlue,
            ),
          ),
        ],
      ),
    );
  }
}
