import '../api/core/api_links.dart';
import 'dart:convert';

class PasswordInput {
  final String userId;
  final String password;
  final String source;

  PasswordInput({
    required this.userId,
    required this.password,
    this.source = ApiLinks.loginType,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "password": password,
        "source": source,
      };
}

// To parse this JSON data, do
//
//     final passwordVerifyInfo = passwordVerifyInfoFromJson(jsonString);

PasswordVerifyInfo passwordVerifyInfoFromJson(String str) =>
    PasswordVerifyInfo.fromJson(json.decode(str));

String passwordVerifyInfoToJson(PasswordVerifyInfo data) =>
    json.encode(data.toJson());

class PasswordVerifyInfo {
  bool? status;
  String? message;
  List<PasswordVerifyInfoResult>? result;

  PasswordVerifyInfo({
    this.status,
    this.message,
    this.result,
  });

  factory PasswordVerifyInfo.fromJson(Map<String, dynamic> json) {
    List<PasswordVerifyInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(PasswordVerifyInfoResult.fromJson(element));
      }
    }
    return PasswordVerifyInfo(
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

class PasswordVerifyInfoResult {
  bool? totpAvailable;
  String? token;
  String? kcRole;

  PasswordVerifyInfoResult({
    this.totpAvailable,
    this.token,
    this.kcRole,
  });

  factory PasswordVerifyInfoResult.fromJson(Map<String, dynamic> json) =>
      PasswordVerifyInfoResult(
        totpAvailable: (json["totpAvailable"] ?? '') as bool,
        token: (json["token"] ?? '').toString(),
        kcRole: (json["kcRole"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "totpAvailable": totpAvailable,
        "token": token,
        "kcRole": kcRole,
      };
}
