import 'package:cloud_firestore/cloud_firestore.dart';

final class ChurchContactMd {
  final String id;
  final String fullname;
  final String contactNo;
  final String email;
  final String message;
  final String submittedBy;
  final DateTime uploadDate;

  final bool isReviewedByAdmin;

  const ChurchContactMd({
    required this.id,
    required this.fullname,
    required this.contactNo,
    required this.email,
    required this.message,
    required this.submittedBy,
    required this.uploadDate,
    this.isReviewedByAdmin = false,
  });

  //from json
  factory ChurchContactMd.fromJson(Map<String, dynamic> json) =>
      ChurchContactMd(
        id: json["id"],
        fullname: json["fullname"],
        contactNo: json["contactNo"],
        email: json["email"],
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
        "message": message,
        "isReviewedByAdmin": isReviewedByAdmin,
        "submittedBy": submittedBy,
        "uploadDate": uploadDate,
      };

  //copy with
  ChurchContactMd copyWith({
    String? id,
    String? fullname,
    String? contactNo,
    String? email,
    String? message,
    bool? isReviewedByAdmin,
    String? submittedBy,
    DateTime? uploadDate,
  }) {
    return ChurchContactMd(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      message: message ?? this.message,
      isReviewedByAdmin: isReviewedByAdmin ?? this.isReviewedByAdmin,
      submittedBy: submittedBy ?? this.submittedBy,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }

  //init
  factory ChurchContactMd.init() => ChurchContactMd(
        id: "",
        fullname: "",
        contactNo: "",
        email: "",
        message: "",
        submittedBy: "",
        uploadDate: DateTime.now(),
      );
}
