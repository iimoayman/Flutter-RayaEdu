class MyData {
  final String name;
  final String photoUrl;
  final String academicYear;
  final int? code;
  final String department;
  final String level;
  final double? hours;
  final double? cgpa;
  final String guideName;
  final String? whatsapp;

  MyData({
    required this.name,
    required this.photoUrl,
    required this.academicYear,
    this.code,
    required this.department,
    required this.level,
    this.hours,
    this.cgpa,
    required this.guideName,
    this.whatsapp,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      name: json['name'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      academicYear: json['academic_year'] ?? '',
      code: json['code'] is int ? json['code'] : int.tryParse(json['code']?.toString() ?? ''),
      department: json['department']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      hours: (json['hours'] as num?)?.toDouble(),
      cgpa: (json['cgpa'] as num?)?.toDouble(),
      guideName: json['guide_name'] ?? '',
      whatsapp: json['whatapp']?.toString(),
    );
  }
}

class StudentAchievements {
  final int countMaterials;
  final int countChapters;
  final int countCompletedChapters;
  final int countExamChapters;
  final int countExamChaptersDone;
  final double attendanceRate;

  StudentAchievements({
    required this.countMaterials,
    required this.countChapters,
    required this.countCompletedChapters,
    required this.countExamChapters,
    required this.countExamChaptersDone,
    required this.attendanceRate,
  });

  factory StudentAchievements.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return StudentAchievements(
      countMaterials: parseInt(json['count_materials'] ?? json['countMaterials']),
      countChapters: parseInt(json['count_chapters'] ?? json['countChapters']),
      countCompletedChapters: parseInt(json['count_completed_chapters'] ?? json['countCompletedChapters']),
      countExamChapters: parseInt(json['count_examChapters'] ?? json['count_exam_chapters'] ?? json['countExamChapters']),
      countExamChaptersDone: parseInt(json['count_examChapters_done'] ?? json['count_exam_chapters_done'] ?? json['countExamChaptersDone']),
      attendanceRate: parseDouble(json['attendanceRate'] ?? json['attendance_rate']),
    );
  }
}

class Order {
  final int id;
  final String img;
  final String link;

  Order({
    required this.id,
    required this.img,
    required this.link,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      img: json['img'] ?? '',
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'img': img, 'link': link};
}

class HuaweiSession {
  final String link;
  final String title;
  final String instructor;
  final String time;

  HuaweiSession({
    required this.link,
    required this.title,
    required this.instructor,
    required this.time,
  });

  factory HuaweiSession.fromJson(Map<String, dynamic> json) {
    return HuaweiSession(
      link: json['link'] ?? '',
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      time: json['Time'] ?? '',
    );
  }
}
