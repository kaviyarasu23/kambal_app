import 'dart:convert';

import '../api/core/api_links.dart';

class SendOtpInput {
  SendOtpInput({
    required this.userId,
    this.source = ApiLinks.loginType,
  });

  String userId;
  String source;

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
      };
}

class ValidateOtpInput {
  ValidateOtpInput({
    required this.userId,
    required this.source,
    required this.otp,
    required this.fcmToken,
  });

  String userId;
  String source;
  String otp;
  String fcmToken;

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "otp": otp,
        "fcmToken": fcmToken,
      };
}

// To parse this JSON data, do
//
//     final verifyOtpInfo = verifyOtpInfoFromJson(jsonString);

VerifyOtpInfo verifyOtpInfoFromJson(String str) =>
    VerifyOtpInfo.fromJson(json.decode(str));

String verifyOtpInfoToJson(VerifyOtpInfo data) => json.encode(data.toJson());

class VerifyOtpInfo {
  bool? status;
  String? message;
  List<VerifyOtpInfoResult>? result;

  VerifyOtpInfo({
    this.status,
    this.message,
    this.result,
  });

  factory VerifyOtpInfo.fromJson(Map<String, dynamic> json) {
    List<VerifyOtpInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(VerifyOtpInfoResult.fromJson(element));
      }
    }
    return VerifyOtpInfo(
      status: (json["status"] ?? '').toString().toLowerCase() == "ok",
      message: (json["message"] ?? '').toString(),
      result: resultVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class VerifyOtpInfoResult {
  String? accessToken;
  String? refreshToken;
  String? kcRole;

  VerifyOtpInfoResult({
    this.accessToken,
    this.refreshToken,
    this.kcRole,
  });

  factory VerifyOtpInfoResult.fromJson(Map<String, dynamic> json) =>
      VerifyOtpInfoResult(
        accessToken: (json["accessToken"] ?? '').toString(),
        refreshToken: (json["refreshToken"] ?? '').toString(),
        kcRole: (json["kcRole"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "kcRole": kcRole,
      };
}
