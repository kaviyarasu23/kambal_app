import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/preferences.dart';
import '../locator/locator.dart';
import 'theme_provider.dart';

final cleverTapNotificationProvider =
    ChangeNotifierProvider((ref) => CleverTapNotificationProvide(
          ref,
          locator<Preferences>(),
        ));

class CleverTapNotificationProvide extends ChangeNotifier {
  CleverTapNotificationProvide(
    this.ref,
    this.pref,
  );

  final Preferences pref;
  final Ref ref;

  late CleverTapPlugin _clevertapPlugin;
  var inboxInitialized = false;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;
  static const platform = MethodChannel("myChannel");

  void cleverTapInitialize() {
    try {
      log("CLEVER TAP INITILIZE");
      _clevertapPlugin = CleverTapPlugin();
      CleverTapPlugin.setDebugLevel(3);
      CleverTapPlugin.createNotificationChannel(
        "alice_notification",
        "alice_notification",
        "alice_notification",
        3,
        true,
      );

      _clevertapPlugin
          .setCleverTapPushAmpPayloadReceivedHandler(pushAmpPayloadReceived);
      _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(
          pushClickedPayloadReceived);
      _clevertapPlugin.setCleverTapInAppNotificationDismissedHandler(
          inAppNotificationDismissed);
      _clevertapPlugin
          .setCleverTapProfileDidInitializeHandler(profileDidInitialize);
      _clevertapPlugin.setCleverTapProfileSyncHandler(profileDidUpdate);
      _clevertapPlugin
          .setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
      _clevertapPlugin
          .setCleverTapInboxMessagesDidUpdateHandler(inboxMessagesDidUpdate);
      _clevertapPlugin
          .setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
      _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(
          inAppNotificationButtonClicked);
      _clevertapPlugin.setCleverTapInboxNotificationButtonClickedHandler(
          inboxNotificationButtonClicked);
      // _clevertapPlugin.setCleverTapInboxNotificationMessageClickedHandler(
      //     inboxNotificationMessageClicked);
      _clevertapPlugin
          .setCleverTapFeatureFlagUpdatedHandler(featureFlagsUpdated);
      _clevertapPlugin.setCleverTapProductConfigInitializedHandler(
          productConfigInitialized);
      _clevertapPlugin
          .setCleverTapProductConfigFetchedHandler(productConfigFetched);
      _clevertapPlugin
          .setCleverTapProductConfigActivatedHandler(productConfigActivated);
      CleverTapPlugin.initializeInbox();
      CleverTapPlugin.setPushToken("${pref.fcmToken}");
      CleverTapPlugin.setBaiduPushToken("${pref.fcmToken}");
      CleverTapPlugin.setHuaweiPushToken("${pref.fcmToken}");
      CleverTapPlugin.setXiaomiPushToken("${pref.fcmToken}", 'in');
      platform.setMethodCallHandler(nativeMethodCallHandler);
      if (Platform.isIOS) {
        CleverTapPlugin.registerForPush();
      }
      // Fluttertoast.showToast(msg: 'CleverTap initilize success',backgroundColor: Colors.green);
    } catch (e) {
      // Fluttertoast.showToast(msg: 'CleverTap initilize issue :: $e',backgroundColor: Colors.red);
      log("CleverTap initilize issue :: $e");
    }
  }

  void inAppNotificationDismissed(Map<String, dynamic> map) {
    log("inAppNotificationDismissed called");
  }

  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    log("inAppNotificationButtonClicked called = ${map.toString()}");
  }

  void inboxNotificationButtonClicked(Map<String, dynamic>? map) {
    log("inboxNotificationButtonClicked called = ${map.toString()}");
  }

  void inboxNotificationMessageClicked(Map<String, dynamic>? map) {
    log("inboxNotificationMessageClicked called = ${map.toString()}");
  }

  void profileDidInitialize() {
    log("profileDidInitialize called");
  }

  void profileDidUpdate(Map<String, dynamic>? map) {
    log("profileDidUpdate called");
  }

  void inboxDidInitialize() {
    log("inboxDidInitialize called");
    inboxInitialized = true;
    notifyListeners();
  }

  void showInbox() {
    if (inboxInitialized) {
      var styleConfig = {
        'noMessageTextColor': '#ff6600',
        'noMessageText': 'No message(s) to show.',
        'navBarTitle': 'Notifications',
        'navBarTitleColor': '#101727',
        'navBarColor':
            ref.read(themeProvider).isDarkMode ? '#181818' : '#F6F6F6',
      };
      CleverTapPlugin.showInbox(styleConfig);
    }
  }

  Future<void> inboxMessagesDidUpdate() async {
    log("inboxMessagesDidUpdate called");
    int? unread = await CleverTapPlugin.getInboxMessageUnreadCount();
    int? total = await CleverTapPlugin.getInboxMessageCount();
    log("Unread count = $unread");
    log("Total count = $total");
  }

  Future<void> onDisplayUnitsLoaded(List<dynamic>? displayUnits) async {
    List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();
    log("Display Units = $displayUnits");
  }

  Future<void> featureFlagsUpdated() async {
    log("Feature Flags Updated");
    bool? booleanVar = await CleverTapPlugin.getFeatureFlag("BoolKey", false);
    log("Feature flag = $booleanVar");
  }

  Future<void> productConfigInitialized() async {
    log("Product Config Initialized");
    await CleverTapPlugin.fetch();
  }

  Future<void> productConfigFetched() async {
    log("Product Config Fetched");
    await CleverTapPlugin.activate();
  }

  Future<void> productConfigActivated() async {
    log("Product Config Activated");
    String? stringvar =
        await CleverTapPlugin.getProductConfigString("StringKey");
    log("PC String = $stringvar");
    int? intvar = await CleverTapPlugin.getProductConfigLong("IntKey");
    log("PC int = $intvar");
    double? doublevar =
        await CleverTapPlugin.getProductConfigDouble("DoubleKey");
    log("PC double = $doublevar");
  }

  void pushAmpPayloadReceived(Map<String, dynamic> map) {
    log("pushAmpPayloadReceived called");
    var data = jsonEncode(map);
    log("Push Amp Payload = $data");
    CleverTapPlugin.createNotification(data);
  }

  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    log("pushClickedPayloadReceived called");
    var data = jsonEncode(map);
    log("on Push Click Payload = $data");
    // markAsReadNotification();
  }

  void showInboxWithTabs() {
    if (inboxInitialized) {
      var styleConfig = {
        'noMessageTextColor': '#ff6600',
        'noMessageText': 'No message(s) to show.',
        'navBarTitle': 'Notification',
        'navBarTitleColor': '#101727',
        'navBarColor':
            ref.read(themeProvider).isDarkMode ? '#181818' : '#F6F6F6',
        'tabs': ["promos", "offers"],
      };
      CleverTapPlugin.showInbox(styleConfig);
    }
  }

  Future<void> markAsReadNotification() async {
    var messageList = await CleverTapPlugin.getUnreadInboxMessages();
    if (messageList == null || messageList.isEmpty) return;
    Map<dynamic, dynamic> itemFirst = messageList[0];
    if (Platform.isAndroid) {
      await CleverTapPlugin.markReadInboxMessageForId(itemFirst["id"]);
    } else if (Platform.isIOS) {
      await CleverTapPlugin.markReadInboxMessageForId(itemFirst["_id"]);
    }
  }

  Future<void> saveInbox() async {
    // await CleverTapPlugin.pushInboxNotificationClickedEventForId(messageId);
  }

  //For Push Notification Clicked Payload in killed state
  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    debugPrint("killed state called!");
    switch (methodCall.method) {
      case "onPushNotificationClicked":
        debugPrint("onPushNotificationClicked in dart");
        debugPrint("Clicked Payload in Killed state: ${methodCall.arguments}");
        return "This is from android!!";
      default:
        return "Nothing";
    }
  }

  // clever Tap

  // void recordUser() {
  //   try {
  //     final DateFormat formatter = DateFormat('dd-MM-yyyy');
  //     final ProfileResult? profileData =
  //         ref.read(settingsProvider).getProfileRes?.result[0];
  //     final String formatted = formatter.format(DateFormat('MM/dd/yy').parse(
  //         "${ref(settingsProvider).getProfileRes?.result[0]!.dpAccountNumber}"));
  //     var profile = {
  //       'Name': '${pref.userName}',
  //       'Identity': '${pref.userId}',
  //       'DOB': '${formatted}',

  //       ///Key always has to be "DOB" and format should always be dd-MM-yyyy
  //       'Email': profileData != null ? profileData.email : " ",
  //       'Phone': '+91${profileData!.mobNo}',
  //     };
  //     CleverTapPlugin.onUserLogin(profile);
  //     log("Pushed profile $profile");
  //   } catch (e) {
  //     log("Failed to push login details of client ::: $e");
  //   }
  // }
}
