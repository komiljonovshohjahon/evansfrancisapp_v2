class ContentMd {
  final String id;
  final String title;
  final List<BasicContentMd> content;
  final String uploadedBy;
  final DateTime uploadedAt;

  bool get isNew => id.isEmpty;

  const ContentMd({
    required this.id,
    required this.title,
    required this.content,
    required this.uploadedBy,
    required this.uploadedAt,
  });

  //fromJson
  static ContentMd fromJson(Map<String, dynamic> json) {
    return ContentMd(
      id: json['id'],
      title: json['title'],
      uploadedBy: json['uploaded_by'],
      uploadedAt: DateTime.tryParse(json['uploaded_at']) ?? DateTime.now(),
      content: (json['content'] as List)
          .map((e) => BasicContentMd.fromJson(e))
          .toList(),
    );
  }

  //init
  static ContentMd init() {
    return ContentMd(
      id: '',
      title: '',
      uploadedBy: '',
      uploadedAt: DateTime.now(),
      content: [],
    );
  }

  //toJson

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt.toIso8601String(),
      'content': content.map((e) => e.toJson()).toList(),
    };
  }

  //copy with
  ContentMd copyWith({
    String? id,
    String? title,
    List<BasicContentMd>? content,
    String? uploadedBy,
    DateTime? uploadedAt,
  }) {
    return ContentMd(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  //add content
  ContentMd addContent(BasicContentMd content) {
    return copyWith(
      content: [...this.content, content],
    );
  }

  //remove content
  ContentMd removeContent(int index) {
    final newContent = content;
    newContent.removeAt(index);
    return copyWith(content: newContent);
  }

  //update content
  ContentMd updateContent(BasicContentMd content) {
    return copyWith(
      content: this.content.map((e) => e == content ? content : e).toList(),
    );
  }
}

class BasicContentMd {
  final String description;
  final String title;

  const BasicContentMd({
    required this.description,
    required this.title,
  });

  //fromJson
  static BasicContentMd fromJson(Map<String, dynamic> json) {
    return BasicContentMd(
      description: json['description'],
      title: json['title'],
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'title': title,
    };
  }

  //copy with
  BasicContentMd copyWith({
    String? description,
    String? title,
  }) {
    return BasicContentMd(
      description: description ?? this.description,
      title: title ?? this.title,
    );
  }

  //init
  static BasicContentMd init() {
    return const BasicContentMd(
      description: '',
      title: '',
    );
  }
}
