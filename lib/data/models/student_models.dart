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
    return StudentAchievements(
      countMaterials: json['count_materials'] ?? 0,
      countChapters: json['count_chapters'] ?? 0,
      countCompletedChapters: json['count_completed_chapters'] ?? 0,
      countExamChapters: json['count_examChapters'] ?? 0,
      countExamChaptersDone: json['count_examChapters_done'] ?? 0,
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0.0,
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
