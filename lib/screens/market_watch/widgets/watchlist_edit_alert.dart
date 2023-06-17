import 'dart:developer';
import 'package:aliceblue/provider/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/market_watch_list_model.dart';
import '../../../provider/market_helper_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_text_button.dart';
import '../../../shared_widget/snack_bar.dart';
import '../../../util/sizer.dart';

class WatchListEditAlertDialogBody extends ConsumerWidget {
  final String message;
  final int status;
  const WatchListEditAlertDialogBody({
    Key? key,
    required this.message,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketProvide = ref.watch(marketProvider);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
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
                    log("Clicked STATUS ::: $status");
                    ref.read(marketHelperProvider).discardChanges(status);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
              Sizer.horizontal32(),
              CustomTextButton(
                  textStyle: textStyles.kTextFourteenW400,
                  text: 'Save',
                  onPress: () async {
                    if (status == 2 || status == 3) {
                      MarketWatchNameUpdateInput input =
                          MarketWatchNameUpdateInput(
                        mwId: marketProvide.getWatchList!
                            .result![marketProvide.getTabIndex].mwId!,
                        mwName: marketProvide.watchlistRenameController.text,
                        userId: marketProvide.pref.userId!,
                      );
                      final res = await ref
                          .read(marketHelperProvider)
                          .updateMwName(updateMwInput: input, context: context);
                      if (res) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            successSnackbar(
                                'Market watch name updated successfully'));
                        ref.read(marketProvider).marketWatchName();
                        ref
                            .read(marketHelperProvider)
                            .mwNameStatus(status: false);
                      }
                    }
                    if (status == 1) {
                      if (ref
                          .read(marketHelperProvider)
                          .deleteScripList
                          .isNotEmpty) {
                        ref.read(marketHelperProvider).deleteAllFromReorder(
                            context,
                            marketProvide.getWatchList!
                                .result![marketProvide.getTabIndex].mwId
                                .toString());
                      } else {
                        final res = await ref
                            .read(marketProvider)
                            .sortMwListOrder(context: context);
                        if (res) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              successSnackbar(
                                  'Market watch List updated successfully'));
                        }
                      }
                    }
                    ref.read(marketHelperProvider).clearMwNameChange();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ],
          )
        ],
      ),
    );
  }
}

class UpdateAlertDialogHeader extends StatelessWidget {
  const UpdateAlertDialogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('ALERT!');
  }
}
