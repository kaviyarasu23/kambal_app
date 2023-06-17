import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStateProvider =
    ChangeNotifierProvider((ref) => NetworkStateProvider(ref));

class NetworkStateProvider extends ChangeNotifier {
  NetworkStateProvider(this.ref);
  final Ref ref;
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  late StreamController<bool> connectivityAvailable =
      StreamController.broadcast();

  void checkConnection() {
    initConnectivity();
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    if (connectionStatus.name.toString() != "none") {
      connectivityAvailable.add(true);
    } else {
      connectivityAvailable.add(false);
    }
    notifyListeners();
    // log("Connection Status ::: ${connectionStatus.name}");
  }

  bool checkInitialCheck() {
    log("Connection Status ::: ${connectionStatus.name}");
    if (connectionStatus.name.toString() != "none") {
      return true;
    } else {
      return false;
    }
  }
}
