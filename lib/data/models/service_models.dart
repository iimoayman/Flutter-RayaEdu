class StuServices {
  final String service;
  final String status;
  final String acceptDate;
  final String? addressed;
  final String? notesStudent;
  final String? notes;

  StuServices({
    required this.service,
    required this.status,
    required this.acceptDate,
    this.addressed,
    this.notesStudent,
    this.notes,
  });

  factory StuServices.fromJson(Map<String, dynamic> json) {
    return StuServices(
      service: json['service'] ?? '',
      status: json['status'] ?? '',
      acceptDate: json['accept_date'] ?? '',
      addressed: json['addressed'],
      notesStudent: json['notes_student'],
      notes: json['notes'],
    );
  }
}

class Notifications {
  final int openMaterial;
  final int chapter;
  final String type;
  final String content;
  final String createdAt;

  Notifications({
    required this.openMaterial,
    required this.chapter,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      openMaterial: json['chapter__open_material__pk'] ?? 0,
      chapter: json['chapter__pk'] ?? 0,
      type: json['notification_type'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class MyWarnings {
  final String termAcademicYearName;
  final String termName;
  final String statusAlert;

  MyWarnings({
    required this.termAcademicYearName,
    required this.termName,
    required this.statusAlert,
  });

  factory MyWarnings.fromJson(Map<String, dynamic> json) {
    return MyWarnings(
      termAcademicYearName: json['term__academic_year__name'] ?? '',
      termName: json['term__name'] ?? '',
      statusAlert: json['status_alert'] ?? '',
    );
  }
}
