import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class IMCANavigation {
  final MCALoginState loginState = MCALoginState();

  GlobalKey<NavigatorState> get navigatorKey;

  RouteObserver<PageRoute> get routeObserver;

  GoRouter get router;

  //Loading related functions
  void Function() showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false});

  void closeLoading();

  Future<T> futureLoading<T>(Future<T> Function() future);

  Future<bool?> showAlert(BuildContext context);

  void showSuccess(String msg);

  void showFail(String msg);

  Future<T?> showCustomDialog<T>(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool barrierDismissible = false});
}

class MCALoginState extends ChangeNotifier {
  ///Do not use this class directly, use [DependencyManager.instance.navigation.loginState] instead
  ///
  /// Do not use [DependencyManager.instance] inside this class
  MCALoginState() {
    init();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<Either<String, bool>> login(String email, String pwd) async {
    try {
      final success = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pwd);
      if (success.user != null) {
        if (_isLoggedIn) return const Right(true);
        Logger.i("Login success for $email");
      } else {
        // _isLoggedIn = false;
        // notifyListeners();
        Logger.e("Login failed for $email");
      }
      return Right(success.user != null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> loginWithPin(String pin) async {
    int step = 1;
    try {
      try {
        //1. find user from users collection with pin
        final user = await DependencyManager.instance.firestore
            .getUserByPin(pin.toLowerCase());
        Logger.d("User found with pin $pin", tag: 'Step - $step');
        step++;
        if (user.isRight) {
          //check if the user is banned
          if (user.right.isBanned) {
            //if banned, return ban error
            return const Left("Please contact KRCI Team");
          }
          //if not banned, continue
          //success
          //2. if user found, login with email and password
          final success = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: user.right.email, password: user.right.password);
          if (success.user != null) {
            Logger.d("Login success for ${user.right.email}",
                tag: 'Step - $step');
            if (_isLoggedIn) return const Right(true);
          } else {
            Logger.e("Login failed for ${user.right.email}");
            return const Left("PIN is incorrect or user not found");
          }
        } else if (user.isLeft) {
          //3. if user not found, throw error
          Logger.e("User not found with pin $pin");
          //error
          return Left(user.left);
        }
      } catch (e) {
        Logger.e(e.toString(), tag: "line - 92");
        return Left(e.toString());
      }
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> logout() async {
    if (!_isLoggedIn) return;
    try {
      await FirebaseAuth.instance.signOut();
      Logger.e("Logout success");
    } on FirebaseAuthException catch (e) {
      Logger.e(e);
    } catch (e) {
      Logger.e(e);
    }
  }

  Future<Either<String, bool>> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Logger.i("Password reset for $email");
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      Logger.e(e);
      return Left(e.message ?? e.toString());
    } catch (e) {
      Logger.e(e);
      return Left(e.toString());
    }
  }

  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        _isLoggedIn = false;
        notifyListeners();
        debugPrint('User is currently signed out!');
      } else {
        _isLoggedIn = true;
        notifyListeners();
        debugPrint('User is signed in!');

        ///Find current user and assign it
        if (!kIsWeb) {
          final foundUser = await DependencyManager.instance.firestore.fire
              .collection(FirestoreDep.usersCn)
              .where("id",
                  isEqualTo:
                      DependencyManager.instance.firestore.currentUser!.uid)
              .withConverter(fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return UserMd.fromJson(data);
          }, toFirestore: (value, options) {
            return value.toJson();
          }).get();
          if (foundUser.docs.isNotEmpty) {
            Logger.i(
                "Found user and assigned to signedInUser. ${foundUser.docs.first.data()}");
            DependencyManager.instance.firestore.signedInUser =
                foundUser.docs.first.data();
            DependencyManager.instance.appDep.restart?.call();

            // ///Handling FCM token
            //
            // Future<void> saveTokenToUserDatabase(String token) async {
            //   try {
            //     // Assume user is logged in for this example
            //     String userId =
            //         DependencyManager.instance.firestore.currentUser!.uid;
            //     foundUser.docs.first.reference.update({
            //       'tokens': FieldValue.arrayUnion([token]),
            //     });
            //   } catch (e) {
            //     Logger.e(e.toString(), tag: "saveTokenToUserDatabases");
            //   }
            // }
            //
            // String? token = await FirebaseMessaging.instance.getToken();
            // if (token != null) {
            //   Logger.i("FCM token: $token");
            //   await saveTokenToUserDatabase(token);
            // }
            // FirebaseMessaging.instance.onTokenRefresh
            //     .listen(saveTokenToUserDatabase);
            //
            // ///End of handling FCM token
          } else {
            _isLoggedIn = false;
            notifyListeners();
            Logger.e("User not found");
            return;
          }
        }

        if (kIsWeb) {
          ///HANDLE NOTIFICATION COUNT FOR INITIAL LOAD
          ///
          //handling notification count for PRAYER REQUEST
          DependencyManager.instance.firestore
              .getPrayerRequests()
              .then((value) {
            if (value.isLeft) {
              final int unreviewedCount = value.left
                  .fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
              adminDestinations["prayerRequests"]?['badgeCount'] =
                  unreviewedCount;
              DependencyManager.instance.appDep.restart?.call();
            }
          });

          //handling notification count for PRAISE REPORT
          DependencyManager.instance.firestore.getPraiseReports().then((value) {
            if (value.isLeft) {
              final int unreviewedCount = value.left
                  .fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
              adminDestinations["praiseReport"]?['badgeCount'] =
                  unreviewedCount;
              DependencyManager.instance.appDep.restart?.call();
            }
          });

          //handling notification count for SPECIAL REQUESTS
          DependencyManager.instance.firestore
              .getSpecialRequests()
              .then((value) {
            if (value.isLeft) {
              final int unreviewedCount = value.left
                  .fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
              adminDestinations["specialRequests"]?['badgeCount'] =
                  unreviewedCount;
              DependencyManager.instance.appDep.restart?.call();
            }
          });

          //handling notification count for CONTACT CHURCH OFFICE
          DependencyManager.instance.firestore
              .getChurchContacts()
              .then((value) {
            if (value.isLeft) {
              final int unreviewedCount = value.left
                  .fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
              adminDestinations["contactChurchOffice"]?['badgeCount'] =
                  unreviewedCount;
              DependencyManager.instance.appDep.restart?.call();
            }
          });

          //handling notification count for USERS
          DependencyManager.instance.firestore.getUsers().then((value) {
            if (value.isLeft) {
              final int unreviewedCount = value.left
                  .fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
              adminDestinations["users"]?['badgeCount'] = unreviewedCount;
              DependencyManager.instance.appDep.restart?.call();
            }
          });
        }
      }
    });
  }
}
