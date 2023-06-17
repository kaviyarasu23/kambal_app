import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/login_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
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
      ref.read(loginProvider).sendOtp(context: context, isResend: true);
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
                  inputType: TextInputType.number,
                  borderRadius: 6,
                  maxCount: 6,
                  isAutofocus: true,
                  labelText: "Mobile OTP",
                  style: textStyles.kTextFourteenW400.copyWith(
                      color:
                          isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                  hintStyle: textStyles.kTextFourteenW400.copyWith(
                      color: isDarkMode
                          ? colors.kColorWhite
                          : colors.kColorGreyText),
                  hintText: '******',
                  errorText: loginProv.otpError,
                  controller: loginProv.otpController,
                  onChanged: (value) {
                    if (value.toString().length == 6) {
                      ref.read(loginProvider).submitOtp(context: context);
                    }
                  },
                  sumitField: (value) {
                    if (value.toString().length == 6) {
                      ref.read(loginProvider).submitOtp(context: context);
                    }
                  },
                ),
                Sizer.vertical10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (secondsRemaining == 0) {
                          resendCode();
                        }
                      },
                      child: Text(
                        secondsRemaining != 0
                            ? secondsRemaining < 10
                                ? '${('resendOTP').tr()} in 0:0$secondsRemaining'
                                : '${('resendOTP').tr()} in 0:$secondsRemaining'
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
                          color: isDarkMode
                              ? colors.kColorWhite
                              : colors.kColorBlack,
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
                            ref.read(loginProvider).submitOtp(context: context);
                          }),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
