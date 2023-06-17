import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/get_user_preference_model.dart';
import '../model/service_error_json_model.dart';
import '../model/user_profile_model.dart';
import '../shared_widget/snack_bar.dart';
import 'core/api_core.dart';

mixin SettingsApi on ApiCore {
  /// Method to get User Profile
  ///
  /// throws an error of [rethrow] if service get's error or otherwise gets [Null] error
  /// return [ProfileRes]

  Future<ProfileRes?> getProfile({
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.getProfile);
      log('START TIME  :: PROFILE ${DateTime.now()}');
      log("PROFILE :::: INPUT :: ${authHeaders}");
      final res = await apiClient.get(
        uri,
        headers: authHeaders,
      );
      log('START TIME  :: END PROFILE ${DateTime.now()}');
      log("PROFILE :::: STATUS CODE :: ${res.statusCode} BODY ::: ${res.body}");

      ProfileRes? profileRes;

      if (res.statusCode == 401 || res.body == 'Unauthorized') {
        ErrorJson errorJson = ErrorJson(
          errorMessage: 'unauthourized',
          stat: 'not_ok',
        );
        return ProfileRes.fromJson(errorJson.toErrorFormatJson());
      } else if (res.statusCode != 200) {
        ErrorJson errorJson = ErrorJson(
          errorMessage: 'Something went wrong',
          stat: 'not_ok',
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackBar('Something went wrong'));
        return ProfileRes.fromJson(errorJson.toErrorFormatJson());
      } else if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        profileRes = ProfileRes.fromJson(json);
      }

      return profileRes;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Method to update User Preference
  ///
  ///

  Future<GetUserPref?> updateUserPreference({
    required UpdatePrefInput input,
    required BuildContext context,
    required Ref ref,
  }) async {
    try {
      final uri = Uri.parse(apiLinks.updatePreference);
      log("UPDATE USER PREFERNCE INPUT JSON ::: ${jsonEncode(input)}");
      log('START TIME  :: UPDATE USER PREFERNCE ${DateTime.now()}');
      final res = await apiClient.post(
        uri,
        headers: authHeaders,
        body: jsonEncode(input.toJson()),
      );
      log('START TIME  :: END UPDATE USER PREFERNCE ${DateTime.now()}');
      log("UPDATE USER PREFERNCE :::: STATUS CODE :: ${res.statusCode} BODY ::: ${res.body}");

      GetUserPref? getUserPref;

      if(await checkSessionValidate(context: context, response: res, ref: ref)){
        final json = jsonDecode(res.body);
        getUserPref = GetUserPref.fromJson(json);
      }
      
      return getUserPref;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
