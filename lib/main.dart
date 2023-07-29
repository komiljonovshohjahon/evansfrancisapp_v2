import 'dart:convert';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dependency_plugin/firebase_options.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:evansfrancisapp/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void onBgNotificationResponse(NotificationResponse message) {
  try {
    final payload = jsonDecode(message.payload ?? "{}");
    final route = payload["route"];
    if (route != null) {
      DependencyManager.instance.navigation.router
          .go("${MCANavigation.home}/$route", extra: payload);
    }
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  final payload = jsonEncode(message.data);

  String title = "Notification Received";

  if (message.data['title'] != null) {
    title = "New ${message.data['title']} Available";
  }

  int seconds = 0;

  if (message.data['seconds'] != null) {
    seconds = int.parse(message.data['seconds']);
  }

  String timezone = "Asia/Seoul";

  if (message.data['timezone'] != null) {
    timezone = message.data['timezone'];
  }

  // NotificationService().showNotification(
  //     title: title, body: "Tap to view details", payload: payload);
  NotificationService().scheduleNotification(
    seconds: seconds,
    title: title,
    payLoad: payload,
    timezone: timezone,
    body: "Tap to view details",
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initialize Firebase
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "evansfrancisapp");

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  // await NotificationService().init();
  //
  // ///Request notification permission
  // await FirebaseMessaging.instance.requestPermission().then((permission) {
  //   Logger.d(permission.authorizationStatus.toString(),
  //       tag: "FirebaseMessagingDep init");
  //   switch (permission.authorizationStatus) {
  //     case AuthorizationStatus.authorized:
  //
  //       ///If authorized, subscribe to topic
  //       FirebaseMessaging.instance
  //           .subscribeToTopic("send-scheduled-notifications");
  //       break;
  //     default:
  //       break;
  //   }
  // });
  //
  // ///Listen to background messages
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);

  EquatableConfig.stringify = true;

  runApp(const RunnerApp());
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init(nav: MCANavigation());
}
