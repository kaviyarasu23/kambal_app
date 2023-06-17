import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/screens/more_info/more_info_view_model.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
      final isMoreInfoLoading = ref.watch(moreInfoViewProvider).loading;
      final moreInfo = ref.watch(moreInfoViewProvider).getSecurityInfo;
      return Padding(
        padding: EdgeInsets.only(
            left: sizes.pad_16,
            right: sizes.pad_16,
            bottom: sizes.pad_16),
        child: Column(
          children: [
            isMoreInfoLoading
                ? SizedBox(
                    height: sizes.height / 1.5,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListInfo(
                        title: 'Board Lot Quantity',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].lotSize ?? '')))
                            ? moreInfo.result![0].lotSize!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Instrument Name',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].instrumentName ?? '')))
                            ? moreInfo.result![0].instrumentName!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Isin',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.isi ?? '',
                      // ),
                      ListInfo(
                        title: 'Open Interest',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].openIntrest ?? '')))
                            ? moreInfo.result![0].openIntrest!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Precision',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].pricePrecision ?? '')))
                            ? moreInfo.result![0].pricePrecision!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Strike',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.pr,
                      // ),
                      ListInfo(
                        title: 'Ticket Size',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].tickSize ?? '')))
                            ? moreInfo.result![0].tickSize!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Underlying Token',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.,
                      // ),
                      ListInfo(
                        title: 'Instrument Type',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].instrumentType ?? '')))
                            ? moreInfo.result![0].instrumentType!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Issue Start Date',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].issuedate ?? '')))
                            ? moreInfo.result![0].issuedate!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Max Order Size',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].maxOrderSize ?? '')))
                            ? moreInfo.result![0].maxOrderSize!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Price Denominator',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].priceDenominator ??
                                        '')))
                            ? moreInfo.result![0].priceDenominator!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Circuit Rating',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0]. ?? '')))
                      //       ? moreInfo.result![0].priceDenominator!
                      //       : '--',
                      // ),
                      // ListInfo(
                      //   title: 'Display Name',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.symbol ?? '',
                      // ),
                      const ListInfo(
                        title: 'Is Index',
                        value: '-',
                      ),
                      // ListInfo(
                      //   title: 'Max Single QTY',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.maxQty,
                      // ),
                      ListInfo(
                        title: 'Market Type',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].markettype ?? '')))
                            ? moreInfo.result![0].markettype!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Trading Unit',
                      //   value: moreInfoProvide.getSecurityInfo == null
                      //       ? ''
                      //       : moreInfoProvide.getSecurityInfo!.thrtPrc,
                      // ),
                      ListInfo(
                        title: 'Tender Period End Date',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].tenderEndEate ?? '')))
                            ? moreInfo.result![0].tenderEndEate!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Price Quotation Qty.',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].priceQuoteQty ?? '')))
                            ? moreInfo.result![0].priceQuoteQty!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Tender Period Start Date',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].tenderStartDate ?? '')))
                            ? moreInfo.result![0].tenderStartDate!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Delivery End Date',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0]. ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      // ListInfo(
                      //   title: 'Record Date',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].d ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      // ListInfo(
                      //   title: 'Trade to Trade',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].tra ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      ListInfo(
                        title: 'Exchange',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].exchange ?? '')))
                            ? moreInfo.result![0].exchange!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Series',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].seri ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      ListInfo(
                        title: 'Symbol',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].symbolName ?? '')))
                            ? moreInfo.result![0].symbolName!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Trading Symbol',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].tradingSymbol ?? '')))
                            ? moreInfo.result![0].tradingSymbol!
                            : '--',
                      ),
                      ListInfo(
                        title: 'List Date',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].listingDate ?? '')))
                            ? moreInfo.result![0].listingDate!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Price Numerator',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].pr ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      // ListInfo(
                      //   title: 'Comments',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].com ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),

                      // ListInfo(
                      //   title: 'Local Update Time',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].lo ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      ListInfo(
                        title: 'Price Unit',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].priceUnit ?? '')))
                            ? moreInfo.result![0].priceUnit!
                            : '--',
                      ),
                      ListInfo(
                        title: 'Last Trading Date',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].lastTradingDate ?? '')))
                            ? moreInfo.result![0].lastTradingDate!
                            : '--',
                      ),
                      // ListInfo(
                      //   title: 'Delivery Start Date',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].del ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      // ListInfo(
                      //   title: 'General Denominator',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].ge ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                      ListInfo(
                        title: 'Delivery Units',
                        value: (moreInfo != null &&
                                moreInfo.result != null &&
                                moreInfo.result!.isNotEmpty &&
                                (!checkIsInfOrNullOrNanOrZero(
                                    value: moreInfo.result![0].deliveryUnits ?? '')))
                            ? moreInfo.result![0].deliveryUnits!
                            : '--',
                      ),

                      // ListInfo(
                      //   title: 'Re Admission Date',
                      //   value: (moreInfo != null &&
                      //           moreInfo.result != null &&
                      //           moreInfo.result!.isNotEmpty &&
                      //           (!checkIsInfOrNullOrNanOrZero(
                      //               moreInfo.result![0].re ?? '')))
                      //       ? moreInfo.result![0].tenderStartDate!
                      //       : '--',
                      // ),
                    ],
                  ),
            Container(),
          ],
        ),
      );
    });
  }
}

class ListInfo extends StatelessWidget {
  final String title;
  final String value;
  const ListInfo({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sizes.pad_16),
      child: Row(
        children: [
          Text(
            title,
            style: textStyles.kTextFourteenW400.copyWith(color: colors.kColorSubhead),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: textStyles.kTextFourteenW400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoHeader extends StatelessWidget {
  final String tradingSymbol;
  final String exchange;
  const InfoHeader({
    Key? key,
    required this.exchange,
    required this.tradingSymbol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sizes.width,
      child: Card(
        color: colors.kcolorBlueBackgroundSearch,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(sizes.pad_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        tradingSymbol,
                        style: textStyles.kTextTwelveW400.copyWith(
                            color: colors.kColorBlue,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Sizer.vertical10(),
              Text(
                exchange,
                style: textStyles.kTextTwelveW400.copyWith(
                    color: colors.kColorBlack, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
