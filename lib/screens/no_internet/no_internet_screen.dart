import 'package:aliceblue/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoInternetAlert extends ConsumerStatefulWidget {
  const NoInternetAlert({Key? key}) : super(key: key);

  @override
  ConsumerState<NoInternetAlert> createState() => _NoInternetAlertState();
}

class _NoInternetAlertState extends ConsumerState<NoInternetAlert> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_outlined,
            size: 32,
            color: Colors.red,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'No Internet connection found.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 8,),
          const Text(
            'Check your connection and try again',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                label: 'Try again',
                color: Colors.red,
                borderRadius: 50,
                width: 150,
                onPress: () {
                  ref.read(splashProvider).initialize(
                        context: context,
                        isRetry: true,
                      );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}


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
                    visible: prefixIcon != null, child: const SizedBox(width: 16,)),
                Text(
                  label,
                  style: textStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
    );
  }
}