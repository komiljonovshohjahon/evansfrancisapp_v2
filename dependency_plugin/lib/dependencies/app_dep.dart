import 'package:flutter/cupertino.dart';

class AppDep {
  //create singleton
  static final AppDep _singleton = AppDep._internal();

  //create factory constructor
  factory AppDep() {
    return _singleton;
  }

  //create private constructor
  AppDep._internal();

  //create getter for singleton
  static AppDep get instance => _singleton;

  /// runs setState of the MaterialApp
  VoidCallback? restart;
}
