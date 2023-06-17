import 'dart:convert';


class UserInfoInput {
  final String userId;
  UserInfoInput({
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
        'userId': userId,
      };
}



// To parse this JSON data, do
//
//     final userCheckInfo = userCheckInfoFromJson(jsonString);



UserCheckInfo userCheckInfoFromJson(String str) => UserCheckInfo.fromJson(json.decode(str));

String userCheckInfoToJson(UserCheckInfo data) => json.encode(data.toJson());

class UserCheckInfo {
    bool? status;
    String? message;
    List<UserCheckInfoResult>? result;

    UserCheckInfo({
        this.status,
        this.message,
        this.result,
    });

    factory UserCheckInfo.fromJson(Map<String, dynamic> json) {
      List<UserCheckInfoResult>? resultVal = [];
      if(json["result"] != null){
        for (var element in json["result"]) {
          resultVal.add(UserCheckInfoResult.fromJson(element));
        }

      }
      return UserCheckInfo(
        status: (json["status"] ?? '').toString().toLowerCase() == "ok",
        message: (json["message"] ?? "").toString(),
        result: resultVal,
    );
    } 

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class UserCheckInfoResult {
    String? isExist;

    UserCheckInfoResult({
        this.isExist,
    });

    factory UserCheckInfoResult.fromJson(Map<String, dynamic> json) => UserCheckInfoResult(
        isExist: (json["isExist"] ?? '').toString(),
    );

    Map<String, dynamic> toJson() => {
        "isExist": isExist,
    };
}
