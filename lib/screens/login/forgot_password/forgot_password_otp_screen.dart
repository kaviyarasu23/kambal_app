import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/login_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class ForgotPasswordOTPScreen extends ConsumerStatefulWidget {
  const ForgotPasswordOTPScreen({super.key});

  @override
  ConsumerState<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState
    extends ConsumerState<ForgotPasswordOTPScreen> {
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;
  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (secondsRemaining != 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          setState(() {
            enableResend = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resendCode() {
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
      ref
          .read(loginProvider)
          .submitForgotPassword(context: context, isResend: true);
    });
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
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: isDarkMode
                      ? colors.kOTPHeaderDarkThemeBlack
                      : colors.kColorLightBlueBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      sizes.pad_12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Sizer.qtr(),
                            Text(
                              "Enter the 6 digit OTP received in SMS to reset your password.",
                              style: textStyles.kTextFourteenW400.copyWith(
                                  color: isDarkMode
                                      ? colors.kColorWhite
                                      : colors.kColorBlack),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Sizer.vertical24(),
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
                              color: isDarkMode
                                  ? colors.kColorWhite
                                  : colors.kColorBlack),
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
                              color: isDarkMode
                                  ? colors.kColorWhite
                                  : colors.kColorBlack),
                        ),
                        Sizer.halfHorizontal(),
                      ],
                    ),
                    Sizer.vertical48(),
                    CustomTextFormField(
                      fillcolor: true,
                      isAutofocus: true,
                      borderRadius: 6,
                      labelText: 'Mobile / Email OTP',
                      contentPadding: 14,
                      style: textStyles.kTextFourteenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorBlack),
                      hintStyle: textStyles.kTextFourteenW400.copyWith(
                          color: isDarkMode
                              ? colors.kColorWhite70
                              : colors.kColorGreyText),
                      maxCount: 6,
                      hintText: '******',
                      controller: loginProv.otpController,
                      errorText: loginProv.otpError,
                      sumitField: (value) {
                        if (value.length == 6) {
                          ref
                              .read(loginProvider)
                              .submitForgotPasswordVerifyOtp(context);
                        }
                      },
                      onChanged: (value) {
                        if (value.toString().trim().length == 6) {
                          ref
                              .read(loginProvider)
                              .submitForgotPasswordVerifyOtp(context);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              if (secondsRemaining == 0) {
                                resendCode();
                              }
                            },
                            style: TextButton.styleFrom(),
                            child: secondsRemaining != 0
                                ? Text(
                                    secondsRemaining < 10
                                        ? 'Resend OTP in  0:0$secondsRemaining'
                                        : 'Resend OTP in  0:$secondsRemaining',
                                    style:
                                        textStyles.kTextFourteenW400.copyWith(
                                      color: colors.kColorBlue,
                                    ),
                                  )
                                : Text(
                                    'Resend OTP',
                                    style:
                                        textStyles.kTextFourteenW400.copyWith(
                                      color: colors.kColorBlue,
                                    ),
                                  )),
                      ],
                    ),
                    Sizer.vertical24(),
                    Row(children: [
                      Expanded(
                        child: CustomLongButton(
                            borderRadius: 8,
                            color: isDarkMode
                                ? colors.kColorBlue
                                : colors.kColorBlue,
                            label: 'Validate OTP',
                            labelStyle: textStyles.kTextFourteenW400.copyWith(
                              color: isDarkMode
                                  ? colors.kColorWhite
                                  : colors.kColorWhite,
                            ),
                            onPress: () {
                              ref
                                  .read(loginProvider)
                                  .submitForgotPasswordVerifyOtp(context);
                            }),
                      ),
                    ])
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
