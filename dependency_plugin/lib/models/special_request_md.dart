import 'package:dependency_plugin/dependency_plugin.dart';

final class SpecialRequestMd {
  final String id;

  ///[specialRequestTypes]
  final int requestType;
  String get requestName => specialRequestTypes[requestType] ?? '';
  final String submittedBy;
  final DateTime uploadDate;
  final String description;

  final bool isReviewedByAdmin;

  const SpecialRequestMd({
    required this.id,
    required this.requestType,
    required this.submittedBy,
    required this.uploadDate,
    required this.description,
    this.isReviewedByAdmin = false,
  });

  //from json
  factory SpecialRequestMd.fromJson(Map<String, dynamic> json) =>
      SpecialRequestMd(
        id: json['id'] as String,
        requestType: json['requestType'] as int,
        submittedBy: json['submittedBy'] as String,
        uploadDate: json['uploadDate'] == null
            ? DateTime.now()
            : DateTime.parse(json['uploadDate'] as String),
        isReviewedByAdmin: json['isReviewedByAdmin'] as bool,
        description: json['description'] as String,
      );

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'requestType': requestType,
        'submittedBy': submittedBy,
        'uploadDate': uploadDate.toIso8601String(),
        'isReviewedByAdmin': isReviewedByAdmin,
        'description': description,
      };

  //copy with
  SpecialRequestMd copyWith({
    String? id,
    int? requestType,
    String? submittedBy,
    DateTime? uploadDate,
    bool? isReviewedByAdmin,
    String? description,
  }) {
    return SpecialRequestMd(
      id: id ?? this.id,
      requestType: requestType ?? this.requestType,
      submittedBy: submittedBy ?? this.submittedBy,
      uploadDate: uploadDate ?? this.uploadDate,
      isReviewedByAdmin: isReviewedByAdmin ?? this.isReviewedByAdmin,
      description: description ?? this.description,
    );
  }

  //init
  static SpecialRequestMd init() => SpecialRequestMd(
        id: '',
        requestType: 1,
        submittedBy: '',
        uploadDate: DateTime.now(),
        isReviewedByAdmin: false,
        description: '',
      );
}
