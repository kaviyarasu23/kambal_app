import 'package:aliceblue/api/core/api_links.dart';
import 'dart:convert';

class UnblockUserInput {
  UnblockUserInput({
    required this.userId,
    this.source = ApiLinks.loginType,
    required this.pan,
  });

  String userId;
  String source;
  String pan;

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "pan": pan,
      };
}

// To parse this JSON data, do
//
//     final unblockUserInfo = unblockUserInfoFromJson(jsonString);



UnblockUserInfo unblockUserInfoFromJson(String str) => UnblockUserInfo.fromJson(json.decode(str));

String unblockUserInfoToJson(UnblockUserInfo data) => json.encode(data.toJson());

class UnblockUserInfo {
    bool? status;
    String? message;
    List<dynamic>? result;

    UnblockUserInfo({
        this.status,
        this.message,
        this.result,
    });

    factory UnblockUserInfo.fromJson(Map<String, dynamic> json) => UnblockUserInfo(
        status: (json["status"] ?? '').toString().toLowerCase() == "ok",
        message: (json["message"] ?? '').toString(),
        result: json["result"] == null ? [] : List<dynamic>.from(json["result"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x)),
    };
}


class UnbolckVerifyOTPInput {
  UnbolckVerifyOTPInput({
    required this.userId,
    this.source = ApiLinks.loginType,
    required this.otp,
  });

  String userId;
  String source;
  String otp;

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "otp": otp,
      };
}