import 'dart:developer';

import 'package:aliceblue/provider/portfolio_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../res/res.dart';
import '../../../../shared_widget/custom_long_button.dart';
import 'widgets/position_square_off_alert.dart';
import 'widgets/position_square_off_card.dart';

class PositionSquareOffScreen extends ConsumerStatefulWidget {
  const PositionSquareOffScreen({super.key});

  @override
  ConsumerState<PositionSquareOffScreen> createState() =>
      _PositionSquareOffScreenState();
}

class _PositionSquareOffScreenState
    extends ConsumerState<PositionSquareOffScreen> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final positions = ref.read(portfolioProvider).exitPositions;
    return WillPopScope(
      onWillPop: () async {
        positions.forEach((element) {
          element.isSelected = false;
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Exit Positions',
            style: textStyles.kTextSixteenW700.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  if (count != 0) {
                    count = 0;
                  }
                  positions.forEach((element) {
                    element.isSelected = true;
                    count = count + 1;
                  });
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.pad_12,
                ),
                child: Center(
                  child: Text(
                    "Select All",
                    style: textStyles.kTextFourteenW400.copyWith(
                      color: colors.kColorBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                height: 1,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, i) => const Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  itemBuilder: (_, int i) => positions.length != i
                      ? InkWell(
                          onTap: () {
                            final bool isSelect = positions[i].isSelected!;
                            setState(() {
                              positions[i].isSelected = !isSelect;
                              log('$isSelect');
                              if (isSelect) {
                                count = count - 1;
                              } else {
                                count = count + 1;
                              }
                            });
                          },
                          child: ExitAllPositionsCard(
                            data: positions[i],
                          ),
                        )
                      : Container(),
                  itemCount: positions.length + 1,
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          CustomLongButton(
              color:
                  count == 0 ? colors.kColorLightRedButtonBg : colors.kColorRed,
              label: count <= 1 ? "Exit Position" : "Exit $count Positions",
              onPress: count == 0
                  ? () {}
                  : () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title: const PositionExitAlertDialogHeader(),
                                content: PositionExitAlertDialogBody(
                                  positionExitCount: count,
                                ),
                              ));
                    })
        ],
      ),
    );
  }
}
