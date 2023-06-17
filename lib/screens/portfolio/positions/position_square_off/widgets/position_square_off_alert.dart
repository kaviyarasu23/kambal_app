import 'package:aliceblue/provider/portfolio_service_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../provider/portfolio_provider.dart';
import '../../../../../res/res.dart';
import '../../../../../shared_widget/custom_text_button.dart';
import '../../../../../util/sizer.dart';

class PositionExitAlertDialogBody extends ConsumerWidget {
  final int positionExitCount;
  const PositionExitAlertDialogBody({Key? key, required this.positionExitCount})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exitPositions = ref.watch(portfolioProvider).exitPositions;
    int count = 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          positionExitCount == 1
              ? 'Are you sure, do you want to Exit this position?'
              : 'Are you sure, do you want to Exit these positions?',
          style: textStyles.kTextFourteenW400,
        ),
        Sizer.vertical10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
                textStyle: textStyles.kTextFourteenW400,
                text: 'Yes',
                onPress: () {
                  // ignore: avoid_function_literals_in_foreach_calls
                  exitPositions.forEach((element) async {
                    if (element.isSelected!) {
                      count = count + 1;
                      await ref
                          .read(portfolioServiceSupportProvider)
                          .positionSquareOff(context: context);
                    }
                  });
                }),
            Sizer.horizontal32(),
            CustomTextButton(
                textStyle: textStyles.kTextFourteenW400,
                text: 'No',
                onPress: () {
                  Navigator.pop(context);
                })
          ],
        )
      ],
    );
  }
}

class PositionExitAlertDialogHeader extends StatelessWidget {
  const PositionExitAlertDialogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('ALERT!!!');
  }
}
