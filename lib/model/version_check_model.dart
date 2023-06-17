import 'dart:convert';

class VersionCheckInput {
  final String version;
  final String os;

  const VersionCheckInput({
    required this.version,
    this.os = "",
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        "os": os,
      };
}

// To parse this JSON data, do
//
//     final versionCheckInfo = versionCheckInfoFromJson(jsonString);

VersionCheckInfo versionCheckInfoFromJson(String str) =>
    VersionCheckInfo.fromJson(json.decode(str));

String versionCheckInfoToJson(VersionCheckInfo data) =>
    json.encode(data.toJson());

class VersionCheckInfo {
  bool? status;
  String? message;
  List<VersionCheckInfoResult>? result;

  VersionCheckInfo({
    this.status,
    this.message,
    this.result,
  });

  factory VersionCheckInfo.fromJson(Map<String, dynamic> json) {
    List<VersionCheckInfoResult>? resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(VersionCheckInfoResult.fromJson(element));
      }
    }
    return VersionCheckInfo(
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

class VersionCheckInfoResult {
  String? isUpdateAvailable;

  VersionCheckInfoResult({
    this.isUpdateAvailable,
  });

  factory VersionCheckInfoResult.fromJson(Map<String, dynamic> json) =>
      VersionCheckInfoResult(
        isUpdateAvailable: (json["isUpdateAvailable"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "isUpdateAvailable": isUpdateAvailable,
      };
}
