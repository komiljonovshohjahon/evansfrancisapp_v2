import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:evansfrancisapp/presentation/global_widgets/widgets.dart';
import 'package:evansfrancisapp/presentation/pages/pages.dart';
import 'package:evansfrancisapp/utils/utils.dart';

class MCANavigation extends IMCANavigation {
  /// Global key for the navigator
  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Route observer
  @override
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // Routes
  ///Root is where we check if the user is logged in or not
  static const String root = '/root';

  ///Login is where the user logs in
  static const String login = '/login';

  ///Register
  static const String register = '/register';

  ///Home page
  static const String home = '/home';

  ///Ministry Dil Kumar
  static const String ministryDilkumar = '/ministryDilkumar';

  ///UAE Youtube
  static const String uaeYt = '/uaeYt';

  ///Daily Devotion
  static const String dailyDevotion = '/dailyDevotion';

  ///Scripture
  static const String scripture = '/scripture';

  ///Create user
  static const String createUser = '/createUser';

  ///Praise report
  static const String praiseReport = '/praiseReport';

  ///Church schedule
  static const String churchSchedule = '/churchSchedule';

  ///prayerRequest
  static const String prayerRequest = '/prayerRequest';

  ///submit praise report
  static const String submitPraiseReport = '/submitPraiseReport';

  ///submit special request
  static const String submitSpecialRequest = '/submitSpecialRequest';

  ///contact church office
  static const String contactChurchOffice = '/contactChurchOffice';

  ///basic
  static const String basic = '/basic';

  ///social media
  static const String socialMedia = '/socialMedia';

  /// router
  @override
  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: loginState,
    navigatorKey: navigatorKey,
    observers: [BotToastNavigatorObserver()],
    routes: [
      GoRoute(
        path: "/",
        name: "root",
        redirect: (state, context) => login,
      ),
      GoRoute(
        path: login,
        name: login.substring(1),
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const LoginPinView(),
          );
        },
      ),
      GoRoute(
        path: createUser,
        name: createUser.substring(1),
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const CreateUserView(),
          );
        },
      ),
      ShellRoute(
          builder: (context, state, child) {
            return DefaultLayout(child: child);
          },
          routes: [
            GoRoute(
              path: home,
              name: home.substring(1),
              routes: [
                GoRoute(
                  path: ministryDilkumar.substring(1),
                  name: ministryDilkumar.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: MinistryDilkumarView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: uaeYt.substring(1),
                  name: uaeYt.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: UaeYtView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: dailyDevotion.substring(1),
                  name: dailyDevotion.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: DailyDevotionView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: scripture.substring(1),
                  name: scripture.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: ScriptureView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: praiseReport.substring(1),
                  name: praiseReport.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: PraiseReportView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: churchSchedule.substring(1),
                  name: churchSchedule.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                    }

                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: ChurchScheduleView(
                          collection: collection, documentId: documentId),
                    );
                  },
                ),
                GoRoute(
                  path: prayerRequest.substring(1),
                  name: prayerRequest.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const PrayerRequestView(),
                    );
                  },
                ),
                GoRoute(
                  path: submitPraiseReport.substring(1),
                  name: submitPraiseReport.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const SubmitPraiseReportView(),
                    );
                  },
                ),
                GoRoute(
                  path: submitSpecialRequest.substring(1),
                  name: submitSpecialRequest.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const SubmitSpecialRequestView(),
                    );
                  },
                ),
                GoRoute(
                  path: contactChurchOffice.substring(1),
                  name: contactChurchOffice.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const ContactChurchOfficeView(),
                    );
                  },
                ),
                GoRoute(
                  path: basic.substring(1),
                  name: basic.substring(1),
                  pageBuilder: (context, state) {
                    String? collection;
                    String? documentId;
                    String type = "";
                    final notificationPayload =
                        state.extra as Map<String, dynamic>?;
                    if (notificationPayload != null &&
                        notificationPayload.isNotEmpty) {
                      collection = notificationPayload["collection"];
                      documentId = notificationPayload["documentId"];
                      type = notificationPayload["type"];
                    }
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: BasicsView(
                        type: type,
                        collection: collection,
                        documentId: documentId,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: socialMedia.substring(1),
                  name: socialMedia.substring(1),
                  pageBuilder: (context, state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: const SocialMediaView(),
                    );
                  },
                ),
              ],
              pageBuilder: (context, state) {
                return MaterialPage<void>(
                  key: state.pageKey,
                  child: const HomeView(),
                );
              },
            ),
          ]),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
          body: Center(
        child: Text(
          'Page not found: ${state.path}\n'
          'This is the default error page.\n',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    ),
    redirect: (context, state) {
      final loginLoc = state.namedLocation(login.substring(1));
      final homename = state.namedLocation(home.substring(1));
      final createUserLoc = state.namedLocation(createUser.substring(1));

      final loggedIn = loginState.isLoggedIn;

      final loggingIn = state.location == loginLoc;
      final isCreateUser = state.location == createUserLoc;

      if (!loggedIn && isCreateUser) return createUserLoc;
      if (!loggedIn && !loggingIn) return loginLoc;
      if (loggedIn && loggingIn) return homename;
      return null;
    },
  );

  //Loading related functions
  @override
  CancelFunc showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false}) {
    return BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return AppLoadingWidget(
            onClose: kDebugMode
                ? cancelFunc
                : showCancelButton
                    ? cancelFunc
                    : null);
      },
      clickClose: barrierDismissible,
      allowClick: false,
      backButtonBehavior: BackButtonBehavior.ignore,
    );
  }

  @override
  void closeLoading() {
    BotToast.closeAllLoading();
  }

  @override
  Future<T> futureLoading<T>(Future<T> Function() future) async {
    if (GlobalConstants.enableLoadingIndicator) {
      CancelFunc cancel = showLoading();
      T result = await future();
      cancel();
      return result;
    } else {
      T result = await future();
      return result;
    }
  }

  @override
  Future<bool?> showAlert(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete file permanently?'),
              content: const Text(
                'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
              ),
              actions: [
                FilledButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    context.pop(true);
                  },
                ),
                FilledButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.pop(false),
                ),
              ],
            ));
  }

  @override
  void showSuccess(String msg) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: null,
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: const Text('Success'),
              actions: [
                ElevatedButton(
                  onPressed: cancelFunc,
                  child: const Text('Close'),
                ),
              ],
              content: Text(msg),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  void showFail(String msg, {VoidCallback? onClose}) {
    CancelFunc cancel = BotToast.showCustomText(
      duration: null,
      wrapToastAnimation: (controller, cancelFunc, widget) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                cancelFunc();
              },
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.value,
                    child: child,
                  );
                },
                child: const SizedBox.expand(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: widget,
              ),
            ),
          ],
        );
      },
      toastBuilder: (cancelFunc) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.black38,
            ),
            child: AlertDialog(
              icon: const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              title: const Text('Error'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cancelFunc();
                    onClose?.call();
                  },
                  child: const Text('Close'),
                ),
              ],
              content: Text(msg, textAlign: TextAlign.center),
              contentTextStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ));
      },
    );
  }

  @override
  Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = false,
  }) async {
    return await showDialog<T>(
      barrierDismissible: kDebugMode ? true : barrierDismissible,
      context: context,
      builder: builder,
    );
  }
}
