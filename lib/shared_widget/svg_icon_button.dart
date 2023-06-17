import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../res/res.dart';

class SvgIconButton extends StatelessWidget {
  final Function onPress;
  final String assetLink;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final bool? loading;
  final Color? color;

  const SvgIconButton(
      {Key? key,
      required this.onPress,
      required this.assetLink,
      this.height,
      this.color,
      this.width,
      this.padding,
      this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading == true ? () {} : () => onPress(),
      child: Padding(
        padding: padding ?? EdgeInsets.all(sizes.pad_12),
        child: loading == true
            ? SizedBox(
                height: height ?? 10,
                width: width ?? 16,
                child: const Center(child: CircularProgressIndicator()),
              )
            : SvgPicture.asset(
                assetLink,
                height: height ?? 16,
                width: width ?? 16,
                color: color ?? colors.kColorLabelColor,
              ),
      ),
    );
  }
}
