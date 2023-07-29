
class PraiseReportMd {
  final String id;
  final String title;
  final String description;
  final String? uploadedBy;
  final DateTime? uploadedAt;

  final bool isReviewedByAdmin;

  const PraiseReportMd({
    required this.id,
    required this.title,
    required this.description,
    this.uploadedBy,
    this.isReviewedByAdmin = false,
    this.uploadedAt,
  });

  //fromJson
  static PraiseReportMd fromJson(Map<String, dynamic> json) {
    return PraiseReportMd(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      uploadedBy: json['uploaded_by'],
      uploadedAt: DateTime.tryParse(json['uploaded_at']),
      isReviewedByAdmin: json['is_reviewed_by_admin'] ?? false,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'is_reviewed_by_admin': isReviewedByAdmin,
    };
  }

  //copy with
  PraiseReportMd copyWith({
    String? id,
    String? title,
    String? description,
    String? uploadedBy,
    DateTime? uploadedAt,
    bool? isReviewedByAdmin,
  }) {
    return PraiseReportMd(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isReviewedByAdmin: isReviewedByAdmin ?? this.isReviewedByAdmin,
    );
  }

  //init
  static PraiseReportMd init() {
    return const PraiseReportMd(
      id: '',
      title: '',
      description: '',
      uploadedBy: '',
      isReviewedByAdmin: false,
    );
  }
}
