import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/login_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../router/route_names.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class TOTPScreen extends ConsumerStatefulWidget {
  const TOTPScreen({super.key});

  @override
  ConsumerState<TOTPScreen> createState() => _TOTPScreenState();
}

class _TOTPScreenState extends ConsumerState<TOTPScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final loginProv = ref.watch(loginProvider);
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
        padding: EdgeInsets.all(sizes.pad_16),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              Sizer.vertical32(),
              CustomTextFormField(
                inputType: TextInputType.number,
                borderRadius: 6,
                maxCount: 6,
                isAutofocus: true,
                style: textStyles.kTextFourteenW400.copyWith(
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                hintStyle: textStyles.kTextFourteenW400.copyWith(
                    color: isDarkMode
                        ? colors.kColorWhite
                        : colors.kColorGreyText),
                labelText: "TOTP",
                hintText: '******',
                errorText: loginProv.totpError,
                controller: loginProv.otpController,
                onChanged: (value) {
                  if (value.toString().trim().length == 6) {
                    ref.read(loginProvider).verifyTotp(context);
                  }
                },
                sumitField: (value) {
                  if (value.toString().trim().length == 6) {
                    ref.read(loginProvider).verifyTotp(context);
                  }
                },
              ),
              Sizer.vertical16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.confirmOTPScreen);
                    },
                    child: Text(
                      ('resetTotp').tr(),
                      style: textStyles.kTextFourteenW400
                          .copyWith(color: colors.kColorBlue),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref
                          .read(loginProvider)
                          .sendOtp(context: context, isResend: false);
                    },
                    child: Text(
                      ('loginWithOTP').tr(),
                      style: textStyles.kTextFourteenW400
                          .copyWith(color: colors.kColorBlue),
                    ),
                  )
                ],
              ),
              Sizer.vertical24(),
              Row(children: [
                Expanded(
                  child: CustomLongButton(
                      borderRadius: 6,
                      color: isDarkMode ? colors.kColorBlue : colors.kColorBlue,
                      label: ('proceed').tr(),
                      loading: loginProv.loading,
                      labelStyle: textStyles.kTextFourteenW400.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorWhite,
                      ),
                      onPress: () {
                        ref.read(loginProvider).verifyTotp(context);
                      }),
                ),
              ])
            ],
          ),
        ),
      ),
    )));
  }
}
