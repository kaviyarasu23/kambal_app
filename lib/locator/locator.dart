
import 'package:get_it/get_it.dart';

import '../api/core/api_exporter.dart';
import '../api/core/api_links.dart';
import '../global/device_info.dart';
import '../global/firebase_message.dart';
import '../global/preferences.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Preferences());
  locator.registerLazySingleton(() => FirebaseMessage());
  locator.registerLazySingleton(() => ApiLinks());
  locator.registerLazySingleton(() => ApiExporter());
  locator.registerLazySingleton(() => DeviceInformation());
}
