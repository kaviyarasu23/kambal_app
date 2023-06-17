import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/contract_info_model.dart';
import '../model/market_watch_list_model.dart';
import '../model/search_scrip_data.dart';
import '../model/security_info.dart';
import '../shared_widget/snack_bar.dart';
import 'core/api_core.dart';

mixin MarketApi on ApiCore {
  Future<GetMwResponse?> getWatchList({
    required getScripsInput userId,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      // final uri = Uri.parse(apiLinks.fetchMWList);
      final uri = Uri.parse(apiLinks.getAllMW);
      log("MARKET WATCH NAMES URL ::: $uri");
      log('MARKET WATCH NAMES JSON :::  ${jsonEncode(userId.toJson())}');
      log('START TIME  :: MW NAME ${DateTime.now()}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(userId.toJson()),
      );
      log('START TIME  :: END MW NAME ${DateTime.now()}');
      log("MARKET WATCH NAMES :::: STATUS CODE :: ${res.statusCode} BODY ::: ${res.body}");

      GetMwResponse? getMwResponse;

      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        getMwResponse = GetMwResponse.fromJson(json);
      }

      return getMwResponse;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> createMW({
    required String userId,
    required Ref ref,
    required BuildContext context,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.createMw);
      log('START TIME  :: CREATE MW NAME ${DateTime.now()}');
      log("CREATE MW JSON ::: ${userId}");
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode({
          "userId": userId,
        }),
      );
      log('START TIME  :: END CREATE MW NAME ${DateTime.now()}');
      log("CREATE MW RES :::: STATUS CODE ::: ${res.statusCode} BODY :: ${res.body}");
      bool isMWCreated = false;
      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        isMWCreated = ((json['stat'] ?? '').toString().toUpperCase() == "OK");
      }

      return isMWCreated;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Scrip>> getScrips(
    String mwID,
    BuildContext context,
    Ref ref,
    String mwname,
  ) async {
    try {
      final uri = Uri.parse(apiLinks.fetchMWScrips);
      log('START TIME  :: GET SCRIP ${DateTime.now()}');
      log("GET SCRIP JSON :: ${jsonEncode({
            "userId": prefs.userId,
            "mwId": mwID
          })}");
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode({
          "userId": prefs.userId,
          "mwId": mwID,
        }),
      );
      log('START TIME  :: END GET SCRIP ${DateTime.now()}');
      log("GET SCRIP RES ::: STATUS CODE ::: ${res.statusCode} BODY ::: ${res.body}");

      List<Scrip> scripList = [];

      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        if (json['status'].toString().toUpperCase() == "OK") {
          json['mwId'] = mwID;
          json['mwName'] = mwname;
          scripList = MarketWatchScrips.fromJson(json as Map<String, dynamic>)
              .scrips!
              .toList();
        }
      }

      return scripList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  

  Future<bool> deleteScrip(
    BuildContext context,
    MarketWatchAddScripsInput input,
    Ref ref,
  ) async {
    try {
      final uri = Uri.parse(apiLinks.deleteMWScrips);
      log('START TIME  :: DELETE SCRIP ${DateTime.now()}');
      log("DELETE SCRIP JSON ::: ${jsonEncode(input.toJson())}");
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('END TIME  :: DELETE SCRIP ${DateTime.now()}');
      log("DELETE SCRIP RES ::: STATUS CODE ::: ${res.statusCode} BODY :: ${res.body}");

      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        return ((json['status'] ?? '').toString().toUpperCase() == "OK");
      }

      return false;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Scrip>> addScrip(
    MarketWatchAddScripsInput input,
    BuildContext context,
    Ref ref,
  ) async {
    try {
      final uri = Uri.parse(apiLinks.addScripMW);
      log('START TIME  :: ADD SCRIP ${DateTime.now()}');
      log('ADD SCRIP JSON :::  ${jsonEncode(input.toJson())}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('START TIME  :: END ADD SCRIP ${DateTime.now()}');
      log("ADD SCRIPS RES ::: STATUS CODE ::: ${res.statusCode} BODY :: ${res.body}");

      List<Scrip> addScrip = [];

      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        if ((json['status'] ?? '').toString().toLowerCase() == 'ok' &&
            json['result'] != null) {
          for (var item in json['result']) {
            addScrip.add(Scrip.fromJson(item as Map<String, dynamic>));
          }
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(
              json['message'] ?? "something went Wrong".toString()));
        }
      }

      return addScrip;
    } catch (e) {
      log("FAILED ADD SCRIP ${e.toString()}");
      rethrow;
    }
  }

  Future<ContractInfoRes?> getContractInfo({
    required GetContractInfoInput Input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.getContractInfo);
      log("GET CONTRACT INFO INPUT JSON ::: ${jsonEncode(Input)}");
      log('START TIME  :: GET CONTRACT INFO ${DateTime.now()}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: json.encode(Input.toJson()),
      );
      log('START TIME  :: END MW NAME ${DateTime.now()}');
      log("GET CONTRACT :::: STATUS CODE :: ${res.statusCode} BODY ::: ${res.body}");
      ContractInfoRes? getContractInfo;

      if(await checkSessionValidate(context: context, response: res, ref: ref)){
        final json = jsonDecode(res.body);
        getContractInfo = ContractInfoRes.fromJson(json);
      }
      
      return getContractInfo;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<SecurityInfo?> getSecurityInfoDetails({
    required SecurityInfoInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.getSecurityInfo);
      log("START TIME ::: SECURITY INFO ${DateTime.now()}");
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(
          input.toJson(),
        ),
      );
      log("START TIME ::: END TIME SECURITY INFO ${DateTime.now()}");
      log("JSON Response of Security Details ===> ${res.body}");

      SecurityInfo? _data;

      if(await checkSessionValidate(context: context, response: res, ref: ref)){
        final json = jsonDecode(res.body);
        _data = SecurityInfo.fromJson(json);
      }

      return _data;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to update Marketwatch Name
  /// 
  /// 
  /// 
  
  Future<bool> updateMwName(
    MarketWatchNameUpdateInput input,
    BuildContext context,
    Ref ref,
  ) async {
    try {
      final uri = Uri.parse(apiLinks.renameMW);
      log('START TIME  :: UPDATE MW NAME ${DateTime.now()}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('START TIME  :: END UPDATE MW NAME ${DateTime.now()}');
      log("RENAME MW RES :::: ${res.body}");

      if(await checkSessionValidate(context: context, response: res, ref: ref)){
        final json = jsonDecode(res.body);
        return ((json['status'] ?? '').toString().toUpperCase() == "OK");
      }

      return false;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  /// Method to sort order list save
  /// 
  /// 
  /// 
  
  Future<String> sortMwListOrder(
      {required SortMWListOrder input, required BuildContext context,required Ref ref,}) async {
    try {
      final uri = Uri.parse(apiLinks.sortMWOrder);
      log('START TIME  :: SORT MW LIST ORDER ${DateTime.now()}');
      log('SORT MW LIST ORDER JSON :::  ${jsonEncode(input.toJson())}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('START TIME  :: END SORT MW LIST ORDER ${DateTime.now()}');
      log("SORT MW RES :::: ${res.body}");
      String status = 'failed';
      
      if(await checkSessionValidate(context: context, response: res, ref: ref)){
        final json = jsonDecode(res.body);
        status = json['status'].toString().toUpperCase() == "OK"
            ? 'success'
            : 'failed';
      }
      return status;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<SearchScripData>> fetchSearchScrip({
    required String symbol,
    required BuildContext context,
    required List<String> exchangeItems,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.searchScripList);
      log("SEARCH SCRIP URL ::: ${uri}");
      log("RES SEARCH JSON ::${symbol}");
      log('START TIME SEARCH ::  ${DateTime.now()}');
      final res = await apiClient.post(uri,
          headers: authHeaders,
          body: jsonEncode({
            "symbol": symbol.toUpperCase(),
            "exchange": exchangeItems,
          }));
      log('END TIME SEARCH::  ${DateTime.now()}');
      log("RES SERACH SCRIP::${res.body}");
      final List<SearchScripData> _data = [];
      if (res.statusCode == 401 || res.body == 'Unauthorized') {
      } else if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        for (final item in json["result"] ?? []) {
          _data.add(SearchScripData.fromJson(item as Map<String, dynamic>));
        }
      }

      return _data;
    } catch (e) {
      rethrow;
    }
  }

  // Future<bool> deleteScrip(
  //   BuildContext context,
  //   MarketWatchAddScripsInput input,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.deleteMWScrips);
  //     log('START TIME  :: DELETE SCRIP ${DateTime.now()}');
  //     log("DELETE SCRIP JSON ::: ${jsonEncode(input.toJson())}");
  //     final res = await apiClient.post(
  //       uri,
  //       headers: authHeaders,
  //       body: jsonEncode(input.toJson()),
  //     );
  //     log('END TIME  :: DELETE SCRIP ${DateTime.now()}');
  //     log("DELETE SCRIP RES ::: STATUS CODE ::: ${res.statusCode} BODY :: ${res.body}");

  //     if (await checkSessionValidate(
  //         context: context, response: res, ref: ref)) {
  //       final json = jsonDecode(res.body);
  //       return ((json['status'] ?? '').toString().toUpperCase() == "OK");
  //     }

  //     return false;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<List<Scrip>> getScrips(
  //   String mwID,
  //   BuildContext context,
  //   Reader ref,
  //   String mwname,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.fetchMWScrips);
  //     log('START TIME  :: GET SCRIP ${DateTime.now()}');
  //     log("GET SCRIP JSON :: ${jsonEncode({
  //           "userId": prefs.userId,
  //           "mwId": mwID
  //         })}");
  //     final res = await apiClient.post(
  //       uri,
  //       headers: authHeaders,
  //       body: jsonEncode({
  //         "userId": prefs.userId,
  //         "mwId": mwID,
  //       }),
  //     );
  //     log('START TIME  :: END GET SCRIP ${DateTime.now()}');
  //     log("GET SCRIP RES ::: STATUS CODE ::: ${res.statusCode} BODY ::: ${res.body}");

  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(
  //         context: context,
  //       );
  //     } else if (res.statusCode != 200) {
  //       // ref(userProvider).sessionLogout(context: context);
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //     } else {
  //       final json = jsonDecode(res.body);
  //       if (json['status'].toString().toUpperCase() == "OK") {
  //         json['mwId'] = mwID;
  //         json['mwName'] = mwname;
  //         final resp = MarketWatchScrips.fromJson(json as Map<String, dynamic>)
  //             .scrips!
  //             .toList();
  //         return resp;
  //       } else {
  //         return [];
  //       }
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return [];
  // }

  // Future<bool> updateMwName(
  //   MarketWatchNameUpdateInput input,
  //   BuildContext context,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.renameMW);
  //     log('START TIME  :: UPDATE MW NAME ${DateTime.now()}');
  //     final res = await apiClient.post(
  //       uri,
  //       headers: authHeaders,
  //       body: jsonEncode(input.toJson()),
  //     );
  //     log('START TIME  :: END UPDATE MW NAME ${DateTime.now()}');
  //     log("RENAME MW RES :::: ${res.body}");
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     } else if (res.statusCode != 200) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //       return false;
  //     } else if (res.statusCode == 200) {
  //       final json = jsonDecode(res.body);
  //       if ((json['emsg'] ?? '') == 'Session Expired') {
  //         ref(userProvider).sessionLogout(context: context);
  //       }
  //       return ((json['status'] ?? '').toString().toUpperCase() == "OK");
  //     }

  //     return false;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<String> sortMwListOrder(
  //     SortMWListOrder input, BuildContext context) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.sortMWOrder);
  //     log('START TIME  :: SORT MW LIST ORDER ${DateTime.now()}');
  //     log('SORT MW LIST ORDER JSON :::  ${jsonEncode(input.toJson())}');
  //     final res = await apiClient.post(
  //       uri,
  //       headers: authHeaders,
  //       body: jsonEncode(input.toJson()),
  //     );
  //     log('START TIME  :: END SORT MW LIST ORDER ${DateTime.now()}');
  //     log("SORT MW RES :::: ${res.body}");
  //     String status = '';
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       status = 'Session Expired';
  //       return status;
  //     } else if (res.statusCode != 200) {
  //       status = 'Something went wrong';
  //       return status;
  //     } else if (res.statusCode == 200) {
  //       final json = jsonDecode(res.body);
  //       try {
  //         if (json['emsg'] == 'Session Expired') {
  //           status = 'Session Expired';
  //           return status;
  //         }
  //       } catch (e) {
  //         // ignore: invariant_booleans
  //       }
  //       status = json['status'].toString().toUpperCase() == "OK"
  //           ? 'success'
  //           : 'failed';
  //     }
  //     log("CREATE MW RES :::: ${res.body}");
  //     return status;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<bool> createAlert(
  //   CreateAlert input,
  //   BuildContext context,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.createAlert);
  //     log('START TIME  :: CREATE ALERT ${DateTime.now()}');
  //     log("CREATE ALERT JSON ::${jsonEncode(input)}");
  //     final res = await apiClient.post(
  //       uri,
  //       headers: basicAuthHeaders,
  //       body: jsonEncode(input.toJson()),
  //     );
  //     log('START TIME  :: END CREATE ALERT ${DateTime.now()}');
  //     log("RES CREATE ALERT ::${res.body}");
  //     bool isAlertCreated = false;
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     } else if (res.statusCode != 200) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //     } else {
  //       final json = jsonDecode(res.body);
  //       if ((json['status'] ?? '') != 'Ok') {
  //         ScaffoldMessenger.of(context).clearSnackBars();
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(errorSnackBar(json['message']));
  //       } else {
  //         isAlertCreated = ((json['status'] ?? '').toString() == 'Ok' &&
  //             (json['message'] ?? '').toString() == 'Success');
  //       }
  //     }

  //     return isAlertCreated;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<bool> updateAlert(
  //   UpdateAlert input,
  //   BuildContext context,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.updateAlert);
  //     log('START TIME  :: UPDATE ALERT ${DateTime.now()}');
  //     log("EDIT ALERT JSON ::: ${jsonEncode(input.toJson())}");
  //     final res = await apiClient.post(
  //       uri,
  //       headers: authHeaders,
  //       body: jsonEncode(input.toJson()),
  //     );
  //     log('START TIME  :: END UPDATE ALERT ${DateTime.now()}');
  //     log("RES UPDATE ALERT ::${res.body}");
  //     bool isAlertUpdated = false;
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     } else if (res.statusCode != 200) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //     } else {
  //       final json = jsonDecode(res.body);
  //       if ((json['status'] ?? '').toString().toLowerCase() != 'ok') {
  //         ScaffoldMessenger.of(context).clearSnackBars();
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(errorSnackBar(json['message']));
  //       } else {
  //         isAlertUpdated = ((json['status'] ?? '').toString().toLowerCase() ==
  //                 'ok' &&
  //             (json['message'] ?? '').toString().toLowerCase() == 'success');
  //       }
  //     }
  //     return isAlertUpdated;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<bool> deleteAlert(
  //   int alertId,
  //   BuildContext context,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse("${apiLinks.deleteAlert}${alertId}");
  //     log('START TIME  :: DELETE ALERT ${DateTime.now()}');
  //     log("DELETE ALERT JSON ::: ${jsonEncode({
  //           'alertId': alertId,
  //         })}$uri");
  //     final res = await apiClient.delete(
  //       uri,
  //       headers: authHeaders,
  //     );
  //     log('START TIME  :: END DELETE ALERT ${DateTime.now()}');
  //     log("RES DELETE ALERT ::${res.body}");
  //     bool isAlertDeleted = false;
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     } else if (res.statusCode != 200) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //     } else {
  //       final json = jsonDecode(res.body);
  //       if (json['status'] != 'Ok') {
  //         ScaffoldMessenger.of(context).clearSnackBars();
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(errorSnackBar(json['message']));
  //         Navigator.pop(context);
  //       } else {
  //         isAlertDeleted = ((json['status'] ?? '') == 'Ok' &&
  //             (json['message'] ?? '') == 'Success');
  //       }
  //     }

  //     return isAlertDeleted;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<GetAllAlertRes?> getAllAlert(
  //   String userId,
  //   BuildContext context,
  //   Reader ref,
  // ) async {
  //   try {
  //     final uri = Uri.parse(apiLinks.getAllAlert);
  //     log('START TIME  :: GET ALL ALERT ${DateTime.now()}');
  //     final res = await apiClient.get(
  //       uri,
  //       headers: authHeaders,
  //       // body: jsonEncode({
  //       //   'userId': userId,
  //       // }),
  //     );
  //     log('START TIME  :: END GET ALL ALERT ${DateTime.now()}');
  //     log("RES GET ALL ALERT ::${res.body}");
  //     if (res.statusCode == 401 || res.body == 'Unauthorized') {
  //       ref(userProvider).sessionLogout(context: context);
  //     } else if (res.statusCode != 200) {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(errorSnackBar('Something went wrong'));
  //     } else {
  //       final json = jsonDecode(res.body);
  //       if ((json['stat'] ?? '') != 'not_Ok') {
  //         return GetAllAlertRes.fromJson(json);
  //       } else {
  //         return null;
  //       }
  //     }

  //     return null;
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
}
