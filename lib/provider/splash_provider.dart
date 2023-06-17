import 'dart:developer';
import 'dart:io';

import 'package:aliceblue/provider/network_provider.dart';
import 'package:aliceblue/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../api/core/api_links.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/version_check_model.dart';
import '../res/res.dart';
import '../router/route_names.dart';
import '../screens/no_internet/no_internet_screen.dart';
import '../screens/update_app/update_app_pop_screen.dart';
import '../shared_widget/snack_bar.dart';
import 'core/default_change_notifier.dart';
import 'login_provider.dart';

final splashProvider = ChangeNotifierProvider((ref) => SplashProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class SplashProvider extends DefaultChangeNotifier {
  SplashProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  VersionCheckInfo? versionCheckInfo;
  VersionCheckInfo? get versionInfo => versionCheckInfo;

  /// Method to initial Resource and Basic Function Enable
  ///
  ///

  Future<void> initialize({
    required BuildContext context,
    bool? isRetry = false,
  }) async {
    try {
      toggleLoadingOn(true);
      if (ref.read(networkStateProvider).checkInitialCheck()) {
        log("Internet Connection available");
        initializeResources(context: context);
        final res = await getAppVersionUpdateCheck(context);
        if (res != null) {
          if (res.status! && res.result != null && res.result!.isNotEmpty) {
            if (res.result![0].isUpdateAvailable != "0") {
              // ignore: use_build_context_synchronously
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: const Text('ALERT!'),
                        content: UpdateAlertDialogBody(
                          updateMessage:
                              'Please update your app to latest version. Current version is no longer valid',
                          isUpdateAvailable:
                              res.result![0].isUpdateAvailable != "0",
                        ),
                      ));
            } else if (!checkIsInfOrNullOrNan(value: pref.userId)) {
              if (!checkIsInfOrNullOrNan(value: pref.userPassword)) {
              } else if (!checkIsInfOrNullOrNan(value: pref.sessionId)) {
                ref.read(loginProvider).biometricLogin(
                      context: context,
                      isFrom: '',
                    );
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.password, (route) => false);
              }
            } else {
              if (pref.isShowWelcomeUser) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.onboard, (route) => false);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.userId, (route) => false);
              }
            }
          }
        }
      } else {
        if (isRetry! == false) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar("No Internet"));
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    content: const NoInternetAlert(),
                  ));
        }
      }
    } catch (e) {
      log("Initial Setup Error :: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  Future<VersionCheckInfo?> getAppVersionUpdateCheck(
      BuildContext context) async {
    try {
      toggleLoadingOn(true);
      VersionCheckInput versionCheckInput = VersionCheckInput(
        version: ApiLinks.version,
        os: Platform.isAndroid ? 'ANDROID' : 'IOS',
      );
      log(versionCheckInput.toJson().toString());
      versionCheckInfo = await api.getAppVersionCheck(
          input: versionCheckInput, context: context, ref: ref);
      notifyListeners();
      return versionCheckInfo;
    } catch (e) {
      log("Failed to get version service ::: $e");
      rethrow;
    }
  }
}
