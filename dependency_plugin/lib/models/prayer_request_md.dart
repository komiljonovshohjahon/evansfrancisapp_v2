import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dependency_plugin/helpers.dart';

final class PrayerRequestMd {
  final String id;
  final String fullname;
  final String contactNo;
  final String email;
  final String countryCode;
  final String state;
  final String city;
  final int prayerFor;
  String get prayerRequestName => prayerRequestTypes[prayerFor] ?? "";
  final String message;
  final String submittedBy;
  final DateTime uploadDate;

  final bool isReviewedByAdmin;

  const PrayerRequestMd({
    required this.id,
    required this.fullname,
    required this.contactNo,
    required this.email,
    required this.countryCode,
    required this.state,
    required this.city,
    required this.prayerFor,
    required this.message,
    required this.submittedBy,
    required this.uploadDate,
    this.isReviewedByAdmin = false,
  });

  //from json
  factory PrayerRequestMd.fromJson(Map<String, dynamic> json) =>
      PrayerRequestMd(
        id: json["id"],
        fullname: json["fullname"],
        contactNo: json["contactNo"],
        email: json["email"],
        countryCode: json["countryCode"],
        state: json["state"],
        city: json["city"],
        prayerFor: json["prayerFor"] is String ? 0 : json["prayerFor"],
        message: json["message"],
        isReviewedByAdmin: json["isReviewedByAdmin"],
        submittedBy: json["submittedBy"],
        uploadDate: json["uploadDate"] == null
            ? DateTime.now()
            : json["uploadDate"] is Timestamp
                ? DateTime.now()
                : DateTime.parse(json["uploadDate"]),
      );

  //to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "contactNo": contactNo,
        "email": email,
        "countryCode": countryCode,
        "state": state,
        "city": city,
        "prayerFor": prayerFor,
        "message": message,
        "isReviewedByAdmin": isReviewedByAdmin,
        "submittedBy": submittedBy,
        "uploadDate": uploadDate,
      };

  //copy with
  PrayerRequestMd copyWith({
    String? id,
    String? fullname,
    String? contactNo,
    String? email,
    String? countryCode,
    String? state,
    String? city,
    int? prayerFor,
    String? message,
    bool? isReviewedByAdmin,
    String? submittedBy,
    DateTime? uploadDate,
  }) {
    return PrayerRequestMd(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      state: state ?? this.state,
      city: city ?? this.city,
      prayerFor: prayerFor ?? this.prayerFor,
      message: message ?? this.message,
      isReviewedByAdmin: isReviewedByAdmin ?? this.isReviewedByAdmin,
      submittedBy: submittedBy ?? this.submittedBy,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }

  //init
  factory PrayerRequestMd.init() => PrayerRequestMd(
        id: "",
        fullname: "",
        contactNo: "",
        email: "",
        countryCode: "",
        state: "",
        city: "",
        prayerFor: 0,
        message: "",
        submittedBy: "",
        uploadDate: DateTime.now(),
      );
}
