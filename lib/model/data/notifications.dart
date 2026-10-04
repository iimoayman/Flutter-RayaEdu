
class Notifications {
  final int openMaterial;
  final int chapter;
  final String type;
  final String content;
  final String createdAt;

  const Notifications({
    required this.openMaterial,
    required this.chapter,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    openMaterial: json['chapter__open_material__pk'] as int? ?? 0,
    chapter: json['chapter__pk'] as int? ?? 0,
    type: json['notification_type'] as String? ?? '',
    content: json['content'] as String? ?? '',
    createdAt: json['created_at'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'chapter__open_material__pk': openMaterial,
    'chapter__pk': chapter,
    'notification_type': type,
    'content': content,
    'created_at': createdAt,
  };
}

// ---------------------------------------------------------

class MyWarnings {
  final String termAcademicYearName;
  final String termName;
  final String statusAlert;

  const MyWarnings({
    required this.termAcademicYearName,
    required this.termName,
    required this.statusAlert,
  });

  factory MyWarnings.fromJson(Map<String, dynamic> json) => MyWarnings(
    termAcademicYearName: json['term__academic_year__name'] as String? ?? '',
    termName: json['term__name'] as String? ?? '',
    statusAlert: json['status_alert'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'term__academic_year__name': termAcademicYearName,
    'term__name': termName,
    'status_alert': statusAlert,
  };
}