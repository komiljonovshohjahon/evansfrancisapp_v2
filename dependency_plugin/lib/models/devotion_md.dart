
final class DevotionMd {
  final String id;
  final String title;
  final String message;
  final String uploadedBy;
  final DateTime? uploadedAt;
  final DateTime? scheduledAt;

  final bool isScripture;

  bool get isVisible => scheduledAt?.isBefore(DateTime.now()) ?? false;

  const DevotionMd({
    required this.title,
    required this.message,
    required this.uploadedBy,
    this.uploadedAt,
    this.isScripture = false,
    required this.id,
    this.scheduledAt,
  });

  //fromJson
  static DevotionMd fromJson(Map<String, dynamic> json) {
    return DevotionMd(
      title: json['title'],
      uploadedBy: json['uploaded_by'],
      id: json['id'],
      message: json['message'],
      scheduledAt: json['scheduled_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['scheduled_at']),
      uploadedAt: json['uploaded_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['uploaded_at']),
      isScripture: json['is_scripture'] ?? false,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'message': message,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'is_scripture': isScripture,
    };
  }

  //copy with
  DevotionMd copyWith({
    String? id,
    String? title,
    String? message,
    String? uploadedBy,
    DateTime? uploadedAt,
    DateTime? scheduledAt,
    bool? isScripture,
  }) {
    return DevotionMd(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      isScripture: isScripture ?? this.isScripture,
    );
  }

  //init
  static DevotionMd init() {
    return const DevotionMd(
      id: '',
      title: '',
      message: '',
      uploadedBy: "",
    );
  }
}
