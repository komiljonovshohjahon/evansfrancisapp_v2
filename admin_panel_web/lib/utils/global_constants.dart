import 'package:flutter/foundation.dart';

class GlobalConstants {
  //Create a singleton
  static final GlobalConstants _instance = GlobalConstants.internal();
  GlobalConstants.internal();
  factory GlobalConstants() => _instance;

  //Add your global constants here
  static const String debugusername = kDebugMode ? "krciadmin@gmail.com" : "";
  //krci@gmail.com
  // "13150519";
  static const String debugpassword = kDebugMode ? "krC1@m1N" : "";

  static bool enableLogger = kDebugMode;

  static const List<int> pageSizes = [50, 100, 250];

  static bool enableDebugCodes = false;
  static bool enableLoadingIndicator = true;
}
