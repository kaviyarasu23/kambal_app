import 'package:aliceblue/res/res.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final TextStyle? textStyle;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onPress(),
        child: Padding(
          padding: EdgeInsets.all(sizes.pad_8),
          child: Text(
            text,
            style: textStyle ??
                textStyles.kTextFourteenW400.copyWith(color: colors.kColorBlue),
          ),
        ));
  }
}
