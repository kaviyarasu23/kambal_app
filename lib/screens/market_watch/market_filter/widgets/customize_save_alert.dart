import 'package:aliceblue/provider/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../res/res.dart';
import '../../../../shared_widget/custom_text_button.dart';
import '../../../../util/sizer.dart';

class CustomizeEditAlertDialogBody extends ConsumerWidget {
  final String message;
  final Function(int val)? updateTab;
  const CustomizeEditAlertDialogBody({
    Key? key,
    required this.message,
    required this.updateTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final marketHelpProvide = watch(marketHelperProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: textStyles.kTextFourteenW400,
        ),
        Sizer.vertical32(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
                textStyle: textStyles.kTextFourteenW400,
                text: 'Discard',
                onPress: () {
                  ref.read(marketProvider).discardFilterChanges();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
            Sizer.horizontal32(),
            CustomTextButton(
                textStyle: textStyles.kTextFourteenW400,
                text: 'Save',
                onPress: () async {
                  ref.read(marketProvider).saveFilter(updateTab: updateTab);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        )
      ],
    );
  }
}
