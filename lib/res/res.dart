import 'package:flutter/material.dart';

import 'app_sizes.dart';
import 'assets.dart';
import 'colors.dart';
import 'text_styles.dart';

late Assets assets;
late AppColors colors;
late AppSizes sizes;
late AppTextStyles textStyles;


void initializeResources({required BuildContext context}) {
  sizes = AppSizes()..initializeSize(context);
  colors = AppColors();
  assets = Assets();
  textStyles = AppTextStyles();
}