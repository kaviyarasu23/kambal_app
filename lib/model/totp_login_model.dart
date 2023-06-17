import 'dart:convert';

import '../api/core/api_links.dart';

class TotpInput {
  final String totp;
  final String userId;
  final String? source;
  final String? fcmToken;

  const TotpInput({
    required this.userId,
    required this.totp,
    required this.fcmToken,
    this.source = ApiLinks.loginType,
  });

  Map<String, dynamic> toJson() => {
        "totp": totp,
        "userId": userId,
        "source": source,
        "fcmToken": fcmToken,
      };
}

class GenerateTotp {
  final String userId;
  final String source;
  GenerateTotp({
    this.source = ApiLinks.loginType,
    this.userId = "",
  });
  Map<String, dynamic> toJson() => {
        "source": source,
        "userId": userId,
      };
}

class GetScannerTotpOtpVerifyInput {
  final String userId;
  final String source;
  final String otp;
  GetScannerTotpOtpVerifyInput({
    this.otp = "",
    this.source = ApiLinks.loginType,
    this.userId = "",
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "otp": otp,
      };
}

class EnableTotpInput {
  final String userId;
  final String source;
  final String totp;
  EnableTotpInput({
    this.totp = "",
    this.source = ApiLinks.loginType,
    this.userId = "",
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "totp": totp,
      };
}

GetScannerOtp getScannerOtpFromJson(String str) =>
    GetScannerOtp.fromJson(json.decode(str));

String getScannerOtpToJson(GetScannerOtp data) => json.encode(data.toJson());

class GetScannerOtp {
  GetScannerOtp({
    this.stat,
    this.result,
    this.message,
  });

  bool? stat;
  List<GetScannerOtpResult?>? result;
  String? message;

  factory GetScannerOtp.fromJson(Map<String, dynamic> json) {
    List<GetScannerOtpResult?> resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(GetScannerOtpResult.fromJson(element));
      }
    }

    return GetScannerOtp(
      stat: (json["status"] ?? '').toString().toLowerCase() == 'ok',
      result: resultVal,
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "stat": stat,
        "result": result!,
        "message": message,
      };
}

class GetScannerOtpResult {
  GetScannerOtpResult({
    this.secKey,
    this.scanImge,
    this.totpEnabled,
  });

  String? secKey;
  String? scanImge;
  bool? totpEnabled;

  factory GetScannerOtpResult.fromJson(Map<String, dynamic> json) =>
      GetScannerOtpResult(
        secKey: (json["secKey"] ?? '').toString(),
        scanImge: (json["scanImge"] ?? '').toString(),
        totpEnabled: (json["totpEnabled"] ?? false) as bool,
      );

  Map<String, dynamic> toJson() => {
        "secKey": secKey,
        "scanImge": scanImge,
        "totpEnabled": totpEnabled,
      };
}

// To parse this JSON data, do
//
//     final verifyTotpInfo = verifyTotpInfoFromJson(jsonString);

VerifyTotpInfo verifyTotpInfoFromJson(String str) =>
    VerifyTotpInfo.fromJson(json.decode(str));

String verifyTotpInfoToJson(VerifyTotpInfo data) => json.encode(data.toJson());

class VerifyTotpInfo {
  String? status;
  String? message;
  List<VerifyTotpInfoResult>? result;

  VerifyTotpInfo({
    this.status,
    this.message,
    this.result,
  });

  factory VerifyTotpInfo.fromJson(Map<String, dynamic> json) {
    List<VerifyTotpInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(VerifyTotpInfoResult.fromJson(element));
      }
    }
    return VerifyTotpInfo(
      status: json["status"],
      message: json["message"],
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

class VerifyTotpInfoResult {
  String? accessToken;
  String? refreshToken;
  String? kcRole;

  VerifyTotpInfoResult({
    this.accessToken,
    this.refreshToken,
    this.kcRole,
  });

  factory VerifyTotpInfoResult.fromJson(Map<String, dynamic> json) =>
      VerifyTotpInfoResult(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"],
        kcRole: json["kcRole"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "kcRole": kcRole,
      };
}
