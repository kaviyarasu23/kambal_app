import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../provider/theme_provider.dart';
import '../res/res.dart';
import '../util/sizer.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPress;
  final Color color;
  final double? width;
  final double? height;
  final bool? loading;
  final TextStyle? textStyle;
  final Icon? prefixIcon;
  final double? borderRadius;

  const CustomButton(
      {Key? key,
      this.loading,
      required this.color,
      required this.label,
      required this.onPress,
      this.prefixIcon,
      this.borderRadius,
      this.textStyle,
      this.height,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading == true ? () {} : () => onPress(),
      style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 5)),
          fixedSize: Size(width ?? 50, height ?? 5)),
      child: loading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Visibility(visible: prefixIcon != null, child: prefixIcon!),
                Visibility(
                    visible: prefixIcon != null, child: Sizer.halfHorizontal()),
                Text(
                  label,
                  style: textStyle ??
                      TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
    );
  }
}

class CustomOutlineButton extends ConsumerWidget {
  final String label;
  final Function onPress;
  final Color color;
  final double? width;
  final double? height;
  final bool? loading;
  final bool? isSelected;
  final Color? textColor;
  final double? borderRadius;
  final SvgPicture? icon;
  const CustomOutlineButton(
      {Key? key,
      required this.color,
      this.height,
      required this.label,
      required this.onPress,
      this.width,
      this.loading,
      this.isSelected,
      this.borderRadius,
      this.textColor,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    final BoxDecoration decoration = BoxDecoration(
        color: isSelected ?? false ? color : Colors.transparent,
        border: Border.all(
            color: isSelected ?? false
                ? color
                : isDarkMode
                    ? colors.kColorGreyText
                    : colors.kColorBlack),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 4)));
    final selectedTextStyle =
        textStyles.kTextTwelveW400.copyWith(color: textColor ?? colors.kColorWhite);
    return InkWell(
      onTap: loading == true ? () {} : () => onPress(),
      child: Container(
        height: height ?? 48,
        // width: width,
        decoration: decoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizes.pad_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: isSelected ?? false
                    ? selectedTextStyle
                    : textStyles.kTextTwelveW400.copyWith(
                        color: ref.read(themeProvider).isDarkMode
                            ? colors.kColorGreyText
                            : colors.kColorBlack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
