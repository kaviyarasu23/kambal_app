import 'dart:io';

import 'package:aliceblue/provider/login_provider.dart';
import 'package:aliceblue/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../res/res.dart';
import '../../../router/route_names.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class UserIdScreen extends ConsumerStatefulWidget {
  const UserIdScreen({super.key});

  @override
  ConsumerState<UserIdScreen> createState() => _UserIdScreenState();
}

class _UserIdScreenState extends ConsumerState<UserIdScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final loginProv = ref.watch(loginProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(
              sizes.pad_16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: textStyles.kTextTwentyFourW500.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorBlack),
                  ),
                  Sizer.half(),
                  Text(
                    'Welcome to Aliceblue',
                    style: textStyles.kTextTwelveW500.copyWith(
                        color: isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorBlack),
                  ),
                  Sizer.vertical24(),
                  CustomTextFormField(
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9]")),
                    ],
                    maxCount: 12,
                    labelText: 'User ID',
                    isAutofocus: true,
                    sumitField: (value) {
                      ref.read(loginProvider).validateUser(context: context);
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
                  Sizer.vertical10(),
                  InkWell(
                    onTap: () {
                      ref.read(loginProvider).clearError();
                      ref.read(loginProvider).clearController();
                      Navigator.pushNamed(
                        context,
                        Routes.unblockUser,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: sizes.pad_6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Unblock Account',
                            style: textStyles.kTextTwelveW400.copyWith(
                              color: colors.kColorBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Sizer.vertical32(),
                  CustomLongButton(
                      loading: loginProv.loading,
                      borderRadius: 4,
                      label: "Login",
                      color: colors.kColorBlue,
                      onPress: () {
                        ref.read(loginProvider).validateUser(
                              context: context,
                            );
                      }),
                  Sizer.vertical24(),
                  if (Platform.isAndroid)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New to Aliceblue?',
                          style: textStyles.kTextFourteenW400.copyWith(
                            color: isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorBlack,
                          )),
                      CustomTextButton(
                          text: "Join Now",
                          textStyle: textStyles.kTextFourteenW400.copyWith(
                            color: colors.kColorBlue,
                          ),
                          onPress: () {
                            launch("https://leads.aliceblueonline.com/JOINUS/");
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
