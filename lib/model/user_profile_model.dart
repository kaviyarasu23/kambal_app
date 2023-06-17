import 'dart:convert';

ProfileRes profileResFromJson(String str) =>
    ProfileRes.fromJson(json.decode(str));

String profileResToJson(ProfileRes data) => json.encode(data.toJson());

class ProfileRes {
  ProfileRes({
    required this.status,
    required this.message,
    required this.result,
  });

  String status;
  String message;
  List<ProfileResult?> result;

  factory ProfileRes.fromJson(Map<String, dynamic> json) {
    List<ProfileResult?> resultVal = [];
    if (json["result"] != null) {
      for (var element in json["result"]) {
        resultVal.add(ProfileResult.fromJson(element));
      }
    }
    return ProfileRes(
      status: (json["status"] ?? '').toString(),
      message: (json["message"] ?? '').toString(),
      result: resultVal,
    );
  }
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result,
      };
}

class ProfileResult {
  ProfileResult(
      {required this.userId,
      required this.actId,
      required this.clientName,
      required this.actStatus,
      required this.createdDate,
      required this.createdTime,
      required this.mobNo,
      required this.email,
      required this.pan,
      required this.address,
      required this.officeAddress,
      required this.city,
      required this.state,
      required this.mandateIdList,
      required this.exchange,
      required this.bankdetails,
      required this.dpAccountNumber,
      required this.orders,
      required this.branchId,
      required this.brokerName,
      required this.products,
      required this.productTypes,
      required this.priceTypes});

  String userId;
  String actId;
  String clientName;
  String actStatus;
  String createdDate;
  String createdTime;
  String mobNo;
  String email;
  String pan;
  String address;
  String officeAddress;
  String city;
  String state;
  List<String> mandateIdList;
  List<String> exchange;
  List<BankDetail?> bankdetails;
  List<DpAccountNumber?> dpAccountNumber;
  List<String> orders;
  String branchId;
  String brokerName;
  List<String> products;
  List<String> productTypes;
  List<String> priceTypes;

  factory ProfileResult.fromJson(Map<String, dynamic> json) {
    String segmentsVal = "";
    try {
      var segmentExchangeArrayVal = (json["exchange"] ?? '');
      for (var item in segmentExchangeArrayVal) {
        if (item == "BCD") {
          segmentsVal += "BCD, ";
        } else if (item == "BFO") {
          segmentsVal += "BFO, ";
        } else if (item == "CDS") {
          segmentsVal += "CDS, ";
        } else if (item == "MCX") {
          segmentsVal += "MCX, ";
        } else if (item == "BSE") {
          segmentsVal += "BSE, ";
        } else if (item == "NSE") {
          segmentsVal += "NSE, ";
        } else if (item == "NFO") {
          segmentsVal += "NFO, ";
        } else if (item == "BCO") {
          segmentsVal += "BCO, ";
        } else if (item == "NCO") {
          segmentsVal += "NCO, ";
        }
      }
      if (segmentsVal.isNotEmpty) {
        segmentsVal = segmentsVal.substring(0, segmentsVal.length - 2);
      }
    } catch (e) {
      segmentsVal = "";
    }
    List<BankDetail?> accountDetail = [];
    if (json["bankdetails"] != null) {
      for (var element in json["bankdetails"]) {
        accountDetail.add(BankDetail.fromJson(element));
      }
    }
    List<DpAccountNumber?> dematBoNumber = [];
    if (json["dpAccountNumber"] != null) {
      for (var element in json["dpAccountNumber"]) {
        dematBoNumber.add(DpAccountNumber.fromJson(element));
      }
    }
    return ProfileResult(
      userId: (json["userId"] ?? "").toString(),
      actId: (json["actId"] ?? "").toString(),
      clientName: (json["clientName"] ?? "").toString(),
      actStatus: (json["actStatus"] ?? "").toString(),
      createdDate: (json["createdDate"] ?? "").toString(),
      createdTime: (json["createdTime"] ?? "").toString(),
      mobNo: (json["mobNo"] ?? "").toString(),
      email: (json["email"] ?? "").toString(),
      pan: (json["pan"] ?? "").toString(),
      address: (json["address"] ?? "").toString(),
      officeAddress: (json["officeAddress"] ?? "").toString(),
      city: (json["city"] ?? "").toString(),
      state: (json["state"] ?? "").toString(),
      mandateIdList: List<String>.from(json["mandateIdList"].map((x) => x)),
      exchange: List<String>.from(json["exchange"].map((x) => x)),
      bankdetails: accountDetail,
      dpAccountNumber: dematBoNumber,
      orders: List<String>.from(json["orders"].map((x) => x)),
      branchId: (json["branchId"]),
      brokerName: (json["brokerName"]),
      products: List<String>.from(json["products"].map((x) => x)),
      productTypes: List<String>.from(json["productTypes"].map((x) => x)),
      priceTypes: List<String>.from(json["priceTypes"].map((x) => x)),
    );
  }
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "actId": actId,
        "clientName": clientName,
        "actStatus": actStatus,
        "createdDate": createdDate,
        "createdTime": createdTime,
        "mobNo": mobNo,
        "email": email,
        "pan": pan,
        "address": address,
        "officeAddress": officeAddress,
        "city": city,
        "state": state,
        "mandateIdList": List<dynamic>.from(mandateIdList.map((x) => x)),
        "exchange": List<dynamic>.from(exchange.map((x) => x)),
        "bankdetails": bankdetails,
        "dpAccountNumber": dpAccountNumber,
        "orders": List<dynamic>.from(orders.map((x) => x)),
        "branchId": branchId,
        "brokerName": brokerName,
        "products": List<dynamic>.from(products.map((x) => x)),
        "productTypes": List<dynamic>.from(productTypes.map((x) => x)),
        "priceTypes": List<dynamic>.from(priceTypes.map((x) => x)),
      };
}

class BankDetail {
  BankDetail({
    required this.bankName,
    required this.accNumber,
  });

  String bankName;
  String accNumber;

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        bankName: json["bankName"],
        accNumber: json["accNumber"],
      );

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "accNumber": accNumber,
      };
}

class DpAccountNumber {
  DpAccountNumber({
    this.dpAccountNumber,
  });

  final String? dpAccountNumber;

  factory DpAccountNumber.fromJson(Map<String, dynamic> json) =>
      DpAccountNumber(
        dpAccountNumber: json["dpAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "dpAccountNumber": dpAccountNumber,
      };
}
