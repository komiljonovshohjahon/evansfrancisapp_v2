import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:evansfrancisapp/manager/manager.dart';
import 'package:evansfrancisapp/utils/global_functions.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
        theme: FlexThemeData.light(
          scheme: FlexScheme.redWine,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
            appBarBackgroundSchemeColor: SchemeColor.primary,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ).copyWith(
            scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: MaterialStatePropertyAll(true),
          trackVisibility: MaterialStatePropertyAll(true),
        )),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.redWine,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 13,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            useTextTheme: true,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ).copyWith(
            scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: MaterialStatePropertyAll(true),
          trackVisibility: MaterialStatePropertyAll(true),
        )),

        // Use dark or light theme based on system setting.
        themeMode: ThemeMode.light,
        title: 'KRCI',
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
