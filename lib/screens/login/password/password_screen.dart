import 'package:aliceblue/provider/login_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/user_provider.dart';
import '../../../res/res.dart';
import '../../../router/route_names.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/svg_icon_button.dart';
import '../../../util/sizer.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final loginProv = ref.watch(loginProvider);
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            sizes.pad_16,
          ),
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
              textInputFormatter: [
                FilteringTextInputFormatter.deny(
                  RegExp(r"^[ ]"),
                ),
              ],
              labelText: 'Password',
              borderRadius: 6,
              maxCount: 16,
              isAutofocus: true,
              style: textStyles.kTextFourteenW400.copyWith(
                  color: isDarkMode ? colors.kColorWhite : colors.kColorBlack),
              hintStyle: textStyles.kTextFourteenW400.copyWith(
                  color:
                      isDarkMode ? colors.kColorWhite : colors.kColorGreyText),
              suffix: SvgIconButton(
                  assetLink: loginProv.hidePassword
                      ? assets.closedeye
                      : assets.openeye,
                  onPress: () => loginProv.toggleHidePassword(),
                  color: isDarkMode ? colors.kColorWhite : colors.kColorBlack),
              hideInput: loginProv.hidePassword,
              hintText: ('enterPassword').tr(),
              errorText: loginProv.passwordError,
              controller: loginProv.passwordController,
              sumitField: (value) {
                if (value.toString().length > 1) {
                  ref.read(loginProvider).validatePassword(context: context);
                }
              },
              onChanged: (value) {
                if (loginProv.passwordError != null) {
                  ref.read(loginProvider).clearError();
                }
              },
            ),
            Sizer.half(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(userProvider).switchAccount(context: context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: sizes.pad_8),
                      child: Text(
                        ("switchAccount").tr(),
                        style: textStyles.kTextTwelveW400.copyWith(
                          color: colors.kColorBlue,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ref.read(loginProvider).clearController();
                      ref.read(loginProvider).clearError();
                      Navigator.pushNamed(context, Routes.forgotPassword);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: sizes.pad_8),
                      child: Text(
                        ("forgotPassword").tr(),
                        style: textStyles.kTextTwelveW400.copyWith(
                          color: colors.kColorBlue,
                        ),
                      ),
                    ),
                  ),
                ]),
                Sizer.vertical32(),
            Row(
              children: [
                Expanded(
                  // child: IgnorePointer(
                  //   ignoring: !mobileProvide.isShowNextBtn ||
                  //       mobileProvide.passwordController.text.isEmpty,
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
                        ref.read(loginProvider).validatePassword(
                              context: context,
                            );
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
