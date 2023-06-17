// To parse this JSON data, do
//
//     final getUserPref = getUserPrefFromJson(jsonString);

import 'dart:convert';

GetUserPref getUserPrefFromJson(String str) =>
    GetUserPref.fromJson(json.decode(str));

String getUserPrefToJson(GetUserPref data) => json.encode(data.toJson());

class GetUserPref {
  GetUserPref({
    required this.status,
    required this.message,
    required this.result,
  });

  String status;
  String message;
  List<GetUserPrefResult> result;

  factory GetUserPref.fromJson(Map<String, dynamic> json) {
    List<GetUserPrefResult> resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(GetUserPrefResult.fromJson(element));
      }
    }
    return GetUserPref(
      status: (json["status"] ?? '').toString(),
      message: (json["message"] ?? '').toString(),
      result: resultVal,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class GetUserPrefResult {
  GetUserPrefResult({
    required this.tag,
    required this.value,
  });


  String tag;
  String value;

  factory GetUserPrefResult.fromJson(Map<String, dynamic> json) =>
      GetUserPrefResult(
        tag: (json["tag"] ?? '').toString(),
        value: (json["value"] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "tag": tag,
      };
}

class UserPrefGetInput {
  final String source;
  final String keyVariable;
  UserPrefGetInput({
    this.keyVariable = "",
    this.source = "",
  });
  Map<String, dynamic> toJson() => {
        "source": source,
        "keyVariable": keyVariable,
      };
}

class UserPreferenceUpdateInput {
  final String userId;
  final String source;
  final List<UpdatePrefInput>? preferences;
  UserPreferenceUpdateInput({
    this.preferences,
    this.source = "",
    this.userId = "",
  });
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "source": source,
        "preferences": preferences,
      };
}

class UpdatePrefInput {
  final String tag;
  final String value;
  UpdatePrefInput({
    this.tag = "",
    this.value = "",
  });
  Map<String, dynamic> toJson() => {
        "tag": tag,
        "value": value,
      };
}
