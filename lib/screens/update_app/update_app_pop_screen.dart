import 'package:aliceblue/provider/splash_provider.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../res/res.dart';
import '../../shared_widget/custom_text_button.dart';
import '../../util/sizer.dart';

class UpdateAlertDialogBody extends ConsumerWidget {
  final String updateMessage;
  final bool isUpdateAvailable;
  const UpdateAlertDialogBody({
    Key? key,
    required this.updateMessage,
    required this.isUpdateAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashPro = ref.watch(splashProvider);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            updateMessage,
            style: textStyles.kTextFourteenW400,
          ),
          Sizer.vertical10(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomTextButton(
                  textStyle: textStyles.kTextFourteenW400,
                  text: 'Update',
                  onPress: () {}),
              Visibility(
                  visible: (isUpdateAvailable), child: Sizer.horizontal32()),
              Visibility(
                visible: (isUpdateAvailable),
                child: CustomTextButton(
                    textStyle: textStyles.kTextFourteenW400,
                    text: 'May be Later',
                    onPress: () async {
                      if(!checkIsInfOrNullOrNan(value: splashPro.pref.userId)){

                      }
                      // if (userId != null && userId.isNotEmpty) {
                      //   // if (ref.read(loginProvider).isBioEnable &&
                      //   //     ref.read(loginProvider).isBiometricSupported &&
                      //   //     ref.read(loginProvider).isBioCheck) {
                      //   //   Navigator.pushNamedAndRemoveUntil(
                      //   //       context, Routes.bioMetric, (route) => false);
                      //   // }
                      //   if (!authPro.pref.isSessionLogout) {
                      //     ref
                      //         .read(loginProvider)
                      //         .biometricLogin(context: context, isFrom: '');
                      //   } else {
                      //     Navigator.pushNamedAndRemoveUntil(context,
                      //         Routes.newverifypasswordScreen, (route) => false);
                      //   }
                      // } else {
                      //   Navigator.pushNamedAndRemoveUntil(
                      //       context, Routes.login, (route) => false);
                      // }
                    }),
              )
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