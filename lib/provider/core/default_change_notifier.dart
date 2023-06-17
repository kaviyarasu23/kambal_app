import 'package:flutter/material.dart';

abstract class DefaultChangeNotifier extends ChangeNotifier {
  bool loading = false;

  void toggleLoadingOn(bool on) {
    loading = on;
    notifyListeners();
  }
}
