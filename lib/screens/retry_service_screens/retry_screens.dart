import 'package:aliceblue/provider/market_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared_widget/custom_long_button.dart';

class RetryScreen extends ConsumerStatefulWidget {
  final String isFrom;
  const RetryScreen({Key? key, required this.isFrom}) : super(key: key);

  @override
  _RetryScreenState createState() => _RetryScreenState();
}

class _RetryScreenState extends ConsumerState<RetryScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(marketProvider).getUserWatchlist(context: context);
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes.pad_24),
            child: Column(children: [
              Sizer.vertical144(),
              Row(
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      assets.retryScreenIcon,
                      height: 250,
                    ),
                  ),
                ],
              ),
              Sizer.vertical96(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Something went wrong",
                    style: textStyles.kTextSixteenW500.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorBlack),
                  ),
                ],
              ),
              Sizer.half(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please try again",
                    style: textStyles.kTextSixteenW500.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorBlack),
                  )
                ],
              ),
              Sizer.vertical32(),
              Row(
                children: [
                  Expanded(
                    child: CustomLongButton(
                        color: colors.kColorBlue,
                        label: "Retry",
                        onPress: () {
                          if (widget.isFrom == "marketWatch") {
                            ref.watch(marketProvider).getUserWatchlist(
                                  context: context,
                                );
                          } else if (widget.isFrom == "orderWindow") {
                          } else if (widget.isFrom == "ORDERBOOK") {
                            // ref.watch(orderProvider).fetchOrders(context);
                          }
                        }),
                  )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
