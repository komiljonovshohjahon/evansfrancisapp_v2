// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';

class DependencyManager {
  static final DependencyManager _instance = DependencyManager._internal();

  factory DependencyManager() {
    return _instance;
  }

  DependencyManager._internal();

  static DependencyManager get instance => _instance;

  final GetIt _getIt = GetIt.instance;

  IMCANavigation get navigation => _getIt<IMCANavigation>();

  FirestoreDep get firestore => _getIt<FirestoreDep>();

  FireStorage get fireStorage => _getIt<FireStorage>();

  AppDep get appDep => _getIt<AppDep>();

  //It is run in main.dart
  Future<void> init({required IMCANavigation nav}) async {
    Logger.init(true,
        isShowFile: false, isShowNavigation: false, isShowTime: false);
    //AppDep
    _getIt.registerSingleton<AppDep>(AppDep());
    //AppDep

    //Navigation
    _getIt.registerSingleton<IMCANavigation>(nav);
    //Navigation

    //Firestore
    _getIt.registerSingleton<FirestoreDep>(FirestoreDep());
    //Firestore

    //FireStorage
    _getIt.registerSingleton<FireStorage>(FireStorage());
    //FireStorage
  }
}
