// ignore_for_file: empty_catches

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirestoreDep {
  //create singleton
  static final FirestoreDep _firestoreDep = FirestoreDep._internal();

  FirestoreDep._internal();

  factory FirestoreDep() => _firestoreDep;

  //create instance
  static FirestoreDep get instance => _firestoreDep;

  final deps = DependencyManager.instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String usersCn = 'users';
  static String ceremonyCn = 'ceremony';
  static String devotionCn = 'devotion';
  static String praiseReportCn = 'praise_report';
  static String churchScheduleCn = 'church_schedule';
  static String prayerRequestCn = 'prayer_request';
  static String specialRequestCn = 'special_request';
  static String pastoralCareCn = 'pastoral_care';
  static String contactChurchCn = 'contact_church';
  static String basicCn = 'basic';
  static String socialMediaCn = 'social_media';

  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  FirebaseFirestore get fire => _fire;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  static const String messagingTopic = "send-scheduled-notifications";

  ///! Use this only for mobile
  UserMd? signedInUser;

  //write a function wich returns and required a javascript object with these values
// route
// collection
// documentId

  Map<String, String> _makePayload(
      {required String route,
      required String collection,
      required String documentId,
      required String title,
      String? type}) {
    return {
      "route": route,
      "collection": collection,
      "documentId": documentId,
      "title": title,
      "seconds": "1",
      "timezone": "Asia/Dubai",
      "type": type ?? "",
    };
  }

  Future<Either<bool, String>> sendNotification(
      Map<String, String> payload) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAzrlCq0o:APA91bEEyUiXkVg_MmSdoIgaitqqhvh3dfSJK0o9foD-Z1Ri-RH7rutWM4bF816BYupsJppipIJYzkbcBZT3wn7WXEwzBBwyY2OnD3nQh7jGdmerLGHUzXeCK9y_aDG5eE7MoXjw9OyF',
      };
      final res = await Dio(BaseOptions(
        baseUrl: "https://fcm.googleapis.com/fcm",
        headers: headers,
      )).post('/send', data: {
        "to": "/topics/$messagingTopic",
        "data": payload,
      });
      Logger.i("Notification sent ${res.statusCode}", tag: "sendNotification");
      return Left(res.statusCode == 200);
    } on DioException catch (e) {
      Logger.e(e.error.toString(), tag: "sendNotification DioException");
      return Right(e.toString());
    } catch (e) {
      Logger.e(e.toString(), tag: "sendNotification");
      return Right(e.toString());
    }
  }

  //Get collectionBasedListStream
  Stream<List<T>> getCollectionBasedListStream<T>({
    required String collection,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    String? orderByKey,
    dynamic orderByValue,
  }) {
    if (orderByKey != null) {
      return _fire
          .collection(collection)
          .withConverter<T>(
              fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
              toFirestore: (dev, _) => toJson(dev))
          .where(orderByKey, isEqualTo: orderByValue)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());
    }
    return _fire
        .collection(collection)
        .withConverter<T>(
            fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
            toFirestore: (dev, _) => toJson(dev))
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  //Get collectionBasedListFuture
  Future<Either<List<T>, String>> getCollectionBasedListFuture<T>({
    required String collection,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final res = await _fire.collection(collection).get();
      final list = res.docs.map((e) => fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //findByCollectionAndDocumentId<T>
  Future<T?> findByCollectionAndDocumentId<T>({
    required String collection,
    required String documentId,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final res = await _fire.collection(collection).doc(documentId).get();
      if (res.data() == null) return null;
      return fromJson(res.data()!);
    } catch (e) {
      return null;
    }
  }

  ///Add new user to firestore
  ///returns Left with error message,
  ///return Right with the generated PIN
  Future<Either<String, String>> createUser({
    required String name,
    required String email,
    required String phone,
  }) async {
    int step = 1;
    try {
      //1. create a password using crypto
      final password = sha1Generator(email, name, phone);
      Logger.d("Hashed Password: $password", tag: "Step - $step");
      step++;
      //2. create a user in firebase auth with email and generated password
      try {
        final newUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (newUser.user == null) return const Left("Error creating user");
        await FirebaseAuth.instance.signOut();
        Logger.d("User Created: ${newUser.user!.uid}", tag: "Step - $step");
        step++;
        //3. generate a 5 digits + letters pin for the user
        final pin = generatePin(password);
        Logger.d("Generated Pin: $pin", tag: "Step - $step");
        step++;
        //4. create a user in firestore with the generated pin
        final createdDbUser =
            await firestoreHandler(_fire.collection(usersCn).add(UserMd(
                  id: newUser.user!.uid,
                  name: name,
                  email: email,
                  phone: phone,
                  pin: pin,
                  password: password,
                  isAdmin: false,
                  createdAt: DateTime.now(),
                  isBanned: false,
                ).toJson()));

        return createdDbUser.fold((l) => Left(l), (r) => Right(pin));
      } on FirebaseAuthException catch (e) {
        return Left(e.message ?? "Error creating user");
      } catch (e) {
        return Left(e.toString());
      }
      //4. create a user in firestore with the generated pin
    } catch (e) {
      Logger.e(e.toString());
      rethrow;
    }
  }

  Future<Either<String, UserMd>> getUserByPin(String pin) {
    return _fire
        .collection(usersCn)
        .where("pin", isEqualTo: pin)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return const Left("User not found");
      } else {
        return Right(UserMd.fromJson(value.docs.first.data()));
      }
    });
  }

  //Get users
  Future<Either<List<UserMd>, String>> getUsers() async {
    try {
      final res = await _fire.collection(usersCn).get();
      final list = res.docs.map((e) => UserMd.fromJson(e.data())).toList();

      //Handle notification count
      final int unreviewedCount =
          list.fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
      adminDestinations["users"]?['badgeCount'] = unreviewedCount;
      DependencyManager.instance.appDep.restart?.call();
      //Handle notification count

      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //create a function which updates the user's [key] to [value]
  Future<Either<String, void>> updateUserData(
      String key, dynamic value, String userId) async {
    final data = {key: value};
    //find the docId of the user
    try {
      final res =
          await _fire.collection(usersCn).where("id", isEqualTo: userId).get();
      if (res.docs.isEmpty) return const Left("User not found");
      return await firestoreHandler(
          _fire.collection(usersCn).doc(res.docs.first.id).update(data));
    } catch (e) {
      return Left(e.toString());
    }
  }

  //post or update ceremony
  Future<Either<String, void>> createOrUpdateCeremony(
      {required YoutubeContentMd model, bool sendNotification = false}) async {
    final docs = await _fire
        .collection(ceremonyCn)
        .where("id", isEqualTo: model.id)
        .get();

    payload(String id) {
      return _makePayload(
          route: model.isUae ? "uaeYt" : "ministryDilkumar",
          collection: ceremonyCn,
          documentId: id,
          title: model.isUae ? "Video KRCI" : "Video");
    }

    if (docs.docs.isEmpty) {
      //create
      var m = YoutubeContentMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uploadedBy: currentUser!.uid,
        uploadedAt: DateTime.now(),
      );

      return firestoreHandler<DocumentReference>(
              _fire.collection(ceremonyCn).add(m.toJson()))
          .then((value) async {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(ceremonyCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
      // .then((value) async {
      // if (sendNotification) {
      //   this.sendNotification(payload(docs.docs.first.id));
      // }
      // return value;
      // });
    }
  }

  Future<Either<List<YoutubeContentMd>, String>> getCeremonies(
      {bool isUae = false}) async {
    try {
      final res = await _fire.collection(ceremonyCn).get();
      final list = res.docs
          .map((e) => YoutubeContentMd.fromJson(e.data()))
          .toList()
          .where((element) => element.isUae == isUae)
          .toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //Delete ceremony
  Future<Either<String, void>> deleteCeremony(String id) async {
    Logger.d('deleteCeremony: $id');
    final docs =
        await _fire.collection(ceremonyCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(ceremonyCn).doc(docs.docs.first.id).delete());
  }

  //get uae_yt
  Future<Either<List<YoutubeContentMd>, String>> getUaeYoutube() async {
    return getCeremonies(isUae: true);
  }

  //create or update devotion
  Future<Either<String, void>> createOrUpdateDevotion(
      {required DevotionMd model,
      Uint8List? image,
      bool sendNotification = false}) async {
    final docs = await _fire
        .collection(devotionCn)
        .where("id", isEqualTo: model.id)
        .get();
    if (docs.docs.isEmpty) {
      //create
      var m = DevotionMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uploadedBy: currentUser!.uid,
        uploadedAt: DateTime.now(),
        scheduledAt: DateTime.now(),
      );

      //upload image
      if (image != null) {
        final res = await DependencyManager.instance.fireStorage.uploadImage(
            data: image, path: "${FirestoreDep.devotionCn}/${m.id}");
        if (res.isLeft) {
          //error
          Logger.e("Error uploading image: ${res.left}");
          return Left(res.left);
        }
      }

      return firestoreHandler(_fire.collection(devotionCn).add(m.toJson()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(_makePayload(
              route: m.isScripture ? "scripture" : "dailyDevotion",
              collection: devotionCn,
              documentId: value.right.id,
              title: m.isScripture ? "Scripture" : "Devotion"));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(devotionCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  Future<Either<List<DevotionMd>, String>> getDevotions(
      {bool showScheduled = true, bool isScripture = false}) async {
    try {
      final collections = _fire.collection(devotionCn);
      final docs = [];
      final scheduled = await collections.get();
      docs.addAll(scheduled.docs);
      final list = docs
          .map((e) => DevotionMd.fromJson(e.data()))
          .toList()
          .where((element) => element.isScripture == isScripture)
          .where((element) => showScheduled ? true : element.isVisible)
          .toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //Delete Daily devotion
  Future<Either<String, void>> deleteDailyDevotion(String id) async {
    Logger.d('deleteDailyDevotion: $id');
    final docs =
        await _fire.collection(devotionCn).where("id", isEqualTo: id).get();
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteImage("${FirestoreDep.devotionCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(devotionCn).doc(docs.docs.first.id).delete());
  }

  //get scripture (PS: same as daily devotion)
  Future<Either<List<DevotionMd>, String>> getScriptures(
      {bool showScheduled = true}) async {
    return getDevotions(showScheduled: showScheduled, isScripture: true);
  }

  ///Get praise report
  Future<Either<List<PraiseReportMd>, String>> getPraiseReports() async {
    try {
      final res = await _fire.collection(praiseReportCn).get();
      final list =
          res.docs.map((e) => PraiseReportMd.fromJson(e.data())).toList();

      //Handle notification count
      final int unreviewedCount =
          list.fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
      adminDestinations["praiseReport"]?['badgeCount'] = unreviewedCount;
      deps.appDep.restart?.call();
      //Handle notification count

      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //create or update praise report
  Future<Either<String, void>> createOrUpdatePraiseReport(
      {required PraiseReportMd model,
      required List<Uint8List> images,
      List? mobileImages,
      bool sendNotification = false}) async {
    final docs = await _fire
        .collection(praiseReportCn)
        .where("id", isEqualTo: model.id)
        .get();

    payload(String id) {
      return _makePayload(
          route: "praiseReport",
          collection: praiseReportCn,
          documentId: id,
          title: "Praise Report");
    }

    if (docs.docs.isEmpty) {
      //create
      var m = PraiseReportMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uploadedBy: currentUser!.uid,
        uploadedAt: DateTime.now(),
      );

      //upload image
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          try {
            final imageData = images[i];
            final res = await DependencyManager.instance.fireStorage
                .uploadImage(
                    data: imageData,
                    path: "${FirestoreDep.praiseReportCn}/${m.id}/$i");
            if (res.isLeft) {
              //error
              Logger.e("Error uploading image: ${res.left}");
            }
          } catch (e) {}
        }
      }
      if (mobileImages != null && mobileImages.isNotEmpty) {
        for (int i = 0; i < mobileImages.length; i++) {
          try {
            final imageData = mobileImages[i];
            final res = await DependencyManager.instance.fireStorage.uploadFile(
                file: imageData,
                path: "${FirestoreDep.praiseReportCn}/${m.id}/$i");
            if (res.isLeft) {
              //error
              Logger.e("Error uploading image: ${res.left}");
            }
          } catch (e) {}
        }
      }

      return firestoreHandler(_fire.collection(praiseReportCn).add(m.toJson()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(praiseReportCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
      // .then((value) {
      // if (sendNotification) {
      //   this.sendNotification(payload(docs.docs.first.id));
      // }
      // return value;
      // });
    }
  }

  ///Delete praise report
  Future<Either<String, void>> deletePraiseReport(String id) async {
    Logger.d('deletePraiseReport: $id');
    final docs =
        await _fire.collection(praiseReportCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.praiseReportCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(praiseReportCn).doc(docs.docs.first.id).delete());
  }

  //make one function for create or update church schedule, it used ContentMd model
  Future<Either<String, void>> createOrUpdateChurchSchedule(
      {required ContentMd model, bool sendNotification = false}) async {
    final docs = await _fire
        .collection(churchScheduleCn)
        .where("id", isEqualTo: model.id)
        .get();

    payload(String id) {
      return _makePayload(
          route: "churchSchedule",
          collection: churchScheduleCn,
          documentId: id,
          title: "Church Schedule");
    }

    if (docs.docs.isEmpty) {
      //create
      var m = ContentMd.init();
      m = model.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          uploadedAt: DateTime.now(),
          uploadedBy: currentUser!.uid);
      return firestoreHandler(
              _fire.collection(churchScheduleCn).add(m.toJson()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(churchScheduleCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
      // .then((value) {
      // if (sendNotification) {
      //   this.sendNotification(payload(docs.docs.first.id));
      // }
      // return value;
      // });
    }
  }

  //get church schedule
  Future<Either<List<ContentMd>, String>> getChurchSchedule() async {
    try {
      final res = await _fire.collection(churchScheduleCn).get();
      final list = res.docs.map((e) => ContentMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //delete church schedule
  Future<Either<String, void>> deleteChurchSchedule(String id) async {
    Logger.d('deleteChurchSchedule: $id');
    final docs = await _fire
        .collection(churchScheduleCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(churchScheduleCn).doc(docs.docs.first.id).delete());
  }

  //make one function for create or update pastoral care, it used ContentMd model
  Future<Either<String, void>> createOrUpdatePastoralCare(
      {required ContentMd model, bool sendNotification = false}) async {
    final docs = await _fire
        .collection(pastoralCareCn)
        .where("id", isEqualTo: model.id)
        .get();

    payload(String id) {
      return _makePayload(
          route: "pastoralCare",
          collection: pastoralCareCn,
          documentId: id,
          title: "Pastoral Care");
    }

    if (docs.docs.isEmpty) {
      //create
      var m = ContentMd.init();
      m = model.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          uploadedAt: DateTime.now(),
          uploadedBy: currentUser!.uid);
      return firestoreHandler(_fire.collection(pastoralCareCn).add(m.toJson()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(pastoralCareCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
      // .then((value) {
      // if (sendNotification) {
      //   this.sendNotification(payload(docs.docs.first.id));
      // }
      // return value;
      // });
    }
  }

  //get church schedule
  Future<Either<List<ContentMd>, String>> getPastoralCare() async {
    try {
      final res = await _fire.collection(pastoralCareCn).get();
      final list = res.docs.map((e) => ContentMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //delete church schedule
  Future<Either<String, void>> deletePastoralCare(String id) async {
    Logger.d('deletePastoralCare: $id');
    final docs =
        await _fire.collection(pastoralCareCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(pastoralCareCn).doc(docs.docs.first.id).delete());
  }

  //get prayer requests
  Future<Either<List<PrayerRequestMd>, String>> getPrayerRequests() async {
    try {
      final res = await _fire.collection(prayerRequestCn).get();
      final list =
          res.docs.map((e) => PrayerRequestMd.fromJson(e.data())).toList();
      //Handle notification count
      final int unreviewedCount =
          list.fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
      adminDestinations["prayerRequests"]?['badgeCount'] = unreviewedCount;
      DependencyManager.instance.appDep.restart?.call();
      //Handle notification count
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //post or update prayer request
  Future<Either<String, void>> createOrUpdatePrayerRequest(
      {required PrayerRequestMd model}) async {
    final docs = await _fire
        .collection(prayerRequestCn)
        .where("id", isEqualTo: model.id)
        .get();
    if (docs.docs.isEmpty) {
      //create
      var m = PrayerRequestMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        submittedBy: currentUser!.uid,
        uploadDate: DateTime.now(),
        fullname: signedInUser!.name,
        email: signedInUser!.email,
        contactNo: signedInUser!.phone,
      );
      return firestoreHandler(
          _fire.collection(prayerRequestCn).add(m.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(prayerRequestCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //delete prayer request
  Future<Either<String, void>> deletePrayerRequest(String id) async {
    Logger.d('deletePrayerRequest: $id');
    final docs = await _fire
        .collection(prayerRequestCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(prayerRequestCn).doc(docs.docs.first.id).delete());
  }

  //get special requests
  Future<Either<List<SpecialRequestMd>, String>> getSpecialRequests() async {
    try {
      final res = await _fire.collection(specialRequestCn).get();
      final list =
          res.docs.map((e) => SpecialRequestMd.fromJson(e.data())).toList();

      //Handle notification count
      final int unreviewedCount =
          list.fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
      adminDestinations["specialRequests"]?['badgeCount'] = unreviewedCount;
      DependencyManager.instance.appDep.restart?.call();
      //Handle notification count

      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //post or update special request
  Future<Either<String, void>> createOrUpdateSpecialRequest(
      {required SpecialRequestMd model}) async {
    final docs = await _fire
        .collection(specialRequestCn)
        .where("id", isEqualTo: model.id)
        .get();
    if (docs.docs.isEmpty) {
      //create
      var m = SpecialRequestMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        submittedBy: currentUser!.uid,
      );
      return firestoreHandler(
          _fire.collection(specialRequestCn).add(m.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(specialRequestCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //delete special request
  Future<Either<String, void>> deleteSpecialRequest(String id) async {
    Logger.d('deleteSpecialRequest: $id');
    final docs = await _fire
        .collection(specialRequestCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(specialRequestCn).doc(docs.docs.first.id).delete());
  }

  // create or update contact church
  Future<Either<String, void>> createOrUpdateContactChurch(
      {required ChurchContactMd model}) async {
    final docs = await _fire
        .collection(contactChurchCn)
        .where("id", isEqualTo: model.id)
        .get();
    if (docs.docs.isEmpty) {
      //create
      var m = ChurchContactMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        submittedBy: currentUser!.uid,
        email: signedInUser!.email,
        contactNo: signedInUser!.phone,
        fullname: signedInUser!.name,
      );
      return firestoreHandler(
          _fire.collection(contactChurchCn).add(m.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(contactChurchCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //get contact church
  Future<Either<List<ChurchContactMd>, String>> getChurchContacts() async {
    try {
      final res = await _fire.collection(contactChurchCn).get();
      final list =
          res.docs.map((e) => ChurchContactMd.fromJson(e.data())).toList();

      //Handle notification count
      final int unreviewedCount =
          list.fold(0, (p, e) => p + (e.isReviewedByAdmin ? 0 : 1));
      adminDestinations["contactChurchOffice"]?['badgeCount'] = unreviewedCount;
      DependencyManager.instance.appDep.restart?.call();
      //Handle notification count

      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //delete contact church
  Future<Either<String, void>> deleteContactChurch(String id) async {
    Logger.d('deleteContactChurch: $id');
    final docs = await _fire
        .collection(contactChurchCn)
        .where("id", isEqualTo: id)
        .get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(contactChurchCn).doc(docs.docs.first.id).delete());
  }

  //get basic
  Future<Either<List<BasicMd>, String>> getBasics({
    String? filterKey,
    dynamic filterValue,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>> res;
      if (filterKey != null &&
          filterValue != null &&
          filterValue != basicTypes['all']) {
        res = await _fire
            .collection(basicCn)
            .where(filterKey, isEqualTo: filterValue)
            .get();
      } else {
        res = await _fire.collection(basicCn).get();
      }

      final list = res.docs.map((e) => BasicMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //create or update basic
  Future<Either<String, void>> createOrUpdateBasic(
      {required BasicMd model,
      required List<Uint8List> images,
      bool sendNotification = false}) async {
    final docs =
        await _fire.collection(basicCn).where("id", isEqualTo: model.id).get();

    payload(String id) {
      return _makePayload(
        route: "basic",
        collection: basicCn,
        documentId: id,
        title: "content in ${model.type}",
        type: model.type,
      );
    }

    if (docs.docs.isEmpty) {
      //create
      var m = BasicMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        submittedBy: currentUser!.uid,
        uploadDate: DateTime.now(),
      );

      //upload image
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          try {
            final imageData = images[i];
            final res = await DependencyManager.instance.fireStorage
                .uploadImage(
                    data: imageData,
                    path: "${FirestoreDep.basicCn}/${m.id}/$i");
            if (res.isLeft) {
              //error
              Logger.e("Error uploading image: ${res.left}");
            }
          } catch (e) {}
        }
      }

      return firestoreHandler(_fire.collection(basicCn).add(m.toJson()))
          .then((value) {
        if (sendNotification) {
          this.sendNotification(payload(value.right.id));
        }
        return value;
      });
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(basicCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
      // .then((value) {
      // if (sendNotification) {
      //   this.sendNotification(payload(docs.docs.first.id));
      // }
      // return value;
      // });
    }
  }

  //Delete basic
  Future<Either<String, void>> deleteBasic(String id) async {
    Logger.d('deleteBasic: $id');
    final docs =
        await _fire.collection(basicCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    try {
      //delete recursively
      await DependencyManager.instance.fireStorage
          .deleteFolder("${FirestoreDep.basicCn}/$id");
    } catch (e) {
      Logger.e(e.toString());
    }
    return firestoreHandler(
        _fire.collection(basicCn).doc(docs.docs.first.id).delete());
  }

  //create or update social media
  Future<Either<String, void>> createOrUpdateSocialMedia(
      {required BasicMd model}) async {
    final docs = await _fire
        .collection(socialMediaCn)
        .where("id", isEqualTo: model.id)
        .get();
    if (docs.docs.isEmpty) {
      //create
      var m = BasicMd.init();
      m = model.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        submittedBy: currentUser!.uid,
        uploadDate: DateTime.now(),
      );
      return firestoreHandler(_fire.collection(socialMediaCn).add(m.toJson()));
    } else {
      //updateNew DP
      return firestoreHandler(_fire
          .collection(socialMediaCn)
          .doc(docs.docs.first.id)
          .update(model.toJson()));
    }
  }

  //get social media
  Future<Either<List<BasicMd>, String>> getSocialMedia() async {
    try {
      final res = await _fire.collection(socialMediaCn).get();
      final list = res.docs.map((e) => BasicMd.fromJson(e.data())).toList();
      return Left(list);
    } catch (e) {
      return Right(e.toString());
    }
  }

  //delete social media
  Future<Either<String, void>> deleteSocialMedia(String id) async {
    Logger.d('deleteSocialMedia: $id');
    final docs =
        await _fire.collection(socialMediaCn).where("id", isEqualTo: id).get();
    Logger.i("Found docs: ${docs.docs.first.id}");
    return firestoreHandler(
        _fire.collection(socialMediaCn).doc(docs.docs.first.id).delete());
  }
}

Future<Either<String, T>> firestoreHandler<T>(Future callback) async {
  try {
    final res = await callback;
    Logger.i("Firestore Success");
    return Right(res as T);
  } on FirebaseException catch (e) {
    Logger.e("Firestore Error FException: ${e.message}");
    Logger.e("Firestore Error FException stack trace: ${e.stackTrace}");
    return Left(e.message ?? 'Error occurred');
  } catch (e) {
    Logger.e("Firestore Error catch: ${e.toString()}");
    return Left(e.toString());
  }
}

String prepareLinkForUpload(String link) {
  final int? firstIndexOfWhiteSpace =
      !link.contains(" ") ? null : link.indexOf(" ");
  //remove all after first whitespace
  if (firstIndexOfWhiteSpace != null) {
    return link.substring(0, firstIndexOfWhiteSpace);
  } else {
    return link;
  }
}
