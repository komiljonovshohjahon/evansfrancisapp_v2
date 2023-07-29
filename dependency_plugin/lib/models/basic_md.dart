import 'package:cloud_firestore/cloud_firestore.dart';

final class BasicMd {
  final String id;
  final String title;
  final String message;
  final String submittedBy;
  final DateTime uploadDate;

  ///If true, then showAll
  final String type;

  const BasicMd({
    required this.id,
    required this.title,
    required this.message,
    required this.submittedBy,
    required this.uploadDate,
    required this.type,
  });

  //from json
  factory BasicMd.fromJson(Map<String, dynamic> json) => BasicMd(
        id: json["id"],
        message: json["message"],
        title: json["title"],
        submittedBy: json["submittedBy"],
        uploadDate: json["uploadDate"] == null
            ? DateTime.now()
            : json["uploadDate"] is Timestamp
                ? DateTime.now()
                : DateTime.parse(json["uploadDate"]),
        type: json["type"],
      );

  //to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "submittedBy": submittedBy,
        "uploadDate": uploadDate,
        "type": type,
      };

  //copy with
  BasicMd copyWith({
    String? id,
    String? title,
    String? message,
    String? submittedBy,
    DateTime? uploadDate,
    String? type,
  }) {
    return BasicMd(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      submittedBy: submittedBy ?? this.submittedBy,
      uploadDate: uploadDate ?? this.uploadDate,
      type: type ?? this.type,
    );
  }

  //init
  factory BasicMd.init() => BasicMd(
        id: "",
        title: "",
        message: "",
        submittedBy: "",
        type: "",
        uploadDate: DateTime.now(),
      );
}
