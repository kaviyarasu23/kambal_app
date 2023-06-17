import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF181818),
    unselectedWidgetColor: Colors.grey,
    primaryColor: Colors.black,
    primarySwatch: Colors.blue,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    canvasColor: Colors.transparent,
    colorScheme: const ColorScheme.dark()
        .copyWith(primary: Colors.blue, secondary: Colors.lightGreen),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF181818),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(0XFF212026)),
    iconTheme: const IconThemeData(color: Colors.white),
    dialogTheme: const DialogTheme(backgroundColor: Color(0xFF181818)),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    primarySwatch: Colors.blue,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    canvasColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black)),
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.blue,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    iconTheme: const IconThemeData(color: Colors.black),
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      refreshBackgroundColor: Colors.white,
    ),
  );
}
