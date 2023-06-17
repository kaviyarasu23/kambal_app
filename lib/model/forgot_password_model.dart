import '../api/core/api_links.dart';
import 'dart:convert';

class ForgotPasswordInput {
  ForgotPasswordInput({
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
//     final forgotPasswordInfo = forgotPasswordInfoFromJson(jsonString);



ForgotPasswordInfo forgotPasswordInfoFromJson(String str) => ForgotPasswordInfo.fromJson(json.decode(str));

String forgotPasswordInfoToJson(ForgotPasswordInfo data) => json.encode(data.toJson());

class ForgotPasswordInfo {
    bool? status;
    String? message;
    List<dynamic>? result;

    ForgotPasswordInfo({
        this.status,
        this.message,
        this.result,
    });

    factory ForgotPasswordInfo.fromJson(Map<String, dynamic> json) => ForgotPasswordInfo(
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


class ForgotPasswordVerifyOTPInput {
  ForgotPasswordVerifyOTPInput({
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

// To parse this JSON data, do
//
//     final forgotPasswordOtpInfo = forgotPasswordOtpInfoFromJson(jsonString);


ForgotPasswordOtpInfo forgotPasswordOtpInfoFromJson(String str) => ForgotPasswordOtpInfo.fromJson(json.decode(str));

String forgotPasswordOtpInfoToJson(ForgotPasswordOtpInfo data) => json.encode(data.toJson());

class ForgotPasswordOtpInfo {
    bool? status;
    String? message;
    List<ForgotPasswordOtpInfoResult>? result;

    ForgotPasswordOtpInfo({
        this.status,
        this.message,
        this.result,
    });

    factory ForgotPasswordOtpInfo.fromJson(Map<String, dynamic> json) {
      List<ForgotPasswordOtpInfoResult>? resultVal = [];
      if(json["result"] != null){
        for (var element in json["result"]) {
          resultVal.add(ForgotPasswordOtpInfoResult.fromJson(element));
        }
      }
      return ForgotPasswordOtpInfo(
        status: (json["status"] ?? '').toString().toLowerCase() == "ok",
        message: (json["message"] ?? '').toString(),
        result: resultVal,
    );
    } 

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class ForgotPasswordOtpInfoResult {
    String? token;

    ForgotPasswordOtpInfoResult({
        this.token,
    });

    factory ForgotPasswordOtpInfoResult.fromJson(Map<String, dynamic> json) => ForgotPasswordOtpInfoResult(
        token: (json["token"] ?? ''),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
