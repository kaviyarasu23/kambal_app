import 'package:flutter/material.dart';

class AppSizes {
  late Size _screenSize;

  late bool isPhone;
  late double width;
  late double height;
  late double blockSizeHorizontal;
  late double blockSizeVertical;

  late double topPadding;
  
  // For dynamic Sizing
  late double widthRatio;
  late double heightRatio;
  late double fontRatio;

  // Dynamic Font Sizes
  
  late double text_6;
  late double text_7;
  late double text_8;
  late double text_9;
  late double text_10;
  late double text_11;
  late double text_12;
  late double text_13;
  late double text_14;
  late double text_16;
  late double text_18;
  late double text_20;
  late double text_24;
  late double text_32;


  // Dynamic Padding

  late double pad_4;
  late double pad_6;
  late double pad_8;
  late double pad_10;
  late double pad_12;
  late double pad_14;
  late double pad_16;
  late double pad_20;
  late double pad_24;
  late double pad_32;
  late double pad_40;
  late double pad_48;
  late double pad_56;
  late double pad_76;
  late double pad_99;
  late double pad_144;
  late double pad_172;
  late double pad_192;
  late double pad_228;

  void initializeSize(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    topPadding = MediaQuery.of(context).padding.top;
    width = _screenSize.shortestSide;
    height = _screenSize.longestSide;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    isPhone = _screenSize.shortestSide < 600;
    fontRatio =
        (isPhone && _screenSize.width <= 360) ? _screenSize.width / 360 : 1.0;
    widthRatio = isPhone ? _screenSize.width / 360 : _screenSize.width / 900;
    heightRatio =
        isPhone ? _screenSize.height / 720 : _screenSize.height / 1200;


    text_6 = 6 * fontRatio;
    text_7 = 7 * fontRatio;
    text_8 = 8 * fontRatio;
    text_9 = 9 * fontRatio;
    text_10 = 10 * fontRatio;
    text_11 = 11 * fontRatio;
    text_12 = 12 * fontRatio;
    text_13 = 13 * fontRatio;
    text_14 = 14 * fontRatio;
    text_16 = 16 * fontRatio;
    text_18 = 18 * fontRatio;
    text_20 = 20 * fontRatio;
    text_24 = 24 * fontRatio;
    text_32 = 32 * fontRatio;

    pad_4 = 4 * widthRatio;
    pad_6 = 6 * widthRatio;
    pad_8 = 8 * widthRatio;
    pad_10 = 10 * widthRatio;
    pad_12 = 12 * widthRatio;
    pad_14 = 14 * widthRatio;
    pad_16 = 16 * widthRatio;
    pad_20 = 20 * widthRatio;
    pad_24 = 24 * widthRatio;
    pad_32 = 32 * widthRatio;
    pad_40 = 40 * widthRatio;
    pad_48 = 48 * widthRatio;
    pad_56 = 56 * widthRatio;
    pad_76 = 76 * widthRatio;
    pad_99 = 99 * widthRatio;
    pad_144 = 144 * widthRatio;
    pad_172 = 172 * widthRatio;
    pad_192 = 192 * widthRatio;
    pad_228 = 228 * widthRatio;
  }


  void refreshSize(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    width = _screenSize.width;
    height = _screenSize.height;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
  }

}