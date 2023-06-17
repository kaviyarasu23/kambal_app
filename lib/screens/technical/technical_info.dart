import 'package:aliceblue/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/market_helper_provider.dart';
import '../../res/res.dart';
import '../../util/functions.dart';

class Technical extends ConsumerWidget {
  const Technical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketProvide = ref.watch(marketHelperProvider);
    final theme = ref.watch(themeProvider);
    return marketProvide.loading
        ? Container(
            height: 100, child: Center(child: CircularProgressIndicator()))
        : Container(
            color: theme.isDarkMode
                ? colors.kColorDarkthemeBg
                : colors.kColorWhite,
            child: Table(
              children: [
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizes.pad_8),
                    child: Text("Resistance",
                        style: textStyles.kTextFourteenW400.copyWith(
                          color: theme.isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizes.pad_8),
                    child: Text("Pivot",
                        textAlign: TextAlign.center,
                        style: textStyles.kTextFourteenW400.copyWith(
                          color: theme.isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizes.pad_8),
                    child: Text("Support",
                        textAlign: TextAlign.end,
                        style: textStyles.kTextFourteenW400.copyWith(
                          color: theme.isDarkMode
                              ? colors.kColorWhite60
                              : colors.kColorBlack60,
                        )),
                  ),
                ]),
                TechnicalmdRow(
                  count: '1',
                  pi: '',
                  res: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.resistance1,
                          afterPoint: 2,
                          showSign: false),
                  sup: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.support1,
                          afterPoint: 2,
                          showSign: false,
                        ),
                  isDark: theme.isDarkMode,
                ),
                TechnicalmdRow(
                  count: '2',
                  pi: '${marketProvide.getTechnicalAnalysisData == null || marketProvide.getTechnicalAnalysisData!.result == null ? "0" : getFormatedNumValue(marketProvide.getTechnicalAnalysisData!.result!.pivotPoints.pivotPoints, afterPoint: 2, showSign: false)}',
                  res: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.resistance2,
                          afterPoint: 2,
                          showSign: false),
                  sup: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.support2,
                          afterPoint: 2,
                          showSign: false),
                  isDark: theme.isDarkMode,
                ),
                TechnicalmdRow(
                  count: '3',
                  pi: '',
                  res: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.resistance3,
                          afterPoint: 2,
                          showSign: false),
                  sup: marketProvide.getTechnicalAnalysisData == null ||
                          marketProvide.getTechnicalAnalysisData!.result == null
                      ? "0"
                      : getFormatedNumValue(
                          marketProvide.getTechnicalAnalysisData!.result!
                              .pivotPoints.support3,
                          afterPoint: 2,
                          showSign: false),
                  isDark: theme.isDarkMode,
                ),
              ],
            ),
          );
  }
}

TableRow TechnicalmdRow({
  required String? res,
  required String? count,
  required String? pi,
  required String? sup,
  required bool isDark,
}) {
  return TableRow(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_8,
        ),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'R${count} ',
                style: textStyles.kTextFourteenW400.copyWith(
                  color: isDark ? colors.kColorWhite : colors.kColorBlack,
                )),
            TextSpan(
                text: '$res',
                style: textStyles.kTextFourteenW400.copyWith(
                  color: isDark ? colors.kColorWhite60 : colors.kColorBlack60,
                )),
          ]),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_8,
        ),
        child: Text(
          "${pi}",
          textAlign: TextAlign.center,
          style: textStyles.kTextFourteenW400.copyWith(
            color: isDark ? colors.kColorWhite60 : colors.kColorBlack60,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizes.pad_8,
        ),
        child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(children: [
            TextSpan(
                text: 'S${count} ',
                style: textStyles.kTextFourteenW400.copyWith(
                  color: isDark ? colors.kColorWhite : colors.kColorBlack,
                )),
            TextSpan(
                text: '$sup',
                style: textStyles.kTextFourteenW400.copyWith(
                  color: isDark ? colors.kColorWhite60 : colors.kColorBlack60,
                )),
          ]),
        ),
      ),
    ],
  );
}
