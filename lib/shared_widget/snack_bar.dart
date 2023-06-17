import 'package:flutter/material.dart';
import 'package:aliceblue/res/res.dart';

SnackBar errorSnackBar(String error, {Duration? time}) => SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
SnackBar successSnackbar(String text, {Duration? time}) => SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
      backgroundColor: colors.kColorGreen,
    );

Divider horizontalDividerLine(bool isDarkMode,
        {double? height, double? thickness}) =>
    Divider(
      color: isDarkMode ? colors.kColorProfileName : colors.kColorDividerLine,
      height: height ?? 1,
      thickness: thickness ?? 1,
    );

VerticalDivider verticalDividerLine(bool isDarkMode) => VerticalDivider(
      color: isDarkMode ? colors.kColorProfileName : colors.kColorDividerLine,
      width: 1,
      thickness: 1,
    );
