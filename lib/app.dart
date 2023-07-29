import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class RunnerApp extends StatefulWidget {
  const RunnerApp({super.key});

  @override
  State<RunnerApp> createState() => _RunnerAppState();
}

class _RunnerAppState extends State<RunnerApp> {
  final DependencyManager _dependencyManager = DependencyManager();

  final botToastBuilder = BotToastInit();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen(firebaseMessagingHandler);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!(!kIsWeb && Platform.isLinux)) {
        final pending = await NotificationService()
            .notificationsPlugin
            .getNotificationAppLaunchDetails();
        final bool didNotificationLaunchApp =
            pending?.didNotificationLaunchApp ?? false;
        final notificationResponse = pending?.notificationResponse;
        bool shouldMoveToRoute = false;
        if (didNotificationLaunchApp &&
            notificationResponse != null &&
            notificationResponse.payload != null &&
            notificationResponse.payload!.isNotEmpty) {
          shouldMoveToRoute = true;
        }
        if (shouldMoveToRoute) {
          onBgNotificationResponse(pending!.notificationResponse!);
        }
      }
    });
  }

  //1. call BotToastInit
  @override
  Widget build(BuildContext context) {
    final router = _dependencyManager.navigation.router;
    return ScreenUtilInit(
      designSize: const Size(720, 1080),
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: kDebugMode,
        title: 'Evans Francis',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAF8F1),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFFFAF8F1),
            foregroundColor: Color(0xFF3A3A3A),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8C6924),
            secondary: Color(0xFF3A3A3A),
            tertiary: Color(0xFFB9BCBE),
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        builder: (context, child) => botToastBuilder(
          context,
          MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        ),
      ),
    );
  }
}
