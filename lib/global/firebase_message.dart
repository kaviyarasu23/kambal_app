import 'dart:developer';

import 'package:aliceblue/global/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../locator/locator.dart';

class FirebaseMessage {
  final pref = locator<Preferences>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken;
  Future<void> getFcmToken() async {
    fcmToken ??= await _firebaseMessaging.getToken();
    log('Firebase Message Token::::: $fcmToken');
    pref.setFCMToken(fcmToken!);
  }
}