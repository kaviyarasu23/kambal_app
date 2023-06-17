import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../../global/preferences.dart';
import '../../locator/locator.dart';
import '../../provider/user_provider.dart';
import '../../res/res.dart';
import 'api_links.dart';

class ApiCore {
  final apiClient = Client();
  final prefs = locator<Preferences>();
  final apiLinks = locator<ApiLinks>();

  // Basic Header

  Map<String, String> get defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Accept': 'application/json',
    };
  }

  // Auth Header

  Map<String, String> get authHeaders {
    return {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': 'Bearer ${prefs.sessionId}',
      'Accept': 'application/json',
    };
  }

  // FCM Header

  Map<String, String> get fcmHeaders {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'key=${ApiLinks.fcmServerKey}'
    };
  }

  // local Auth Header

  Map<String, String> get localAuthHeaders {
    return {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.userId} MOB ${prefs.locaSessionId}',
    };
  }

  /// Method to check if the service is valid or not
  ///
  ///

  Future<bool> checkSessionValidate({
    required BuildContext context,
    required Response response,
    required Ref ref,
  }) async {
    try {
      bool isValidService = false;
      if (response.statusCode == 401 ||
          response.body.toString().toLowerCase() == "unauthorized" ||
          response.body.toString().toLowerCase() == "session expired") {
        ref.read(userProvider).sessionLogout(context: context);
      } else if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: 'Something went wrong',
          backgroundColor: colors.kColorRed,
        );
      } else {
        isValidService = true;
      }
      return isValidService;
    } catch (e) {
      log("Failed to check session from ::: $e");
    }
    return false;
  }

  void dispose() {
    apiClient.close();
  }
}
