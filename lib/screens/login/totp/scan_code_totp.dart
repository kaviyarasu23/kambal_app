import 'dart:convert';

import 'package:aliceblue/provider/login_provider.dart';
import 'package:aliceblue/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../provider/theme_provider.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class ScanQRCodeTOTP extends ConsumerStatefulWidget {
  const ScanQRCodeTOTP({super.key});

  @override
  ConsumerState<ScanQRCodeTOTP> createState() => _ScanQRCodeTOTPState();
}

class _ScanQRCodeTOTPState extends ConsumerState<ScanQRCodeTOTP> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).isDarkMode;
    final qrImage = ref.watch(loginProvider).qrImage;
    final secKey = ref.watch(loginProvider).secKey;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizes.pad_16),
            child: Column(
              children: [
                Text(
                  "Scan the QR code on authenticator app",
                  style: textStyles.kTextSixteenW700.copyWith(
                      color: theme ? colors.kColorWhite : colors.kColorBlack),
                ),
                Sizer.vertical10(),
                Visibility(
                  visible: qrImage.isNotEmpty,
                  child: Image.memory(base64.decode(qrImage.split(',').last),
                      width: sizes.width / 2),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: colors.kColorBlue,
                    textStyle: textStyles.kTextFourteenW400,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: secKey));
                    Fluttertoast.showToast(
                        msg: 'Copied', backgroundColor: colors.kColorGreen);
                  },
                  child: Text(
                    "Can't scan? Copy the key.",
                    style: textStyles.kTextFourteenW400.copyWith(
                      color: colors.kColorWhite,
                    ),
                  ),
                ),
                Sizer.vertical24(),
                Text(
                  'Once scanned, the app should give you a 6 digit TOTP. Enter it below.',
                  style: textStyles.kTextFourteenW400.copyWith(
                    color: theme ? colors.kColorWhite70 : colors.kColorBlack80,
                  ),
                ),
                Sizer.vertical24(),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: sizes.pad_8),
                    child: Row(
                      children: [
                        Text(
                          "Enter External TOTP",
                          style: textStyles.kTextFourteenW400.copyWith(
                              color: theme
                                  ? colors.kColorWhite
                                  : colors.kColorBlack),
                        ),
                      ],
                    )),
                Sizer.vertical24(),
                TOTPControllerWithLogin(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class TOTPControllerWithLogin extends ConsumerWidget {
  const TOTPControllerWithLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authModel = ref.watch(loginProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          controller: authModel.otpController,
          inputType: TextInputType.number,
          errorText: authModel.totpError,
          maxCount: 6,
          labelText: 'TOTP',
          isAutofocus: true,
          sumitField: ((value) {
            ref.read(loginProvider).enableTOTP(
                  context,
                );
          }),
          onChanged: (value) {
            if (value.toString().trim().length == 6) {
              ref.read(loginProvider).enableTOTP(
                    context,
                  );
            }
          },
        ),
        Sizer.vertical32(),
        CustomLongButton(
            borderRadius: 4,
            loading: authModel.loading,
            label: "Login",
            color: colors.kColorBlue,
            onPress: () => ref.read(loginProvider).enableTOTP(
                  context,
                )),
      ],
    );
  }
}
