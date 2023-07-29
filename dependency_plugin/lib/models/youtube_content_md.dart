
final class YoutubeContentMd {
  final String id;
  final String title;
  final String link;
  final String? uploadedBy;
  final DateTime? uploadedAt;

  final bool isUae;

  YoutubeContentMd({
    required this.title,
    required this.link,
    this.uploadedBy,
    this.uploadedAt,
    required this.id,
    this.isUae = false,
  });

  //fromJson
  static YoutubeContentMd fromJson(Map<String, dynamic> json) {
    return YoutubeContentMd(
      title: json['title'],
      link: json['link'],
      uploadedBy: json['uploaded_by'],
      id: json['id'],
      uploadedAt: json['uploaded_at'] == null
          ? DateTime.now()
          : DateTime.tryParse(json['uploaded_at']),
      isUae: json['is_uae'] ?? false,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'is_uae': isUae,
    };
  }

  //copyWith
  YoutubeContentMd copyWith({
    String? id,
    String? title,
    String? link,
    String? uploadedBy,
    DateTime? uploadedAt,
    bool? isUae,
  }) {
    return YoutubeContentMd(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isUae: isUae ?? this.isUae,
    );
  }

  //init
  static YoutubeContentMd init() {
    return YoutubeContentMd(
      id: "",
      title: "",
      link: "",
      uploadedBy: "",
    );
  }
}
