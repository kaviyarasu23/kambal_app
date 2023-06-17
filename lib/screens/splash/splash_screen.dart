import 'package:aliceblue/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../provider/theme_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(splashProvider).initialize(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashProvide = ref.watch(splashProvider);
    final isDarkMode = ref.read(themeProvider).isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(),
                    Image.asset(
                      "assets/images/app_logo.png",
                      height: 100,
                      width: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        splashProvide.loading
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: const LinearProgressIndicator(
                                  semanticsLabel: 'Loading',
                                  backgroundColor: Colors.grey,
                                ))
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Powered by ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SvgPicture.asset(
                    "assets/images/codifi_logo.svg",
                    height: 100,
                    width: 100,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            ],
          ),
        ),
      ),
    );
  }
}
