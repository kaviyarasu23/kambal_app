import 'dart:async';
import 'dart:developer';

import 'package:aliceblue/provider/login_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class ConfirmOTPScreen extends ConsumerStatefulWidget {
  const ConfirmOTPScreen({super.key});

  @override
  ConsumerState<ConfirmOTPScreen> createState() => _ConfirmOTPScreenState();
}

class _ConfirmOTPScreenState extends ConsumerState<ConfirmOTPScreen> {
  late Timer _timer;
  int _start = 30;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (_start != 0) {
          setState(() {
            _start--;
          });
        } else {
          setState(() {
            _start = 0;
          });
        }
      }
    });
  }

  @override
  void initState() {
    _timer = Timer(Duration(seconds: 1), () => log("Timer initialized"));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(loginProvider).generateScanner(context);
      startTimer();
    });
  }

  void resendOTP() {
    ref.read(loginProvider).generateScanner(context);
    _start = 30;
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final loginProv = ref.watch(loginProvider);
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizes.pad_16),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      assets.loginProfileIcon,
                    )),
              ],
            ),
            Sizer.vertical24(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: textStyles.kTextTwentyW700.copyWith(
                      color:
                          isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                ),
              ],
            ),
            Sizer.vertical10(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loginProv.pref.userId.toString(),
                  style: textStyles.kTextFourteenW400.copyWith(
                      color:
                          isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                ),
                Sizer.halfHorizontal(),
              ],
            ),
            Sizer.vertical48(),
            CustomTextFormField(
              inputType: TextInputType.number,
              borderRadius: 6,
              maxCount: 6,
              isAutofocus: true,
              labelText: ('enterOTPforTotp').tr(),
              style: textStyles.kTextFourteenW400.copyWith(
                  color: isDarkMode ? colors.kColorWhite : colors.kColorBlack),
              hintStyle: textStyles.kTextFourteenW400.copyWith(
                  color:
                      isDarkMode ? colors.kColorWhite : colors.kColorGreyText),
              hintText: '******',
              errorText: loginProv.otpError,
              controller: loginProv.otpController,
              onChanged: (value) {
                if (value.toString().length == 6) {
                  ref.read(loginProvider).verifyOTP(context);
                }
              },
              sumitField: (value) {
                if (value.toString().length == 6) {
                  ref.read(loginProvider).verifyOTP(context);
                }
              },
            ),
            Sizer.vertical10(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (_start == 0) {
                      resendOTP();
                    }
                  },
                  child: Text(
                    _start != 0
                        ? _start < 10
                            ? '${('resendOTP').tr()} in  0:0$_start'
                            : '${('resendOTP').tr()} in  0:$_start'
                        : ('resendOTP').tr(),
                    style: textStyles.kTextFourteenW400
                        .copyWith(color: colors.kColorBlue),
                  ),
                )
              ],
            ),
            Sizer.vertical42(),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'An OTP has been sent to your registered Mobile Number & Email ID ',
                    style: textStyles.kTextFourteenW400.copyWith(
                      color:
                          isDarkMode ? colors.kColorWhite : colors.kColorBlack,
                    ),
                  ),
                ],
              ),
            ),
            Sizer.vertical48(),
            Row(
              children: [
                Expanded(
                  child: CustomLongButton(
                      borderRadius: 6,
                      color: colors.kColorBlue,
                      label: ('proceed').tr(),
                      loading: loginProv.loading,
                      labelStyle: textStyles.kTextFourteenW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorWhite,
                      ),
                      onPress: () {
                        ref.read(loginProvider).verifyOTP(context);
                      }),
                ),
              ],
            ),
          ]),
        ),
      )),
    ));
  }
}
