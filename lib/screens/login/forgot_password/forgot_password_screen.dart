import 'package:aliceblue/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/functions.dart';
import '../../../util/sizer.dart';
import 'widgets/password_policy.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(loginProvider).setUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final loginProv = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Forgot Password',
          style: textStyles.kTextSixteenW400.copyWith(
            color: isDarkMode ? colors.kColorWhite : colors.kColorBlack,
          ),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(sizes.pad_16),
            child: Column(
              children: [
                SvgPicture.asset(assets.forgotUserIdIcon,
                    height: 83, width: 95),
                Sizer.vertical48(),
                CustomTextFormField(
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9]")),
                  ],
                  maxCount: 12,
                  labelText: 'User ID',
                  isAutofocus: checkIsInfOrNullOrNan(
                                value: loginProv.pref.userId),
                  sumitField: (value) {
                    if (loginProv.userIdController.text.isNotEmpty &&
                        loginProv.panController.text.isNotEmpty) {
                      ref.read(loginProvider).submitForgotPassword(
                            context: context,
                            isResend: false,
                          );
                    }
                  },
                  labelStyle: textStyles.kTextSixteenW400
                      .copyWith(color: colors.kColorLabelColor),
                  controller: loginProv.userIdController,
                  errorText: loginProv.userIdError,
                  isUpperCase: true,
                  onChanged: (value) {
                    if (loginProv.userIdError != null) {
                      ref.read(loginProvider).clearError();
                    }
                  },
                ),
                Sizer.vertical24(),
                CustomTextFormField(
                  labelText: "PAN Number",
                  borderRadius: 8,
                  maxCount: 10,
                  labelStyle: textStyles.kLabelStyle,
                  controller: loginProv.panController,
                  errorText: loginProv.panError,
                  isAutofocus: !checkIsInfOrNullOrNan(
                                value: loginProv.pref.userId),
                  isUpperCase: true,
                  sumitField: (value) {
                    if (loginProv.userIdController.text.isNotEmpty &&
                        loginProv.panController.text.isNotEmpty) {
                      ref.read(loginProvider).submitForgotPassword(
                            context: context,
                            isResend: false,
                          );
                    }
                  },
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                  ],
                ),
                Sizer.vertical32(),
                CustomLongButton(
                    loading: loginProv.loading,
                    label: "Reset Password",
                    borderRadius: 4,
                    color: colors.kColorBlue,
                    onPress: () => ref.read(loginProvider).submitForgotPassword(
                          context: context,
                          isResend: false,
                        )),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          builder: (_) => const PasswordPolicy(),
                        );
                      },
                      style: TextButton.styleFrom(),
                      child: Text(
                        "Password Policy",
                        style: textStyles.kTextFourteenW400.copyWith(
                          color: colors.kColorBlue,
                        ),
                      )),
                ]),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
