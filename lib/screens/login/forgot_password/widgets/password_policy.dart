import 'package:aliceblue/res/res.dart';
import 'package:aliceblue/util/sizer.dart';
import 'package:flutter/material.dart';

class PasswordPolicy extends StatelessWidget {
  const PasswordPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(sizes.pad_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Password Policy',
                  style:
                      textStyles.kTextFourteenW400.copyWith(color: colors.kColorBlue),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Sizer.vertical16(),
            Text(
              "a) Password should be alphanumeric and at least 6 characters and maximum 12 characters.",
              style: textStyles.kTextFourteenW400,
            ),
            Sizer.half(),
            Text(
              "b) Password should not be the same as your User/Login ID.",
              style: textStyles.kTextFourteenW400,
            ),
            Sizer.half(),
            Text(
              "c) For extra safety, it is recommended that you use a special character in the password.",
              style: textStyles.kTextFourteenW400,
            ),
            Sizer.half(),
            Text(
              "d) For security purposes, login password will expire every 14 days and will need to be reset by you.",
              style: textStyles.kTextFourteenW400,
            ),
            Sizer.half(),
          ],
        ));
  }
}
