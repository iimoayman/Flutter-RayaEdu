class AppNotification {
  final int openMaterial;
  final int chapter;
  final String type;
  final String content;
  final String createdAt;

  const AppNotification({
    required this.openMaterial,
    required this.chapter,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
    openMaterial: (j['chapter__open_material__pk'] as num?)?.toInt() ?? 0,
    chapter: (j['chapter__pk'] as num?)?.toInt() ?? 0,
    type: j['notification_type'] as String? ?? '',
    content: j['content'] as String? ?? '',
    createdAt: j['created_at'] as String? ?? '',
  );
}

class MyWarnings {
  final String academicYearName;
  final String termName;
  final String statusAlert;

  const MyWarnings({
    required this.academicYearName,
    required this.termName,
    required this.statusAlert,
  });

  factory MyWarnings.fromJson(Map<String, dynamic> j) => MyWarnings(
    academicYearName:
    j['term__academic_year__name'] as String? ?? '',
    termName: j['term__name'] as String? ?? '',
    statusAlert: j['status_alert'] as String? ?? '',
  );
}