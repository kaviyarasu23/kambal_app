import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/place_order_input_model.dart';
import '../../res/res.dart';
import '../../shared_widget/custom_long_button.dart';
import '../../util/sizer.dart';

class BuySellButton extends ConsumerWidget {
  final bool isBuySell;
  final String isAddExit;
  final String modifyCancelType;
  final String repeatOrderType;
  final String basketAddExit;
  final String modifyBasket;
  final OrderWindowArguments orderWindowArguments;
  final VoidCallback? modifyClick;
  final VoidCallback? modifyBasketClick;
  final VoidCallback? repeatClick;
  final VoidCallback? activeHoldSetClick;
  final VoidCallback? activePosSetClick;
  const BuySellButton({
    Key? key,
    this.isBuySell = false,
    this.isAddExit = '',
    this.modifyCancelType = '',
    this.repeatOrderType = '',
    this.basketAddExit = '',
    this.modifyBasket = '',
    this.modifyClick,
    this.modifyBasketClick,
    this.repeatClick,
    this.activeHoldSetClick,
    this.activePosSetClick,
    required this.orderWindowArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomLongButton(
                        color: (repeatOrderType.isNotEmpty &&
                                    repeatOrderType.toLowerCase() ==
                                        'repeatsell') ||
                                (modifyBasket.isNotEmpty &&
                                    modifyBasket.toLowerCase() == 'modbassell')
                            ? colors.kColorRed
                            : colors.kColorGreen,
                        borderRadius: 8,
                        height: 50,
                        label: isBuySell
                            ? ("buy").tr()
                            : modifyCancelType.isNotEmpty ||
                                    modifyBasket.isNotEmpty
                                ? ('modify').tr()
                                : repeatOrderType.isNotEmpty
                                    ? "REPEAT ORDER"
                                    : isAddExit.isNotEmpty
                                        ? ("add").tr()
                                        : basketAddExit.isNotEmpty
                                            ? ("addBuy").tr()
                                            : ("buy").tr(),
                        labelStyle: textStyles.kTextFourteenW700
                            .copyWith(color: colors.kColorWhite),
                        onPress: () {
                          final String labelType = (isBuySell
                              ? ("buy").tr()
                              : modifyCancelType.isNotEmpty
                                  ? 'MODIFY'
                                  : repeatOrderType.isNotEmpty
                                      ? "REPEAT ORDER"
                                      : isAddExit.isNotEmpty
                                          ? "ADD"
                                          : basketAddExit.isNotEmpty
                                              ? "ADD BUY"
                                              : modifyBasket.isNotEmpty
                                                  ? 'MODIFY BASKET'
                                                  : ("buy").tr());
                          if (labelType.toLowerCase() == 'modify') {
                            this.modifyClick!();
                          } else if (labelType.toLowerCase() ==
                              'repeat order') {
                            this.repeatClick!();
                          } else if (isAddExit
                              .toLowerCase()
                              .contains('addholdings')) {
                            this.activeHoldSetClick!();
                          } else if (isAddExit
                              .toLowerCase()
                              .contains('addpositions')) {
                            this.activePosSetClick!();
                          } else if (labelType
                              .toLowerCase()
                              .contains('modify basket')) {
                            this.modifyBasketClick!();
                          } else {}

                          orderWindowArguments.type = isBuySell
                              ? 'buy'
                              : isAddExit.isNotEmpty
                                  ? isAddExit.contains("Holdings")
                                      ? 'addHoldings'
                                      : 'addPositions'
                                  : repeatOrderType.isNotEmpty
                                      ? '$repeatOrderType'
                                      : modifyBasket.isNotEmpty
                                          ? '$modifyBasket'
                                          : modifyCancelType.isNotEmpty &&
                                                  modifyCancelType
                                                      .toLowerCase()
                                                      .startsWith("mod")
                                              ? modifyCancelType
                                              : basketAddExit.isNotEmpty
                                                  ? "basketBuy"
                                                  : 'buy';
                          // Navigator.popAndPushNamed(
                          //   context,
                          //   Routes.orderWindow,
                          //   arguments: orderWindowArguments,
                          // );
                        }),
                  ),
                  Visibility(
                    visible: repeatOrderType.isEmpty && modifyBasket.isEmpty,
                    child: Sizer.horizontal(),
                  ),
                  Visibility(
                    visible: repeatOrderType.isEmpty && modifyBasket.isEmpty,
                    child: Expanded(
                      child: CustomLongButton(
                        color: colors.kColorRed,
                        borderRadius: 8,
                        height: 50,
                        label: isBuySell
                            ? ("sell").tr()
                            : modifyCancelType.isNotEmpty
                                ? "CANCEL"
                                : isAddExit.isNotEmpty
                                    ? ("exit").tr()
                                    : basketAddExit.isNotEmpty
                                        ? ("addSell").tr()
                                        : ("sell").tr(),
                        labelStyle: textStyles.kTextFourteenW700
                            .copyWith(color: colors.kColorWhite),
                        onPress: () {
                          if (modifyCancelType.isNotEmpty ||
                              repeatOrderType.isNotEmpty) {
                            if (modifyCancelType
                                .toLowerCase()
                                .startsWith("modify")) {
                              this.modifyClick!();
                              // ref
                              //     .read(orderProvider)
                              //     .setCancelStatus(cancelStatus: true);
                            }
                            // Navigator.pop(context);
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) => AlertDialog(
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(20.0),
                            //           ),
                            //           title:
                            //               const CancelOrderAlertDialogHeader(),
                            //           content: CancelOrderAlertDialogBody(
                            //             cancelCount: 1,
                            //             cancelType: 'one',
                            //           ),
                            //         ));
                          } else {
                            if (isAddExit
                                .toLowerCase()
                                .contains('addholdings')) {
                              this.activeHoldSetClick!();
                            } else if (isAddExit
                                .toLowerCase()
                                .contains('addpositions')) {
                              this.activePosSetClick!();
                            }
                            orderWindowArguments.type = isBuySell
                                ? 'sell'
                                : isAddExit.isNotEmpty
                                    ? isAddExit.contains("Holdings")
                                        ? 'exitHoldings'
                                        : 'exitPositions'
                                    : basketAddExit.isNotEmpty
                                        ? "basketSell"
                                        : 'sell';
                            // Navigator.popAndPushNamed(
                            //   context,
                            //   Routes.orderWindow,
                            //   arguments: orderWindowArguments,
                            // );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Sizer.half(),
            Sizer.qtr()
          ],
        ),
      ),
    );
  }
}
