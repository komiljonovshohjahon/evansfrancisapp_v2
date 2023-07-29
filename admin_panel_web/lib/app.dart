import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RunnerApp extends StatefulWidget {
  const RunnerApp({super.key});

  @override
  State<RunnerApp> createState() => _RunnerAppState();
}

class _RunnerAppState extends State<RunnerApp> {
  final DependencyManager _dependencyManager = DependencyManager();

  // Restart the app
  void restart() {
    debugPrint("REBUIL APP from RUNNER");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dependencyManager.appDep.restart = restart;
  }

  final botToastBuilder = BotToastInit(); //1. call BotToastInit

  @override
  Widget build(BuildContext context) {
    print("rebuild app");
    final router = _dependencyManager.navigation.router;
    return MaterialApp.router(
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
      ),
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
      ),

      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.light,
      title: 'MCA Dashboard',
      builder: (context, child) => botToastBuilder(
          context,
          MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!)),
    );
  }
}
