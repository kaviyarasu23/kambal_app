import 'package:aliceblue/model/position_book_model.dart';
import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared_widget/custom_long_button.dart';
import '../../../../shared_widget/custom_text_form_field.dart';

class PositionConvertAlertDialogBody extends ConsumerWidget {
  final PositionBookInfoResult data;
  const PositionConvertAlertDialogBody({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioViewProv = ref.watch(portfolioProvider);
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        width: sizes.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Sizer.vertical24(),
            // RadioDual(),
            // Sizer.vertical32(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Sizer.horizontal24(),
                    Text(
                      'Max Quantity',
                      style: textStyles.kTextFourteenW700.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60),
                    ),
                  ],
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: sizes.pad_8),
                  child: Text(
                    'Min Quantity',
                    style: textStyles.kTextFourteenW700.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite60
                            : colors.kColorBlack60),
                  ),
                )),
              ],
            ),
            Sizer.half(),
            Row(
              children: [
                Sizer.horizontal24(),
                Expanded(
                    child: Row(
                  children: [
                    Text(
                      isNumberNegative(data.netQty!)
                          ? data.netQty!.substring(1)
                          : data.netQty!,
                      style: textStyles.kTextFourteenW700.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60),
                    ),
                  ],
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    right: sizes.pad_16,
                  ),
                  child: SizedBox(
                      height: 50,
                      child: CustomTextFormField(
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        style: textStyles.kTextFourteenW700.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        ),
                        controller: portfolioViewProv.convertPositionController,
                      )),
                )),
              ],
            ),
            Sizer.vertical20(),
            if (portfolioViewProv.errorQuantity != null &&
                portfolioViewProv.errorQuantity != "")
              Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                    portfolioViewProv.errorQuantity!,
                    style: textStyles.kTextFourteenW600
                        .copyWith(color: colors.kColorRed),
                  )))
                ],
              )
            else
              const SizedBox(),
            Sizer.vertical20(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizes.pad_16,
              ),
              child: CustomLongButton(
                  color: double.parse(data.netQty!).isNegative
                      ? colors.kColorRed
                      : colors.kColorBlue,
                  label: 'CONVERT POSITION',
                  onPress: () {
                    ref
                        .read(portfolioProvider)
                        .convertPositionQuantityValidation(context, data);
                  }),
            ),
            Sizer.vertical10()
          ],
        ),
      ),
    );
  }
}

class PositionConvertAlertDialogHeader extends ConsumerWidget {
  final PositionBookInfoResult data;
  const PositionConvertAlertDialogHeader({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(
          sizes.pad_12,
        ),
        child: Column(
          children: [
            Sizer.vertical10(),
            Row(
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                  data.displayName!.toUpperCase(),
                  style: textStyles.kTextFourteenW400
                      .copyWith(fontWeight: FontWeight.w600),
                )))
              ],
            ),
            Sizer.vertical24(),
            Row(
              children: [
                Expanded(
                    child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: sizes.pad_56,
                            minHeight: sizes.pad_56,
                          ),
                          color: data.product == 'MIS'
                              ? isDarkMode
                                  ? colors.kColorLightBlueDarkTheme
                                  : colors.KColorLightBlueBg
                              : isDarkMode
                                  ? colors.kColorLightVioletDarkTheme
                                  : colors.kColorLightYellowLightTheme,
                          child: Center(
                            child: Text(
                              data.product!,
                              style: textStyles.kTextFourteenW400.copyWith(
                                color: data.product == 'MIS'
                                    ? isDarkMode
                                        ? colors.kColorBlueDarkTheme
                                        : colors.kColorBlueText
                                    : isDarkMode
                                        ? colors.kColorVioletDarkTheme
                                        : colors.kColorYellowLightTheme,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 30,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Align(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: data.product == 'NRML' || data.product == 'CNC'
                              ? isDarkMode
                                  ? colors.kColorLightBlueDarkTheme
                                  : colors.KColorLightBlueBg
                              : isDarkMode
                                  ? colors.kColorLightVioletDarkTheme
                                  : colors.kColorLightYellowLightTheme,
                          constraints: BoxConstraints(
                            minWidth: sizes.pad_56,
                            minHeight: sizes.pad_56,
                          ),
                          child: Center(
                            child: Text(
                              data.product == 'NRML' || data.product == 'CNC'
                                  ? 'MIS'
                                  : data.exchange == 'NSE' ||
                                          data.exchange == 'BSE'
                                      ? 'CNC'
                                      : 'NRML',
                              style: textStyles.kTextFourteenW400.copyWith(
                                color: data.product == 'NRML' ||
                                        data.product == 'CNC'
                                    ? isDarkMode
                                        ? colors.kColorBlueDarkTheme
                                        : colors.kColorBlueText
                                    : isDarkMode
                                        ? colors.kColorVioletDarkTheme
                                        : colors.kColorYellowLightTheme,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
            Sizer.vertical10(),
          ],
        ),
      ),
    );
  }
}
