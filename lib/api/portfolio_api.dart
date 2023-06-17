import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/holding_book_model.dart';
import '../model/position_book_model.dart';
import '../shared_widget/snack_bar.dart';
import 'core/api_core.dart';

mixin PortfolioApi on ApiCore {
  Future<PositionBookInfo?> fetchPositions({
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.getPositions);
      log('START TIME  :: POSITIONS ${DateTime.now()}');
      final response = await apiClient.get(
        uri,
        headers: authHeaders,
      );
      log("POSITIONS RES :: STATUS CODE ::: ${response.statusCode} ::: BODY ::: ${response.body}");
      PositionBookInfo? positionBookInfo;
      if (await checkSessionValidate(
        context: context,
        response: response,
        ref: ref,
      )) {
        final json = jsonDecode(response.body);
        positionBookInfo = PositionBookInfo.fromJson(json);
      }
      return positionBookInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<HoldingBookInfo?> fetchHoldings({
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.getHoldings);
      log('START TIME  :: UPDATE ALERT ${DateTime.now()}');
      final response = await apiClient.get(
        uri,
        headers: authHeaders,
      );
      log("HOLDINGS :: STATUS CODE ::: ${response.statusCode} BODY :::${response.body}");
      HoldingBookInfo? holdingBookInfo;
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        holdingBookInfo = HoldingBookInfo.fromJson(json);
      }
      return holdingBookInfo;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to position convert
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [PositionConvertInput] return [bool]

  Future<bool> convertPosition({
    required PositionConvertInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.positionConvert);
      log('START TIME  :: POSITION CONVERT ${DateTime.now()}');
      log("POSITION CONVERT JSON :: ${input.toJson()}");
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log("POSITION CONVERT RES :: STATUS CODE ::: ${res.statusCode} ::: BODY ::: ${res.body}");
      if (await checkSessionValidate(
          context: context, response: res, ref: ref)) {
        final json = jsonDecode(res.body);
        if (((json['status'] ?? '').toString().toLowerCase() == 'ok') &&
            ((json['message'] ?? '').toString().toLowerCase() == 'success')) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(successSnackbar("Position converted successfully"));
          return true;
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar("${json['message']}"));
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Method to position square off
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// Given input is [List<Map<String, dynamic>>] return [String]

  Future<String?> positionSquOff({
    required List<Map<String, dynamic>> input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.positionSquareOff);
      log("POSITION SQUARE OFF JSON ::: ${jsonEncode(input)}");
      log('START TIME  :: POSITION SQUARE OFF ${DateTime.now()}');
      final response = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input),
      );
      log("POSITION SQUARE OFF RES :: STATUS CODE ::: ${response.statusCode} ::: BODY ::: ${response.body}");
      if (await checkSessionValidate(
          context: context, response: response, ref: ref)) {
        final json = jsonDecode(response.body);
        List<String> successOrderNo = [];
        for (var element in json) {
          if ((element['status'] ?? '').toString().toLowerCase() == 'ok' &&
              (element['message'] ?? '').toString().toLowerCase() ==
                  'success' &&
              element['result'] != null) {
            var successInfo = element['result'];
            successOrderNo.add(successInfo[0]['orderNo']);
          }
        }
        if (successOrderNo.length == input.length) {
          return "success";
        } else if (successOrderNo.isNotEmpty) {
          return "partial";
        } else {
          return "error";
        }
      }
      return "error";
    } catch (e) {}
    return null;
  }
}
