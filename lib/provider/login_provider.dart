import 'dart:convert';
import 'dart:developer';

import 'package:aliceblue/model/user_check_model.dart';
import 'package:aliceblue/provider/menu_provider.dart';
import 'package:aliceblue/provider/web_scoket_helper_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/forgot_password_model.dart';
import '../model/otp_model.dart';
import '../model/password_model.dart';
import '../model/set_password_model.dart';
import '../model/totp_login_model.dart';
import '../model/unblock_user_model.dart';
import '../router/route_names.dart';
import '../shared_widget/snack_bar.dart';
import '../util/functions.dart';
import 'core/default_change_notifier.dart';
import 'market_provider.dart';
import 'settings_provider.dart';
import 'user_provider.dart';

final loginProvider = ChangeNotifierProvider((ref) => TabControllerProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class TabControllerProvider extends DefaultChangeNotifier {
  TabControllerProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  // data for biometric avalable

  List<BiometricType> availableBiometrics = [];
  List<BiometricType> get availableBio => availableBiometrics;

  bool isBiometricSupported = false;
  bool get isBioAvailable => isBiometricSupported;

  bool isBioCheck = false;
  bool get isBioSupportCheck => isBioCheck;

  bool isFingerPrint = false;
  bool get isFinger => isFingerPrint;

  bool isBothFingerFace = false;
  bool get isBothBio => isBothFingerFace;

  // check user

  UserCheckInfo? userCheckInfo;
  UserCheckInfo? get userInfo => userCheckInfo;

  GetScannerOtp? getScannerOtp;
  GetScannerOtp? get getGenerateTotpOtp => getScannerOtp;
  String qrImage = "";
  String secKey = "";

  // Login Controller

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // Login error

  String? userIdError;
  String? passwordError;
  String? otpError;
  String? totpError;
  String? panError;
  String? newPasswordError;

  // Method to clear controller

  void clearController() {
    userIdController.text = "";
    passwordController.text = "";
    panController.text = "";
    otpController.text = "";
    newPasswordController.text = "";
  }

  // Method to clear error

  void clearError() {
    userIdError = null;
    passwordError = null;
    otpError = null;
    panError = null;
    newPasswordError = null;
  }

  /// toggle Eye

  bool hidePassword = true;
  bool hideNewPassword = true;

  /// UserId set to controller
  ///
  ///

  void setUserId() {
    userIdController.text = pref.userId ?? '';
    notifyListeners();
  }

  // Method to validate auth

  bool validate({required String authStep}) {
    clearError();
    switch (authStep) {
      case "userId":
        if (userIdController.text.isEmpty) {
          userIdError = ("userIdEmpty").tr();
        } else if (userIdController.text.trim().length >= 16) {
          userIdError = ("invalidUserId").tr();
        }
        break;
      case "password":
        if (passwordController.text.isEmpty) {
          passwordError = ("passwordEmpty").tr();
        } else if (passwordController.text.trim().length <= 3) {
          passwordError = ("invalidPassword").tr();
        }
        break;
      case "otp":
        if (otpController.text.isEmpty) {
          otpError = ("otpEmpty").tr();
        } else if (otpController.text.trim().length <= 5) {
          otpError = ("invalidOtp").tr();
        }
        break;
      case "totp":
        if (otpController.text.isEmpty) {
          totpError = ("totpEmpty").tr();
        } else if (otpController.text.trim().length <= 5) {
          totpError = ("invalidTOTP").tr();
        }
        break;
      case "unblock":
        if (userIdController.text.isEmpty) {
          userIdError = ("userIdEmpty").tr();
        } else if (userIdController.text.trim().length >= 16) {
          userIdError = ("invalidUserId").tr();
        }
        if (panController.text.isEmpty) {
          panError = ("panCardEmpty").tr();
        } else if (panController.text.trim().length != 10 ||
            isValidPanNumber(panNumber: panController.text.trim())) {
          panError = ("invalidPAN").tr();
        }
        break;
      case "forgotPassword":
        if (userIdController.text.isEmpty) {
          userIdError = ("userIdEmpty").tr();
        } else if (userIdController.text.trim().length >= 16) {
          userIdError = ("invalidUserId").tr();
        }
        if (panController.text.isEmpty) {
          panError = ("panCardEmpty").tr();
        } else if (panController.text.trim().length != 10 ||
            isValidPanNumber(panNumber: panController.text.trim())) {
          panError = ("invalidPAN").tr();
        }
        break;
      case "unblockotp":
        if (otpController.text.isEmpty) {
          otpError = ("otpEmpty").tr();
        } else if (otpController.text.trim().length <= 5) {
          otpError = ("invalidOtp").tr();
        }
        break;
      case "forgotPasswordotp":
        if (otpController.text.isEmpty) {
          otpError = ("otpEmpty").tr();
        } else if (otpController.text.trim().length <= 5) {
          otpError = ("invalidOtp").tr();
        }
        break;
      case "setPassword":
        if (passwordController.text.isEmpty) {
          passwordError = ("passwordEmpty").tr();
        } else if (passwordController.text.trim().length <= 3) {
          passwordError = ("invalidPassword").tr();
        }
        if (newPasswordController.text.isEmpty) {
          newPasswordError = ("passwordEmpty").tr();
        } else if (newPasswordController.text.trim().length <= 3) {
          newPasswordError = ("invalidPassword").tr();
        }
        break;
    }
    return userIdError == null &&
        passwordError == null &&
        otpError == null &&
        panError == null &&
        newPasswordError == null;
  }

  /// changing the eye icon
  ///
  ///
  ///

  void toggleHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  // changing the eye icon
  ///
  ///
  ///

  void toggleHideNewPassword() {
    hideNewPassword = !hideNewPassword;
    notifyListeners();
  }

  /// checking the biometric in mobile
  ///
  ///
  ///

  Future<void> isAvailableBio() async {
    availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
    notifyListeners();
    isBiometricSupported = await LocalAuthentication().isDeviceSupported();
    notifyListeners();

    isBioCheck = await LocalAuthentication().canCheckBiometrics;
    notifyListeners();
    log("BIO check CAN CHECK ::: $isBioCheck");
    log("BIO METRIC ::: $isBiometricSupported");
    for (var item in availableBiometrics) {
      if (item == BiometricType.fingerprint) {
        isFingerPrint = true;
      } else {
        isFingerPrint = false;
      }
      log("BIO METRIC ::: $item");
    }
    if (availableBiometrics.contains(BiometricType.fingerprint) &&
        availableBiometrics.contains(BiometricType.face) &&
        isBiometricSupported &&
        isBioCheck) {
      isBothFingerFace = true;
    } else {
      isBothFingerFace = false;
    }
    log("BIO METRIC ::: ${pref.isBioEnable!}");
    notifyListeners();
  }

  Future<bool> bioEnable({
    required BuildContext context,
    required bool isLogin,
    required String isFrom,
  }) async {
    try {
      toggleLoadingOn(true);
      availableBiometrics = [];
      availableBiometrics =
          await LocalAuthentication().getAvailableBiometrics();
      bool isBiometricSupported =
          await LocalAuthentication().isDeviceSupported();
      bool canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
      List<BiometricType> biometricTypes =
          await LocalAuthentication().getAvailableBiometrics();
      log("availableBiometrics BIO SUPPORT ::: $availableBiometrics");
      log("BIO SUPPORT isBiometricSupported ::: $isBiometricSupported");
      bool didAuthenticate = false;

      if (pref.isBioEnable! && !isLogin) {
        // pref.isBiometricEnabled(isBioEnable: false);
        // bioEnabled = pref.isBioEnable!;
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(successSnackbar('Bio metric removed successfully'));
        notifyListeners();
        return true;
      } else {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          didAuthenticate = await LocalAuthentication().authenticate(
            localizedReason: 'Please authenticate',
          );
          log("AUTH VALUE :::: ${availableBiometrics[0].index}");
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.

          didAuthenticate = await LocalAuthentication().authenticate(
            localizedReason: 'Please authenticate',
          );
          log("AUTH FINGERPRINT VALUE :::: ${availableBiometrics[0].name}");
        } else if (isBiometricSupported) {
          // Touch ID.
          didAuthenticate = await LocalAuthentication().authenticate(
            localizedReason: 'Please authenticate',
          );
        }
        log("is supported :::: $isBiometricSupported");
        log("is bio metric :::: $canCheckBiometrics");
        log("is Biometric :::: $biometricTypes");
        log("NO AUTH VALUE");
        if (didAuthenticate) {
          if (!isLogin) {
            pref.setBiometricEnableStatus(isBioEnable: true);
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(successSnackbar('Bio metric added successfully'));
          } else {
            biometricLogin(
              context: context,
              isFrom: isFrom,
            );
          }
          notifyListeners();
          return true;
        } else {
          try {
            toggleLoadingOn(false);
          } catch (e) {}
        }
      }
    } catch (e) {
      if (e.toString().contains(
          "The operation was canceled because the API is locked out due to too many attempts")) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar(
            'The operation was canceled because the API is locked out due to too many attempts please wait 30 seconds',
          ),
        );
      }

      if (e
          .toString()
          .contains("NotEnrolled, No biometrics enrolled on this device")) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar(
            'No biometrics enrolled on this device.',
          ),
        );
      }

      if (e
          .toString()
          .contains("NotAvailable, Required security features not enabled,")) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          errorSnackBar(
            'Required security features not enabled',
          ),
        );
      }
      toggleLoadingOn(false);
      log(e.toString());
    } finally {
      // try {
      //   toggleLoadingOn(false);
      // } catch (e) {}
    }
    return false;
  }

  /// login via biometric / direct Login
  ///
  ///
  ///

  Future<void> biometricLogin({
    required BuildContext context,
    required String isFrom,
  }) async {
    try {
      toggleLoadingOn(true);
      log("LOADING STATE ::: 2 $loading");

      final res = pref.isGuestUser
          ? "success"
          : await ref.read(settingsProvider).getProfileData(context: context);
      if (res?.toLowerCase() == 'success') {
        await ref.read(webscoketHelperProvider).invalidateWSSession(context: context);
        await ref.read(webscoketHelperProvider).createWSSession(context: context);
        await ref.read(marketProvider).getUserWatchlist(context: context);
        // await ref(dashboardProvider).getPrefrence(context, "");
        // pref.isBiometricEnabled(
        //   isBioEnable: true,
        // );

        Navigator.pushNamedAndRemoveUntil(
            context, Routes.menuScreen, (route) => false);
      } else if (res?.toLowerCase() == 'unauthourized') {
        ref.read(userProvider).sessionLogout(context: context);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar("${res}"));
      }
    } catch (e) {
      log("ERR BIO ::: $e");
      pref.setUserPassword(password: '');
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.password, (route) => false);
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {
        log("Bio Metric Login Error ::: $e");
      }
      notifyListeners();
      log("LOADING STATE ::: 2 $loading");
    }
  }

  /// Check User Id to If the User is TR / kambala
  ///
  ///

  void validateUser({required BuildContext context}) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: 'userId')) {
        pref.setUserId(
          userIdController.text.toUpperCase(),
        );
        log("USER ID ::: ${pref.userId}");
        final inputlogin = UserInfoInput(
          userId: userIdController.text,
        );
        userCheckInfo = await api.checkUser(
          input: inputlogin,
          context: context,
          ref: ref,
        );
        if (userCheckInfo != null) {
          clearController();
          clearError();
          if (userCheckInfo!.message!.toLowerCase() == "user blocked") {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).clearMaterialBanners();
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar("${userCheckInfo!.message}"));
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.unblockUser, (route) => false);
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.password, (route) => false);
          }
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.password, (route) => false);
        }
      } else {
        notifyListeners();
      }
    } catch (e) {
      log("Failed with verify Password ::: $e");
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Routes.verifyPassword, (route) => false);
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {
        log("Failed to get user info details :: $e");
      }
    }
  }

  /// Method to unblock user
  ///
  ///

  void submitUnblockUser({
    required BuildContext context,
    required bool isResend,
  }) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: "unblock")) {
        pref.setUserId(userIdController.text.toUpperCase());
        final input = UnblockUserInput(
          userId: userIdController.text,
          pan: panController.text,
        );
        final unblockUser = await api.unblockUser(
          input: input,
          context: context,
          ref: ref,
        );
        if (unblockUser != null) {
          if (!unblockUser.status!) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(unblockUser.message ?? ''));
          } else {
            clearController();
            clearError();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(successSnackbar(unblockUser.message ?? ''));
            if (!isResend) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.unblockUserOTP, (route) => false);
              FocusScope.of(context).unfocus();
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  /// Method to validate password
  ///
  ///

  Future<void> validatePassword({required BuildContext context}) async {
    try {
      if (!checkIsInfOrNullOrNan(value: pref.userId) &&
              (!checkIsInfOrNullOrNan(value: pref.userPassword)) ||
          validate(authStep: "password")) {
        toggleLoadingOn(true);
        final input = PasswordInput(
          source: "MOB",
          userId: !checkIsInfOrNullOrNan(value: pref.userId)
              ? pref.userId!.toUpperCase()
              : userIdController.text.toUpperCase(),
          password: !checkIsInfOrNullOrNan(value: pref.userPassword)
              ? pref.userPassword!
              : passwordController.text,
        );
        final validatePassRes = await api.validatePass(
          input: input,
          context: context,
          ref: ref,
        );
        if (validatePassRes != null) {
          clearController();
          clearError();
          if (validatePassRes.result != null &&
              validatePassRes.result!.isNotEmpty &&
              validatePassRes.result![0].kcRole != null &&
              validatePassRes.result![0].kcRole == "GUEST_USER") {
            pref.setUserType(isGuestUser: true);
            pref.setSessionId(validatePassRes.result![0].token!);
            // ignore: use_build_context_synchronously
            await ref
                .read(webscoketHelperProvider)
                .invalidateWSSession(context: context);
            // ignore: use_build_context_synchronously
            await ref
                .read(webscoketHelperProvider)
                .createWSSession(context: context);
            // await ref.read(marketProvider).getUserWatchlist(context: context);
            // await Navigator.pushNamedAndRemoveUntil(
            //     context, Routes.tabscreen, (route) => false);
          } else if (validatePassRes.result != null &&
              validatePassRes.result!.isNotEmpty &&
              validatePassRes.result![0].token != null &&
              validatePassRes.result![0].token!.isNotEmpty &&
              validatePassRes.result![0].token!.toLowerCase().toString() !=
                  "null") {
            pref.setUserType(isGuestUser: false);
            pref.setLocalSessionId(validatePassRes.result![0].token!);
            if (validatePassRes.result![0].totpAvailable!) {
              // ignore: use_build_context_synchronously
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.totpScreen, (route) => false);
            } else {
              // ignore: use_build_context_synchronously
              sendOtp(context: context, isResend: false);
            }
          } else {
            pref.setUserType(isGuestUser: false);
            if (validatePassRes.message!.isNotEmpty &&
                validatePassRes.message!.toLowerCase() == "user blocked") {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context)
                  .showSnackBar(errorSnackBar("${validatePassRes.message}"));
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.unblockUser, (route) => false);
              pref.setUserPassword(
                password: "null",
              );
              clearController();
              clearError();
            } else {
              pref.setUserPassword(
                password: "null",
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(errorSnackBar("${validatePassRes.message}"));
              clearController();
              clearError();
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      log("Failed with verify Password ::: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  /// Method to validate forgot password
  ///
  ///
  ///

  void submitForgotPassword({
    required BuildContext context,
    required bool isResend,
  }) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: "forgotPassword")) {
        pref.setUserId(userIdController.text.toUpperCase());
        final input = ForgotPasswordInput(
          userId: pref.userId ?? '',
          pan: panController.text.toUpperCase(),
        );
        final res = await api.forgotPassword(
          input: input,
          context: context,
          ref: ref,
        );
        if (res != null) {
          if (res.status!) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(successSnackbar(res.message ?? ''));
            if (!isResend) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.forgotPasswordOTP, (route) => false);
              FocusScope.of(context).unfocus();
            }
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(res.message ?? ''));
          }
        }
      }
      notifyListeners();
    } catch (e) {
      log("Failed to ");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  void sendOtp({
    required BuildContext context,
    required bool isResend,
  }) async {
    try {
      toggleLoadingOn(true);
      final input = SendOtpInput(
        userId: pref.userId!.toUpperCase(),
      );
      final res = await api.sendOTP(
        input: input,
        context: context,
        ref: ref,
      );

      if (res != null) {
        final json = jsonDecode(res.body);
        if ((json["status"] ?? '').toString().toUpperCase() == "OK") {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
              successSnackbar((json["message"] ?? '').toString()));
          if (!isResend) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.otpScreen,
              (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar((json["message"] ?? '').toString()));
        }
      }
    } catch (e) {
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  Future<void> verifyTotp(BuildContext context) async {
    if (validate(authStep: 'totp')) {
      try {
        toggleLoadingOn(true);
        TotpInput input = TotpInput(
          userId: pref.userId ?? '',
          totp: otpController.text,
          fcmToken: pref.fcmToken ?? '',
        );
        final response = await api.verifyTotp(
          input: input,
          context: context,
          ref: ref,
        );

        if (response != null) {
          toggleLoadingOn(false);
          if (response.status.toString().toLowerCase() == 'ok') {
            clearController();
            clearError();
            // if (response.sPasswordReset!.toUpperCase() == 'Y') {
            //   ref(userProvider).changePasswordResetOption(value: true);
            //   // Navigator.pushNamedAndRemoveUntil(
            //   //     context, Routes.resetpassword, (route) => false);
            // } else {
            pref.setSessionId(response.result![0].accessToken!);
            await ref
                .read(webscoketHelperProvider)
                .invalidateWSSession(context: context);
            await ref
                .read(webscoketHelperProvider)
                .createWSSession(context: context);
            // await ref(marketProvider).getUserWatchlist(context: context);
            // ref(loginProvider).clearController();
            // ref(loginProvider).clearError();
            ref.read(settingsProvider).getProfileData(context: context);
            ref.read(menuProvider).setBottomTabIntial();
            await Navigator.pushNamedAndRemoveUntil(
                context, Routes.menuScreen, (route) => false);
          } else if (response.message!.toLowerCase().contains("block") ==
              true) {
            clearController();
            otpController.text = otpController.text;
            otpController.selection =
                TextSelection.collapsed(offset: otpController.text.length);
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(response.message ?? ''));
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.unblockUser, (route) => false);
          } else {
            clearController();
            otpController.text = otpController.text;
            otpController.selection =
                TextSelection.collapsed(offset: otpController.text.length);
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(response.message ?? ''));
          }
        }
      } catch (e) {
        log("Failed to login Totp :::: $e");
        toggleLoadingOn(false);
        ScaffoldMessenger.of(context).clearSnackBars();
        if (e.toString().contains('SocketException:')) {
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar('No Internet Connection'));
        } else {
          clearController();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar('Something went wrong!'));
        }
      } finally {
        try {
          toggleLoadingOn(false);
        } catch (e) {}
      }
    }
    notifyListeners();
  }

  Future<void> generateScanner(BuildContext context) async {
    try {
      GenerateTotp input = GenerateTotp(userId: pref.userId ?? '');
      final response = await api.generateScanner(
        input: input,
        context: context,
        ref: ref,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['stat'] == 'Ok') {
          ScaffoldMessenger.of(context).showSnackBar(
            successSnackbar(
              json['message'],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            successSnackbar(
              json['message'],
            ),
          );
        }
      }
    } catch (e) {
      log("Generate Scanner Error ::: $e");
    }
  }

  Future<void> verifyOTP(BuildContext context) async {
    if (validate(authStep: 'otp')) {
      try {
        toggleLoadingOn(true);
        GetScannerTotpOtpVerifyInput input = GetScannerTotpOtpVerifyInput(
          otp: otpController.text,
          userId: pref.userId ?? '',
        );
        final res = await api.getScannerTOTPOtp(
          context: context,
          input: input,
          ref: ref,
        );

        if (res != null) {
          toggleLoadingOn(false);
          clearController();
          clearError();
          final json = jsonDecode(res.body);
          getScannerOtp = GetScannerOtp.fromJson(json);
          if (getScannerOtp != null && getScannerOtp!.stat!) {
            if (getScannerOtp != null && getScannerOtp!.result != null) {
              qrImage = getScannerOtp!.result![0]!.scanImge!;
              secKey = getScannerOtp!.result![0]!.secKey!;
            }
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.totpScanScreen, (route) => false);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar('${json['message']}'));
            if (json['message']
                .toString()
                .contains('OTP Attempt level reached, Redirect to Password')) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.password, (route) => false);
            }
          }
          otpController.text = otpController.text;
          otpController.selection = TextSelection.collapsed(
            offset: otpController.text.length,
          );
        }

        notifyListeners();
      } catch (e) {
        log("VERIFY OTP ERROR ::: $e");
      } finally {
        try {
          toggleLoadingOn(false);
        } catch (e) {}
      }
    } else {
      notifyListeners();
    }
  }

  Future<void> enableTOTP(BuildContext context) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: 'totp')) {
        EnableTotpInput input = EnableTotpInput(
            totp: otpController.text, userId: pref.userId ?? '');
        final res = await api.enableTOTP(
          context: context,
          input: input,
          ref: ref,
        );
        if (res != null) {
          toggleLoadingOn(false);
          clearController();
          clearError();
          final json = jsonDecode(res.body);
          if ((json['status'] ?? '').toString().toLowerCase() == 'ok' &&
              (json['message'] ?? '').toString().toLowerCase() == 'success') {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(successSnackbar('${json['message']}'));
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.totpScreen, (route) => false);
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar('${json['message']}'));
          }
        }
      }
      otpController.text = otpController.text;
      otpController.selection =
          TextSelection.collapsed(offset: otpController.text.length);
    } catch (e) {
      log("VERIFY OTP ERROR ::: $e");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  /// Method to sumbit unblock user otp
  ///
  ///

  Future<void> submitUnblockUserVerifyOTP(BuildContext context) async {
    try {
      if (validate(authStep: "unblockotp")) {
        toggleLoadingOn(true);
        final input = UnbolckVerifyOTPInput(
            userId: pref.userId ?? '', otp: otpController.text);
        final res = await api.unblockUserVerifyOTP(
          input: input,
          context: context,
          ref: ref,
        );
        if (res != null) {
          toggleLoadingOn(false);
          final json = jsonDecode(res.body);
          if ((json["status"] ?? '').toString().toLowerCase() != "not ok") {
            if ((json["message"] ?? '').toString() != "" &&
                (json["message"] ?? '').toString() ==
                    "User unblocked sucessfully") {
              clearController();
              clearError();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(successSnackbar(
                  (json["message"] ?? '').toString() != ""
                      ? (json["message"] ?? '').toString()
                      : ""));
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.password,
                (route) => false,
              );
            }

            FocusScope.of(context).unfocus();
          } else {}
        }
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  Future<void> submitOtp({
    required BuildContext context,
  }) async {
    toggleLoadingOn(true);
    try {
      if (validate(authStep: "otp")) {
        final input = ValidateOtpInput(
          otp: otpController.text,
          source: "MOB",
          fcmToken: pref.fcmToken ?? '',
          userId: pref.userId ?? '',
        );
        final res = await api.validateOTP(
          input: input,
          context: context,
          ref: ref,
        );
        if (res != null) {
          toggleLoadingOn(false);
          if (res.result!.isNotEmpty &&
              res.status! &&
              res.result![0].accessToken!.isNotEmpty &&
              res.result![0].kcRole!.toUpperCase() == "ACTIVE_USER") {
            pref.setSessionId(res.result![0].accessToken!);
            await ref
                .read(webscoketHelperProvider)
                .invalidateWSSession(context: context);
            await ref
                .read(webscoketHelperProvider)
                .createWSSession(context: context);
            // await ref(marketProvider).getUserWatchlist(context: context);
            // await ref(marketProvider).getDefaultTabScrip(context: context);
            clearController();
            clearError();
            ref.read(settingsProvider).getProfileData(context: context);
            ref.read(menuProvider).setBottomTabIntial();
            await Navigator.pushNamedAndRemoveUntil(
                context, Routes.menuScreen, (route) => false);
          } else if (!res.status!) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(res.message ?? ''));
          }
        }
      }
      notifyListeners();
    } catch (e) {
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  /// Method to verify forgot password otp
  ///
  ///

  Future<void> submitForgotPasswordVerifyOtp(BuildContext context) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: "otp")) {
        pref.setUserId(userIdController.text.toUpperCase());
        final input = ForgotPasswordVerifyOTPInput(
          userId: pref.userId ?? '',
          otp: otpController.text,
        );
        final res = await api.forgotPasswordVerifyOTP(
          input: input,
          context: context,
          ref: ref,
        );
        if (res != null) {
          toggleLoadingOn(false);
          if (res.result!.isNotEmpty && res.status!) {
            pref.setLocalSessionId(res.result![0].token!);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(successSnackbar(res.message ?? ''));
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.setPasswordScreen,
              (route) => false,
            );
            FocusScope.of(context).unfocus();
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(errorSnackBar(res.message ?? ''));
          }
        } else {}

        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("error in forgot pass ${e}");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }

  Future<void> submitResetPass({
    required BuildContext context,
  }) async {
    try {
      toggleLoadingOn(true);
      if (validate(authStep: "setPassword")) {
        final input = ResetPasswordInput(
          password: newPasswordController.text,
          userId: pref.userId,
        );

        final response = await api.resetPassword(
          input: input,
          context: context,
          ref: ref,
        );
        if (response != null) {
          toggleLoadingOn(false);
          clearController();
          clearError();
          final json = jsonDecode(response.body);
          if ((json["status"] ?? '').toString().toLowerCase() != "not ok") {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                successSnackbar((json["message"] ?? 'Success').toString()));
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.password, (route) => false);
            FocusScope.of(context).unfocus();
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
                errorSnackBar((json["message"] ?? 'Failed').toString()));
          }
        } else {}

        notifyListeners();

        // else if (isFrom == "GUESTUSER") {
        //   final input = CreateUserInput(
        //       password: newPasswordController.text,
        //       id: ref(otpProvider).verifyEmailRes!.result!.id);
        //   _createUser = await api.createUser(input, context);

        //   if (_createUser != null) {
        //     if (_createUser!.stat!.toLowerCase() != "0") {
        //       ScaffoldMessenger.of(context).clearSnackBars();
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           successSnackbar(_createUser!.message ?? "Success"));

        //       Navigator.pushNamed(context, Routes.login);

        //       FocusScope.of(context).unfocus();
        //     } else {
        //       ScaffoldMessenger.of(context).clearSnackBars();
        //       ScaffoldMessenger.of(context)
        //           .showSnackBar(errorSnackBar(_createUser!.message ?? ""));
        //     }
        //   }
        // }
      }
    } catch (e) {
      log("error in submit reset pass ${e}");
    } finally {
      try {
        toggleLoadingOn(false);
      } catch (e) {}
    }
  }
}
