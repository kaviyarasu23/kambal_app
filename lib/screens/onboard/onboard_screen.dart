import 'package:aliceblue/provider/splash_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/theme_provider.dart';
import '../../res/res.dart';
import '../../router/route_names.dart';
import '../../shared_widget/custom_long_button.dart';
import '../../util/sizer.dart';

class OnBoardScreen extends ConsumerStatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  OnBoardScreenState createState() => OnBoardScreenState();
}

class OnBoardScreenState extends ConsumerState<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_40,),
              child: CustomLongButton(
                  borderRadius: 8,
                  color: isDarkMode ? colors.kColorBlue : colors.kColorBlue,
                  label: ('getStart').tr(),
                  labelStyle: textStyles.kTextFourteenW400.copyWith(
                    color: isDarkMode ? colors.kColorWhite : colors.kColorWhite,
                  ),
                  onPress: () {
                    ref
                        .read(splashProvider)
                        .pref
                        .setWelcomeUserType(isWelcome: false);
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.userId, (route) => false);
                  }),
            ),
          ),
        ]),
      ),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: sizes.pad_8),
          //   child: SvgPicture.asset(
          //     assets.helpIcon,
          //     height: 20,
          //     color: colors.kColorBlue,
          //   ),
          // )
        ],
        elevation: 0,
      ),
      body: Consumer(builder: (context, ref, child) {
        return SafeArea(
            child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizes.pad_40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Sizer.vertical96(),
                          Image.asset(
                            "assets/images/app_logo.png",
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            ('getStarted_welcome').tr(),
                            style: textStyles.kTextTwentyFourW700.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack),
                          ),
                          Sizer.vertical10(),
                          Text(
                            ('getStarted_description_first').tr(),
                            style: textStyles.kTextFourteenW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack80),
                          ),
                          Sizer.qtr(),
                          Text(
                            ('getStarted_description_second').tr(),
                            style: textStyles.kTextFourteenW400.copyWith(
                                color: isDarkMode
                                    ? colors.kColorWhite
                                    : colors.kColorBlack80),
                          ),
                        ],
                      ),
                    ),
                  ])),
        ));
      }),
    );
  }
}
