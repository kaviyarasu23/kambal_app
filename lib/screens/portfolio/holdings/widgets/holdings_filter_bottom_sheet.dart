// ignore_for_file: non_constant_identifier_names


import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/sizer.dart';

class HoldingFilterBottomSheet extends ConsumerWidget {
  const HoldingFilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioProv = ref.watch(portfolioProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: sizes.pad_16, vertical: sizes.pad_16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: textStyles.kTextFourteenW600,
              ),
              InkWell(
                  onTap: () {
                    ref.read(portfolioProvider).clearHoldingsFilter();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CLEAR",
                    style:
                        textStyles.kTextFourteenW400.copyWith(color: colors.kColorBlue),
                  ))
            ],
          ),
        ),
        Sizer.vertical10(),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        const Sizer(),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
              child: Text(
                "Sort",
                style: textStyles.kTextFourteenW600,
              ),
            ),
          ],
        ),
        Sizer.vertical10(),
        PositionFilterSort(
          leading: portfolioProv.getIsDecending == 'default'
              ? Text(
                  'A-Z',
                  style: textStyles.kTextSixteenW400,
                )
              : Icon(
                  portfolioProv.getIsDecending == 'up'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: portfolioProv.getIsDecending != 'default'
                      ? colors.kColorBlue
                      : null,
                ),
          titleName: 'Alphabetically',
          onTap: () {
            ref.read(portfolioProvider).sortAlphabets(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        PositionFilterSort(
          leading: portfolioProv.getIsUpperPrice == 'default'
              ? Text(
                  'LTP',
                  style: textStyles.kTextSixteenW400,
                )
              : Icon(
                  portfolioProv.getIsUpperPrice == 'up'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: portfolioProv.getIsUpperPrice != 'default'
                      ? colors.kColorBlue
                      : null,
                ),
          titleName: 'Last Traded Price',
          onTap: () {
            ref.read(portfolioProvider).sortLastTradePrice(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        PositionFilterSort(
          leading: portfolioProv.getIsUpperPercen == 'default'
              ? Text(
                  '%',
                  style: textStyles.kTextSixteenW400,
                )
              : Icon(
                  portfolioProv.getIsUpperPercen == 'up'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: portfolioProv.getIsUpperPercen != 'default'
                      ? colors.kColorBlue
                      : null,
                ),
          titleName: 'Change',
          onTap: () {
            ref.read(portfolioProvider).sortLtpPerChange(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        PositionFilterSort(
          leading: portfolioProv.getIsUpperPnl == 'default'
              ? Text(
                  'P&L',
                  style: textStyles.kTextSixteenW400,
                )
              : Icon(
                  portfolioProv.getIsUpperPnl == 'up'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: portfolioProv.getIsUpperPnl != 'default'
                      ? colors.kColorBlue
                      : null,
                ),
          titleName: 'Profit & Loss (Value)',
          onTap: () {
            ref.read(portfolioProvider).sortProfitAndLoss(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        PositionFilterSort(
          leading: portfolioProv.getIsUpperPnlPercent == 'default'
              ? Text(
                  '%',
                  style: textStyles.kTextSixteenW400,
                )
              : Icon(
                  portfolioProv.getIsUpperPnlPercent == 'up'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: portfolioProv.getIsUpperPnlPercent != 'default'
                      ? colors.kColorBlue
                      : null,
                ),
          titleName: 'Profit & Loss (Percentage)',
          onTap: () {
            ref.read(portfolioProvider).sortProfitAndLossPercentage(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        PositionFilterSort(
          leading: Icon(
            portfolioProv.getIsUpperInvest == 'default'
                ? Icons.currency_rupee
                : portfolioProv.getIsUpperInvest == 'up'
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
            color: portfolioProv.getIsUpperInvest != 'default'
                ? colors.kColorBlue
                : null,
          ),
          titleName: 'Invested',
          onTap: () {
            ref.read(portfolioProvider).sortInvestedAmount(false);
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        Sizer.half(),
      ],
    );
  }
}

class PositionFilterSort extends ConsumerWidget {
  final Widget leading;
  final String titleName;
  final VoidCallback? onTap;
  const PositionFilterSort({
    Key? key,
    required this.leading,
    required this.titleName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
        child: ListTile(
          dense: true,
          leading: leading,
          // leading: Text(
          //   leadingTitle,
          //   style: textStyles.kTextSubtitle1,
          // ),
          horizontalTitleGap: 5,
          contentPadding: const EdgeInsets.all(0),
          title: Text(titleName),
        ),
      ),
    );
  }
}





// class HoldingsFilterBottomSheet extends ConsumerStatefulWidget {
//   const HoldingsFilterBottomSheet({Key? key}) : super(key: key);

//   @override
//   HoldingsFilterBottomSheetState createState() =>
//       HoldingsFilterBottomSheetState();
// }

// class HoldingsFilterBottomSheetState
//     extends ConsumerState<HoldingsFilterBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = ref.read(themeProvider).isDarkMode;
//     final holdings = ref.watch(holdingsProvider);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: sizes.pad_16, vertical: sizes.regularPadding),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(('filter').tr(),
//                   style: textStyles.kTextLargeWithWeight.copyWith(
//                     fontSize: 16,
//                     color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
//                   )),
//               InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.close,
//                     size: 18,
//                     color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
//                   ))
//             ],
//           ),
//         ),
//         Sizer.vertical5(),
//         horizontalDividerLine(isDarkMode),
//         Expanded(
//           child: Row(
//             children: [
//               SizedBox(
//                 width: sizes.width / 3.7,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: sizes.pad_12,
//                       vertical: sizes.semiLargePadding),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             holdings.filterIndex = 0;
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             SizedBox(
//                                 child: holdings.filterIndex == 0
//                                     ? FilterTabIndicator()
//                                     : FilterTabIndicatorEmpty()),
//                             Sizer.horizontal15(),
//                             Expanded(
//                               child: FilterTabs(
//                                 filterName: ("sort").tr(),
//                                 icon: assets.sortIcon,
//                                 index: 0,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             holdings.filterIndex = 1;
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             SizedBox(
//                                 child: holdings.filterIndex == 1
//                                     ? FilterTabIndicator()
//                                     : FilterTabIndicatorEmpty()),
//                             Sizer.horizontal15(),
//                             Expanded(
//                               child: FilterTabs(
//                                 filterName: ('exchange').tr(),
//                                 icon: assets.exchangeIcon,
//                                 index: 1,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: sizes.extraTinyPadding),
//                 child: verticalDividerLine(isDarkMode),
//               ),
//               holdings.filterIndex == 0
//                   ? Expanded(
//                       flex: 5,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             right: 2.0, top: sizes.pad_16),
//                         child: RawScrollbar(
//                           thumbVisibility: true,
//                           thickness: 5,
//                           thumbColor: colors.kColorBlue,
//                           child: ListView(children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: 0,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Sizer.vertical10(),
//                                   SortButtonHold(
//                                     langName: ("A-Z").tr(),
//                                     onTap: () {
//                                       holdings.sortAlphabets(false);
//                                     },
//                                     stateName: holdings.getIsDecending,
//                                   ),
//                                   // SortButtonHold(
//                                   //   langName: ("perChange").tr(),
//                                   //   onTap: () {
//                                   //     holdings.sortLtpPerChange(false);
//                                   //   },
//                                   //   stateName: holdings.getIsUpperPercen,
//                                   // ),
//                                   SortButtonHold(
//                                     langName: ('ltpFilter').tr(),
//                                     onTap: () {
//                                       holdings.sortLastTradePrice(false);
//                                     },
//                                     stateName: holdings.getIsUpperPrice,
//                                   ),
//                                   SortButtonHold(
//                                     langName: ('exchangeFilter').tr(),
//                                     onTap: () {
//                                       holdings.sortExchange(false);
//                                     },
//                                     stateName: holdings.getIsExch,
//                                   ),
//                                   SortButtonHold(
//                                     langName: ("profitAndLossHold").tr(),
//                                     onTap: () {
//                                       holdings.sortProfitAndLoss(false);
//                                     },
//                                     stateName: holdings.getIsUpperPnl,
//                                   ),
//                                   SortButtonHold(
//                                     langName: ("profitAndLossPerHold").tr(),
//                                     onTap: () {
//                                       holdings
//                                           .sortProfitAndLossPercentage(false);
//                                     },
//                                     stateName: holdings.getIsUpperPnlPercent,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ))
//                   : Expanded(
//                       flex: 5,
//                       child: ListView(children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: sizes.pad_16,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Sizer.vertical10(),
//                               for (var item in holdings.exchangeList)
//                                 FilterButtonHold(name: item),
//                             ],
//                           ),
//                         )
//                       ]))
//             ],
//           ),
//         ),
//         horizontalDividerLine(isDarkMode),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   holdings.clearFilterHoldings(context);
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   ('clearFilter').tr(),
//                   style: textStyles.kTextkTextFourteenW400.copyWith(
//                     color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
//                   ),
//                 ),
//               ),
//               CustomFlatButton(
//                 color: colors.kColorBlue,
//                 label: ('apply').tr(),
//                 textStyle:
//                     textStyles.kTextkTextFourteenW400.copyWith(color: colors.kColorWhite),
//                 onPress: () {
//                   Navigator.pop(context);
//                 },
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class FilterTabs extends ConsumerWidget {
//   final int index;
//   final String filterName;
//   final String icon;
//   const FilterTabs(
//       {Key? key,
//       required this.index,
//       required this.filterName,
//       required this.icon})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final holdings = ref.watch(holdingsProvider);
//     final isDarkMode = ref.watch(themeProvider).isDarkMode;
//     return Column(
//       children: [
//         Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//                 color: holdings.filterIndex == index
//                     ? isDarkMode
//                         ? colors.kColorBlueDarkBG
//                         : colors.kColorLightBlueBg
//                     : null,
//                 borderRadius: BorderRadius.circular(6)),
//             padding: holdings.filterIndex == index
//                 ? const EdgeInsets.symmetric(vertical: 6)
//                 : const EdgeInsets.symmetric(vertical: 5),
//             child: SvgPicture.asset(
//               icon,
//               color: holdings.filterIndex == index
//                   ? colors.kColorBlue
//                   : isDarkMode
//                       ? colors.kColorBottomWhiteTextDarkTheme
//                       : colors.kColorSubHead,
//             )),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 3),
//           child: Text(filterName,
//               style: textStyles.kTextkTextFourteenW400.copyWith(
//                   color: holdings.filterIndex == index
//                       ? colors.kColorBlue
//                       : isDarkMode
//                           ? colors.kColorBottomWhiteTextDarkTheme
//                           : colors.kColorGreyText)),
//         ),
//       ],
//     );
//   }
// }

// class SortButtonHold extends ConsumerWidget {
//   final String? stateName;
//   final String? langName;
//   final VoidCallback onTap;
//   const SortButtonHold({
//     Key? key,
//     required this.stateName,
//     required this.langName,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final holdings = ref.watch(positionProvider);
//     return TextButton(
//         onPressed: onTap,
//         child: Row(
//           children: [
//             Visibility(
//               visible: stateName != 'default',
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 0.0),
//                 child: Icon(
//                     stateName == 'down'
//                         ? Icons.arrow_downward_outlined
//                         : Icons.arrow_upward_outlined,
//                     size: 16,
//                     color: colors.kColorBlue),
//               ),
//             ),
//             Visibility(
//               visible: stateName != 'default',
//               child: Sizer.halfHorizontal(),
//             ),
//             Visibility(
//               visible: stateName == 'default',
//               child: Sizer.horizontal(),
//             ),
//             Expanded(
//               child: Wrap(
//                 children: [
//                   stateName == holdings.getIsDecending
//                       ? Text(
//                           "${stateName == 'up' ? 'A-Z  ' : stateName == 'down' ? 'Z-A  ' : langName == "A-Z" ? 'A-Z' : "${langName!.toUpperCase()}"}",
//                           style: textStyles.kTextkTextFourteenW400.copyWith(
//                             color: stateName == 'default'
//                                 ? colors.kColorGreyText
//                                 : colors.kColorBlue,
//                           ))
//                       : Text(langName!.toUpperCase(),
//                           style: textStyles.kTextkTextFourteenW400.copyWith(
//                             color: stateName == 'default'
//                                 ? colors.kColorGreyText
//                                 : colors.kColorBlue,
//                           )),
//                 ],
//               ),
//             ),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: sizes.pad_6),
//                 child: stateName != 'default'
//                     ? Icon(
//                         Icons.check_outlined,
//                         size: 18,
//                         color: colors.kColorBlue,
//                       )
//                     : null)
//           ],
//         ));
//   }
// }

// class FilterButtonHold extends ConsumerWidget {
//   final String name;
//   const FilterButtonHold({Key? key, required this.name}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDarkMode = ref.read(themeProvider).isDarkMode;
//     final holdings = ref.watch(holdingsProvider);
//     final bool isSelected = holdings.checkIsFilterItemSelectedHold(item: name);
//     return TextButton(
//       onPressed: () {
//         holdings.addRemoveFilter(selectedValue: name);
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: sizes.regularPadding),
//             child: Text(name,
//                 style: textStyles.kTextkTextFourteenW400.copyWith(
//                   color: isSelected
//                       ? colors.kColorBlue
//                       : isDarkMode
//                           ? colors.kColorBottomWhiteTextDarkTheme
//                           : colors.kColorGreyText,
//                 )),
//           ),
//           Padding(
//               padding: EdgeInsets.symmetric(horizontal: sizes.pad_6),
//               child: isSelected
//                   ? Icon(
//                       Icons.check_outlined,
//                       size: 18,
//                       color: colors.kColorBlue,
//                     )
//                   : null)
//         ],
//       ),
//     );
//   }
// }
