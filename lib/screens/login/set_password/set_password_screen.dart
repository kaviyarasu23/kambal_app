import 'package:aliceblue/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/login_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../shared_widget/svg_icon_button.dart';
import '../../../util/sizer.dart';

class SetPasswordScreen extends ConsumerStatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  ConsumerState<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends ConsumerState<SetPasswordScreen> {
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
              Sizer.vertical48(),
              CustomTextFormField(
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r"^[ ]"),
                  ),
                ],
                labelText: 'New Password',
                borderRadius: 6,
                maxCount: 16,
                isAutofocus: true,
                style: textStyles.kTextFourteenW400.copyWith(
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                hintStyle: textStyles.kTextFourteenW400.copyWith(
                    color: isDarkMode
                        ? colors.kColorWhite
                        : colors.kColorGreyText),
                suffix: SvgIconButton(
                    assetLink: loginProv.hideNewPassword
                        ? assets.closedeye
                        : assets.openeye,
                    onPress: () => loginProv.toggleHideNewPassword(),
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                hideInput: loginProv.hidePassword,
                hintText: "New Password",
                errorText: loginProv.newPasswordError,
                controller: loginProv.newPasswordController,
                sumitField: (value) {
                  if (loginProv.newPasswordController.text.toString().length >
                          1 &&
                      loginProv.passwordController.text.toString().length > 1) {
                    ref.read(loginProvider).submitResetPass(
                          context: context,
                        );
                  }
                },
                onChanged: (value) {
                  if (loginProv.passwordError != null) {
                    ref.read(loginProvider).clearError();
                  }
                },
              ),
              Sizer.vertical24(),
              CustomTextFormField(
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r"^[ ]"),
                  ),
                ],
                labelText: 'Confirm Password',
                borderRadius: 6,
                maxCount: 16,
                isAutofocus: true,
                style: textStyles.kTextFourteenW400.copyWith(
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                hintStyle: textStyles.kTextFourteenW400.copyWith(
                    color: isDarkMode
                        ? colors.kColorWhite
                        : colors.kColorGreyText),
                suffix: SvgIconButton(
                    assetLink: loginProv.hideNewPassword
                        ? assets.closedeye
                        : assets.openeye,
                    onPress: () => loginProv.toggleHideNewPassword(),
                    color:
                        isDarkMode ? colors.kColorWhite : colors.kColorBlack),
                hideInput: loginProv.hidePassword,
                hintText: "Confirm Password",
                errorText: loginProv.passwordError,
                controller: loginProv.passwordController,
                sumitField: (value) {
                  if (loginProv.newPasswordController.text.toString().length >
                          1 &&
                      loginProv.passwordController.text.toString().length > 1) {
                    ref.read(loginProvider).submitResetPass(
                          context: context,
                        );
                  }
                },
                onChanged: (value) {
                  if (loginProv.passwordError != null) {
                    ref.read(loginProvider).clearError();
                  }
                },
              ),
              InkWell(
                onTap: () {
                  ref.read(userProvider).switchAccount(context: context);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: sizes.pad_16,
                      ),
                      child: Text(
                        "Switch Account",
                        style: textStyles.kTextTwelveW400
                            .copyWith(color: colors.kColorBlue),
                      ),
                    ),
                  ],
                ),
              ),
              Sizer.vertical42(),
              Row(
                children: [
                  Expanded(
                    child: CustomLongButton(
                        borderRadius: 8,
                        color:
                            isDarkMode ? colors.kColorBlue : colors.kColorBlue,
                        label: 'Proceed',
                        loading: loginProv.loading,
                        labelStyle: textStyles.kTextFourteenW400.copyWith(
                          color: colors.kColorWhite,
                        ),
                        onPress: () {
                          ref.read(loginProvider).submitResetPass(
                                context: context,
                              );
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ))),
    );
  }
}
