import 'package:aliceblue/provider/login_provider.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../provider/theme_provider.dart';
import '../../../res/res.dart';
import '../../../shared_widget/custom_long_button.dart';
import '../../../shared_widget/custom_text_form_field.dart';
import '../../../util/sizer.dart';

class UnblockUser extends ConsumerStatefulWidget {
  const UnblockUser({Key? key}) : super(key: key);

  @override
  UnblockUserState createState() => UnblockUserState();
}

class UnblockUserState extends ConsumerState<UnblockUser>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(loginProvider).setUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProv = ref.watch(loginProvider);
    final theme = ref.watch(themeProvider).isDarkMode;
    return WillPopScope(
        onWillPop: () async {
          ref.read(loginProvider).clearController();
          ref.read(loginProvider).clearError();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              'Unblock User',
              style: textStyles.kTextSixteenW400.copyWith(
                color: theme ? colors.kColorWhite : colors.kColorBlack,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_20),
              child: Column(children: [
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Sizer.vertical48(),
                          SvgPicture.asset(assets.unblockIcon,
                              height: 130, width: 134),
                          Sizer.vertical42(),
                          CustomTextFormField(
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[A-Za-z0-9]")),
                            ],
                            maxCount: 12,
                            labelText: 'User ID',
                            isAutofocus: checkIsInfOrNullOrNan(
                                value: loginProv.pref.userId),
                            sumitField: (value) {
                              if (loginProv.userIdController.text.isNotEmpty &&
                                  loginProv.panController.text.isNotEmpty) {
                                ref.read(loginProvider).submitUnblockUser(
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
                                ref.read(loginProvider).submitUnblockUser(
                                      context: context,
                                      isResend: false,
                                    );
                              }
                            },
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z0-9]")),
                            ],
                          ),
                          Sizer.vertical32(),
                          CustomLongButton(
                              loading: loginProv.loading,
                              label: "Unblock User",
                              borderRadius: 8,
                              color: colors.kColorBlue,
                              onPress: () =>
                                  ref.read(loginProvider).submitUnblockUser(
                                        context: context,
                                        isResend: false,
                                      )),
                          // Sizer.vertical80(),
                          // const Footer(
                          //   isAliveDivider: true,
                          // ),
                        ],
                      ),
                    ]),
              ]),
            ),
          ),
        ));
  }
}
