import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aliceblue/provider/theme_provider.dart';

import '../res/res.dart';

class CustomTextFormField extends ConsumerWidget {
  final String? errorText;
  final String? labelText;
  final double? contentPadding;
  final double? contentPaddingVertical;
  final String? hintText;
  final bool? hideInput;
  final bool? enabled;
  final TextEditingController? controller;
  final List<TextInputFormatter>? textInputFormatter;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool? isAutofocus;
  final double? borderRadius;
  final String? initialValue;
  final bool? filled;
  final bool? fillcolor;
  final bool? isReadOnly;
  final Function()? onTab;
  final Function(String value)? sumitField;
  final int? maxCount;
  final int? minCount;
  final bool? isUpperCase;
  final TextInputType? inputType;
  final Widget? prefixText;
  final bool? isAliveBorder;
  final TextStyle? style;
  final bool? isBorder;
  final bool? isDarkMode;
  final EdgeInsets? scrollPadding;
  final Color? focusColor;
  final bool? orderwindowformfield;
  final FocusNode? focus;
  final Color? borderColor;
  final double? borderWidth;

  const CustomTextFormField({
    Key? key,
    this.onChanged,
    this.contentPadding,
    this.fillcolor = true,
    this.filled,
    this.maxCount,
    this.prefixText,
    this.hideInput,
    this.enabled,
    this.isUpperCase,
    this.errorText,
    this.isAutofocus,
    this.labelText,
    this.hintText,
    this.controller,
    this.textInputFormatter,
    this.hintStyle,
    this.labelStyle,
    this.prefix,
    this.inputType,
    this.style,
    this.minCount,
    this.onTab,
    this.isReadOnly,
    this.borderRadius,
    this.initialValue,
    this.isAliveBorder,
    this.isBorder,
    this.sumitField,
    this.isDarkMode,
    this.scrollPadding,
    this.suffix,
    this.focusColor,
    this.contentPaddingVertical,
    this.orderwindowformfield,
    this.focus,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    return TextFormField(
      style: style,
      enableSuggestions: false,
      autocorrect: false,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: sumitField,
      autofocus: isAutofocus ?? false,
      focusNode: focus,
      minLines: 1,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
      maxLines: hideInput ?? false ? 1 : 1,
      controller: controller,
      enabled: enabled,
      readOnly: isReadOnly ?? false,
      onTap: onTab,
      obscureText: hideInput ?? false,
      keyboardType: inputType,
      textCapitalization: isUpperCase ?? false
          ? TextCapitalization.characters
          : TextCapitalization.none,
      inputFormatters: textInputFormatter,
      initialValue: initialValue,
      maxLength: maxCount,
      onChanged: onChanged,
      decoration: isAliveBorder ?? true
          ? InputDecoration(
              fillColor: fillcolor == true
                  ? isDarkMode
                      ? colors.kColorBlack
                      : colors.kColorInputBg
                  : orderwindowformfield == true
                      ? colors.kColorWhite
                      : colors.kColorInputBg,
              filled: filled,
              contentPadding: contentPaddingVertical != null
                  ? EdgeInsets.symmetric(
                      horizontal: contentPadding ?? 14,
                      vertical: contentPaddingVertical!,
                    )
                  : contentPadding != null
                      ? EdgeInsets.symmetric(
                          horizontal: contentPadding!,
                          vertical: contentPaddingVertical ?? 14,
                        )
                      : null,
              border: isBorder ?? true
                  ? OutlineInputBorder(
                      borderSide: BorderSide(
                        width: borderWidth ?? 1,
                        color: borderColor ?? colors.kColorInputBg,
                      ),
                      borderRadius: BorderRadius.circular(borderRadius ?? 4),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 4),
                      borderSide: BorderSide.none,
                    ),
              enabledBorder: enabled ?? false
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 4),
                      borderSide: BorderSide(
                        width: borderWidth ?? 1,
                        color: borderColor ??
                            (isDarkMode
                                ? colors.kColorWhite
                                : colors.kColorSecondary),
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius ?? 4),
                      borderSide: BorderSide(
                        color: (isDarkMode
                            ? colors.kColorWhite
                            : colors.kColorSecondary),
                      ),
                    ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color: focusColor ?? colors.kColorBlue,
                ),
              ),
              labelText: labelText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              prefix: prefixText,
              counterText: '',
              isDense: true,
              hintText: hintText,
              errorText: errorText,
              errorMaxLines: 2,
              labelStyle: labelStyle ??
                  textStyles.kTextTwelveW400
                      .copyWith(color: colors.kColorGreyText),
              hintStyle: hintStyle ??
                  textStyles.kTextTwelveW400
                      .copyWith(color: colors.kColorGreyText),
            )
          : InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor ?? colors.kColorBlue,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor ?? colors.kColorBlue,
                ),
              ),
            ),
    );
  }
}
