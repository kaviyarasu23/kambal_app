import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/core/api_exporter.dart';
import '../global/preferences.dart';
import '../locator/locator.dart';
import '../model/market_depth_model.dart';
import 'core/default_change_notifier.dart';

final marketDepthProvider = ChangeNotifierProvider((ref) => MarketDepthProvider(
      ref,
      locator<Preferences>(),
      locator<ApiExporter>(),
    ));

class MarketDepthProvider extends DefaultChangeNotifier {
  MarketDepthProvider(
    this.ref,
    this.pref,
    this.api,
  );

  final Preferences pref;
  final ApiExporter api;
  final Ref ref;

  MDdata? depthValue;
  MDdata? get getDepth => depthValue;

  /// Method to set initial depth value
  ///
  ///
  ///

  void setDepth({required MDdata data}) {
    depthValue = data;
    notifyListeners();
  }
}