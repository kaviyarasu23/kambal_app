import 'dart:convert';
import 'dart:developer';

import 'package:aliceblue/model/unblock_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../model/forgot_password_model.dart';
import '../model/otp_model.dart';
import '../model/password_model.dart';
import '../model/set_password_model.dart';
import '../model/totp_login_model.dart';
import '../model/user_check_model.dart';
import '../model/version_check_model.dart';
import '../model/webscoket_connection_model.dart';
import 'core/api_core.dart';

mixin AuthApi on ApiCore {

  /// Method to check if the version is valid or not
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [VersionCheckInput] return [VersionCheckInfo]

  Future<VersionCheckInfo?> getAppVersionCheck(
      {required VersionCheckInput input,
      required BuildContext context,
      required Ref ref}) async {
    try {
      final uri = Uri.parse(apiLinks.getVersionCheck);
      log("VERSION CHECK URL ::: $uri");
      log('START TIME  :: ${DateTime.now()}');
      log('JSON VERSION CHECK  :: ${jsonEncode(input.toJson())}');
      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('START TIME  :: END VERSION CHECK ${DateTime.now()}');
      log('VERSION CHECK RES:: ${response.body}');

      VersionCheckInfo? versionCheckInfo;

      // ignore: use_build_context_synchronously
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        versionCheckInfo = VersionCheckInfo.fromJson(json);
      }

      return versionCheckInfo;
    } catch (e) {
      rethrow;
    }
  }

  /// Check If the UserId is Valid Or Not
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [UserInfoInput] return [UserCheckInfo]

  Future<UserCheckInfo?> checkUser({
    required UserInfoInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.checkUser);
      log('JSON CHECK USER:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('CHECK USER RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      UserCheckInfo? checkUserRes;
      // ignore: use_build_context_synchronously
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        checkUserRes = UserCheckInfo.fromJson(json);
      }
      return checkUserRes;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate unblock user
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [UnblockUserInput] return [UnblockUserInfo]

  Future<UnblockUserInfo?> unblockUser({
    required UnblockUserInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.unblockUser);
      log('JSON UNBLOCK USER:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('UNBLOCK USER :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      UnblockUserInfo? unblockUserRes;
      if (await checkSessionValidate(
        context: context,
        response: response,
        ref: ref,
      )) {
        final json = jsonDecode(response.body);
        unblockUserRes = UnblockUserInfo.fromJson(json);
      }

      return unblockUserRes;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate password
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [PasswordInput] return [PasswordVerifyInfo]

  Future<PasswordVerifyInfo?> validatePass({
    required PasswordInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.validatePass);
      log('JSON VALIDATE PASS:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('VALIDATE PASS RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      PasswordVerifyInfo? passwordVerifyInfo;
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        passwordVerifyInfo = PasswordVerifyInfo.fromJson(json);
      }
      return passwordVerifyInfo;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate forgot password
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [ForgotPasswordInput] return [ForgotPasswordInfo]

  Future<ForgotPasswordInfo?> forgotPassword({
    required ForgotPasswordInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.forgotPassword);
      log('JSON FORGOT PASS:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('FORGOT PASS RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      ForgotPasswordInfo? validatePassRes;

      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        validatePassRes = ForgotPasswordInfo.fromJson(json);
      }
      return validatePassRes;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to create WS Session
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [SessionCreateInvalidateInput] return [void]

  Future<void> createWSSession({
    required BuildContext context,
    required Ref ref,
    required SessionCreateInvalidateInput input,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.createSessionWS);
      final response = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(
          input.toJson(),
        ),
      );
      log("WS SESSION RES ::::${response.body}");
      if (await checkSessionValidate(
        context: context,
        ref: ref,
        response: response,
      )) {
        // final json = jsonDecode(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Method to invalidate WS Session
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [SessionCreateInvalidateInput] return [void]

  Future<void> invalidateWSSession({
    required BuildContext context,
    required Ref ref,
    required SessionCreateInvalidateInput input,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.invalidateSessionWS);
      final response = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(
          input.toJson(),
        ),
      );
      log("WS INVALIDATE SESSION RES ::::${response.body}");
      if (await checkSessionValidate(
        context: context,
        ref: ref,
        response: response,
      )) {
        final json = jsonDecode(response.body);
        if (json['Status'].toString().toLowerCase() == 'ok') {
          // context.read(websocketProvider).establishConnection(channelInput: "", task: 't');
          log("");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Method to send OTP for Clients
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [SendOtpInput] return [Response]

  Future<Response?> sendOTP({
    required SendOtpInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.sendOTP);
      log('JSON SEND OTP:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: localAuthHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('SEND OTP RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      // SendOtpRes? sendOtpRes;
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        // final json = jsonDecode(response.body);
        return response;
        // sendOtpRes = SendOtpRes.fromJson(json);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to verify TOTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [TotpInput] return [VerifyTotpInfo]

  Future<VerifyTotpInfo?> verifyTotp({
    required BuildContext context,
    required Ref ref,
    required TotpInput input,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.verifyTotp);
      log("JSON TOTP :::: ${jsonEncode(input.toJson())}");
      log("TOTP LOGIN ::: START TIME ${DateTime.now()}");
      final response = await apiClient.post(
        uri,
        headers: localAuthHeaders,
        body: jsonEncode(input.toJson()),
      );
      log("TOTP LOGIN ::: END TIME ${DateTime.now()}");
      log("RES TOTP STATUS CODE ::: ${response.statusCode} BODY :::: ${response.body}");
      VerifyTotpInfo? verifyTotpInfo;
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        verifyTotpInfo = VerifyTotpInfo.fromJson(json);
      }
      return verifyTotpInfo;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to QR Code / Secret Key Generate for TOTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [GenerateTotp] return [Response]

  Future<Response> generateScanner({
    required GenerateTotp input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.generateScanner);
      log('START TIME GENERATE SCANNER :: ${DateTime.now()}');
      final response = await apiClient.post(
        uri,
        body: jsonEncode(input.toJson()),
        headers: localAuthHeaders,
      );
      log('START TIME GENERATE SCANNER :: END ${DateTime.now()}');
      log('GENERATE SCANNER RES :: ${response.body}');

      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) return response;
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to ScanQR TOTP OTP verify
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [GetScannerTotpOtpVerifyInput] return [Response]

  Future<Response?> getScannerTOTPOtp({
    required GetScannerTotpOtpVerifyInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.verifyOTPTotp);
      log('START TIME GET SCANNER TOTP OTP :: ${DateTime.now()}');
      log('GET SCANNER TOTP OTP JSON :: ${jsonEncode(input.toJson())}');
      log("local session ID ::: ${localAuthHeaders}");
      final response = await apiClient.post(uri,
          headers: localAuthHeaders, body: jsonEncode(input.toJson()));
      log('START TIME GET SCANNER TOTP OTP :: END ${DateTime.now()}');
      log('GET SCANNER TOTP OTP RES :: ${response.body}');

      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to Enable TOTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [EnableTotpInput] return [Response]

  Future<Response?> enableTOTP({
    required EnableTotpInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.enableTotp);
      log('START TIME ENABLE TOTP :: ${DateTime.now()}');
      log('ENABLE TOTP JSON :: ${jsonEncode(input.toJson())}');
      final response = await apiClient.post(uri,
          headers: localAuthHeaders, body: jsonEncode(input.toJson()));
      log('START TIME ENABLE TOTP :: END ${DateTime.now()}');
      log('ENABLE TOTP  RES :: ${response.body}');
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        // final json = jsonDecode(response.body);
        return response;
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate unblock user verify OTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [UnbolckVerifyOTPInput] return [Response]

  Future<Response?> unblockUserVerifyOTP({
    required UnbolckVerifyOTPInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.unblockUserVerifyOTP);
      log('JSON UNBLOCK USER VERIFY OTP:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('UNBLOCK USER VERIFY OTP:: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      // UnblockUserRes? unblockUserRes;
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        return response;
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate OTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [ValidateOtpInput] return [VerifyOtpInfo]

  Future<VerifyOtpInfo?> validateOTP({
    required ValidateOtpInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.validateOTP);
      log('JSON VALIDATE OTP:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('VALIDATE OTP RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      VerifyOtpInfo? validateOtpRes;

      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        validateOtpRes = VerifyOtpInfo.fromJson(json);
      }
      return validateOtpRes;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to validate forgot password OTP
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [ForgotPasswordVerifyOTPInput] return [ForgotPasswordOtpInfo]

  Future<ForgotPasswordOtpInfo?> forgotPasswordVerifyOTP({
    required ForgotPasswordVerifyOTPInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.forgotPasswordVerifyOTP);
      log('JSON FORGOT VERIFY OTP PASS:: ${jsonEncode(input.toJson())}');

      final response = await apiClient.post(
        uri,
        headers: defaultHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('FORGOT PASS VERIFY OTP RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      ForgotPasswordOtpInfo? forgotPasswordVerifyOtp;

      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        forgotPasswordVerifyOtp = ForgotPasswordOtpInfo.fromJson(json);
      }
      return forgotPasswordVerifyOtp;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to reset new password
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given an input of [ResetPasswordInput] return [Response]

  Future<Response?> resetPassword({
    required ResetPasswordInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.resetpass);
      log('JSON RESET PASS:: ${jsonEncode(input.toJson())}');

      log("LOCAL AUTH ::: ${localAuthHeaders}");

      final response = await apiClient.post(
        uri,
        headers: localAuthHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('RESET RES :: STATUS CODE ::: ${response.statusCode} BODY ::: ${response.body}');
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        return response;
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
