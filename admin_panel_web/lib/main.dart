import 'package:admin_panel_web/manager/routes.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dependency_plugin/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel_web/app.dart';

///ADMIN PANEL WEB
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  Logger.init(true);

  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
  //     Logger.i("Firestore emulator connected");
  //   } catch (e) {
  //     // ignore: avoid_print
  //     Logger.e("Firestore emulator connection failed: $e");
  //   }
  // }

  EquatableConfig.stringify = true;

  runApp(const RunnerApp());
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init(nav: MCANavigation());
}
